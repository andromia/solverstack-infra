FROM node:14-alpine3.10

# Copy dependencies & config files
COPY package.json .
COPY yarn.lock .

# Install app dependencies
RUN yarn global add typescript
RUN yarn install --production

# Copy project files
COPY . .

# Compile TS -> JS
RUN yarn build

# Set and expose port
ENV PORT 8080
EXPOSE 8080
