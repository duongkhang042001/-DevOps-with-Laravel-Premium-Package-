FROM node:14.21.3 AS base
WORKDIR /usr/src
ARG API_BASE_URL
ENV VUE_APP_API_BASE_URL=$API_BASE_URL
COPY ./frontend/package.* ./
RUN npm install
COPY ./frontend .

FROM base AS dev
COPY ./api/wait-for-it.sh /usr/wait-for-it.sh
EXPOSE 80
CMD ["npm", "run", "serve"]

FROM base AS build
RUN npm run build

FROM nginx:1.25.1 AS prod
COPY --from=build /usr/src/dist /usr/share/nginx/html
COPY ./deployment/config/nginx-frontend.conf /etc/nginx/nginx.conf
COPY ./api/wait-for-it.sh /usr/wait-for-it.sh
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
