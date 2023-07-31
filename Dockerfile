# Start with a base image containing Java runtime (Here we are pulling a JDK 17 image from AdoptOpenJDK)
FROM adoptopenjdk:11-jdk-hotspot as build

# The WORKDIR instruction sets the working directory for any instructions that follow it in the Dockerfile.
WORKDIR /app

# Copy the pom.xml file
COPY pom.xml .

# This command downloads the project dependencies and stores them in a cache layer.
# This layer will only be updated when the pom.xml file changes.
RUN mvn dependency:go-offline -B

# Copy other project files and build our application
COPY src src
RUN mvn clean package

# Start with a base image containing Java runtime
FROM adoptopenjdk:17-jdk-hotspot

# Add Maintainer Info
LABEL maintainer="amevigbe41@gmail.com"

# The application's jar file
ARG JAR_FILE=target/*.jar

# Add the application's jar to the container
COPY --from=build /transit-talk/${JAR_FILE} transit-talk.jar

# Run the jar file
ENTRYPOINT ["java","-jar","/transit-talk.jar"]
