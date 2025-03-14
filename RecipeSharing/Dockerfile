# Use an official Node.js image to build the Angular app
FROM node:21 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json, then install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the entire project and build the application
COPY . . 
RUN npm run build -- --configuration=production

# Use an official Nginx image for serving the app
FROM nginx:alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Copy the built Angular files from the build stage
COPY --from=build /app/dist/recipe-sharing/browser /usr/share/nginx/html

# Copy the Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Expose the correct port for Render
EXPOSE 10000

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
