FROM keymetrics/pm2:14-alpine

# Copy dependencies & config files
COPY package.json .
COPY yarn.lock .

# Install app dependencies
RUN yarn global add typescript
RUN yarn install

# Copy project files
COPY src src/

# Compile TS -> JS
RUN yarn build

# Set and expose port
ENV PORT 8081
EXPOSE 8081

# Start PM2 Process
CMD ["pm2-runtime", "src/server.js"]
