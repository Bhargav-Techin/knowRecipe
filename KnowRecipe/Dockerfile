# Use an official Maven image to build the Spring Boot app
FROM maven:3.8.4-openjdk-17 AS build

# Set the working directory
WORKDIR /app

# Copy the pom.xml file and install dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy the source code and build the application
COPY src ./src
RUN mvn clean package -DskipTests

# Use an official OpenJDK runtime as a parent image for the final stage
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/target/KnowRecipe-0.0.1-SNAPSHOT.jar .

# Make port 5454 available to the world outside this container
EXPOSE 5454

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/app/KnowRecipe-0.0.1-SNAPSHOT.jar"]

# Copy the .env file into the container
COPY .env /app/.env

