#---- Base Node image ----
FROM node:12.16.3 AS base
WORKDIR /app

#---- Dependencies ----
FROM base as dependencies
COPY package*.json ./
RUN npm install

#---- Build ----
FROM dependencies AS build
WORKDIR /app
COPY ./ ./
RUN npm run build && npm cache clean --force

#---- Release with Alpine ----
FROM node:12.16.3-alpine AS release
WORKDIR /app

COPY --from=dependencies /app/package.json ./
RUN npm install --only=production

COPY --from=build /app ./
USER node
EXPOSE 4000
CMD [ "node", "dist/main.js" ]