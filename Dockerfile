#---- Base Node image ----
FROM node:12.16.3-alpine AS build
WORKDIR /app

#---- Dependencies ----
COPY package*.json ./
RUN npm install

#---- Build ----
COPY ./ ./
RUN npm run build && npm cache clean --force

#---- Release ----
FROM node:12.16.3-alpine
WORKDIR /app

COPY --from=build /app/package*.json ./
RUN npm install --only=production

COPY --from=build /app/dist ./app/dist

USER node
ENV PORT=4000
EXPOSE 4000

CMD [ "node", "dist/main.js" ]