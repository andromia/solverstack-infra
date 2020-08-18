"""ortools model via pyords bundle concept"""
from typing import List

import numpy as np
from ortools.constraint_solver import pywrapcp, routing_enums_pb2


class VrpBasicBundle:
    def __init__(
        self,
        distance_matrix: List[List[int]],
        demand_quantities: List[int],
        max_vehicle_capacity_units: int,
        max_search_seconds: int = 5,
    ):
        """
        high level implementation of an ortools capacitated vehicle routing model.

        :distance_matrix:          [[int, int, int, ...], [...] ...] distance matrix of origin
                          at node 0 and demand nodes at 1 -> len(matrix) - 1.
        :demand_quantities:          [int, int, ... len(demand nodes) - 1]
        :max_vehicle_capacity_units:      int for vehicle capacity constraint (in demand units)
        :max_search_seconds:      int for seconds allowance for solver
        """
        self.distance_matrix = distance_matrix
        self.demand_quantities = demand_quantities

        # TODO: make this more robust
        if len(demand_quantities) == len(distance_matrix) - 1:
            self.demand_quantities = [0] + list(demand_quantities)

        self.max_vehicle_cap = max_vehicle_capacity_units
        self.max_search_seconds = max_search_seconds

        self.vehicles = self.create_vehicles()
        self.ortools()

        return None

    def create_vehicles(self):
        """
        assumes origin is position 0 in self.distance_matrix and
        defines a vehicle of max_cap for each destination.
        """
        return [self.max_vehicle_cap for i in range(len(self.distance_matrix[1:]))]

    def create_manager(self):
        return pywrapcp.RoutingIndexManager(
            len(self.distance_matrix), len(self.vehicles), 0
        )

    def matrix_callback(self, i: int, j: int):
        """index of from (i) and to (j)"""
        node_i = self.manager.IndexToNode(i)
        node_j = self.manager.IndexToNode(j)
        distance = self.distance_matrix[node_i][node_j]

        return distance

    def demand_callback(self, i: int):
        """capacity constraint"""
        demand = self.demand_quantities[self.manager.IndexToNode(i)]

        return demand

    def create_model(self):
        model = pywrapcp.RoutingModel(self.manager)

        # distance constraint setup
        model.SetArcCostEvaluatorOfAllVehicles(
            model.RegisterTransitCallback(self.matrix_callback)
        )

        # demand constraint setup
        model.AddDimensionWithVehicleCapacity(
            # function which return the load at each location (cf. cvrp.py example)
            model.RegisterUnaryTransitCallback(self.demand_callback),
            0,  # null capacity slack
            [cap for cap in self.vehicles],  # vehicle maximum capacity
            True,  # start cumul to zero
            "Capacity",
        )

        return model

    def create_search_params(self, max_seconds: int = 5):
        search_parameters = pywrapcp.DefaultRoutingSearchParameters()
        search_parameters.first_solution_strategy = (
            routing_enums_pb2.FirstSolutionStrategy.PATH_CHEAPEST_ARC
        )
        search_parameters.time_limit.seconds = max_seconds

        return search_parameters

    def get_solution(self):
        # positions in matrix (demand)
        vehicles = np.zeros(len(self.demand_quantities) - 1)
        stops = np.zeros(len(self.demand_quantities) - 1)

        # original solution building
        for vehicle in range(len(self.vehicles)):
            i = self.model.Start(vehicle)
            vehicle_stops = []

            while not self.model.IsEnd(i):
                node = self.manager.IndexToNode(i)

                if node != 0:
                    vehicles[node - 1] = vehicle
                    vehicle_stops.append(node - 1)

                i = self.assignment.Value(self.model.NextVar(i))

            stops[vehicle_stops] = list(range(len(vehicle_stops)))

        stops = stops + 1

        # NOTE: returning vehicle assignments only
        return {"id": vehicles, "stops": stops}

    def ortools(self):
        """init of ortools modeling"""
        self.manager = self.create_manager()
        self.model = self.create_model()

        return self

    def run(self, max_search_seconds: int = 30):
        search = self.create_search_params(max_search_seconds)
        self.assignment = self.model.SolveWithParameters(search)

        return self


def create_vehicles(
    distance_matrix: List[List[int]],
    demand_quantities: List[int],
    clusters: List[int],
    max_vehicle_capacity_units: int = 26,
):
    """
    solve by cluster and return assigned list of vehicles
    
    :matrix:      list of lists for all-to-all distances (includes origin)
    :demand:      list of demand (includes origin zero'd)
    :clusters:    numpy array of cluster output. length is matrix|demand - 1

    returns vehicles:list
    """
    vehicles = np.zeros(len(demand_quantities) - 1)
    stops = np.zeros(len(demand_quantities) - 1)
    distance_matrix = np.array(distance_matrix)
    demand_quantities = np.array(demand_quantities)

    for i, c in enumerate(np.unique(clusters)):

        # align with matrix, demand_quantities
        is_cluster = np.where(clusters == c)[0]
        is_cluster = is_cluster + 1
        is_cluster = np.insert(is_cluster, 0, 0)

        bndl = VrpBasicBundle(
            distance_matrix=distance_matrix[is_cluster],
            demand_quantities=demand_quantities[is_cluster],
            max_vehicle_capacity_units=max_vehicle_capacity_units,
        )

        # list of vehcles # NOTE: will change
        solution = bndl.run().get_solution()

        # assign
        is_cluster = is_cluster[is_cluster != 0] - 1
        vehicles[is_cluster] = [f"{int(c)}{int(v)}{i}" for v in solution["id"]]
        stops[is_cluster] = solution["stops"]

    return {"id": vehicles, "stops": stops}
