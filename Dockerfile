# Stage 1: Setup, Install dependencies
FROM maven:3.9.4-eclipse-temurin-17 AS setup
RUN apt-get update && apt-get install -y xvfb x11-xkb-utils x11-apps \
    libxext6 libxrender1 libxtst6 libxi6
ENV DISPLAY=:99
WORKDIR /calc
COPY . .

# Stage 2: Build with Maven
FROM setup AS build
RUN xvfb-run --server-args="-screen 0 1024x768x24" mvn clean package

# Stage 3: Run SonarQube Analysis
FROM build AS analysis
ARG SONAR_URL
ARG SONAR_TOKEN
RUN mvn verify sonar:sonar -Dsonar.host.url=${SONAR_URL} -Dsonar.login=${SONAR_TOKEN}

# Stage 4: Artifactory Upload
FROM setup AS final
ARG ARTIFACTORY_URL
ARG ARTIFACTORY_TOKEN
RUN apt-get update && apt-get install -y curl
RUN curl -u admin:${ARTIFACTORY_TOKEN} -T target/*.jar ${ARTIFACTORY_URL}/Calculator-1.0-SNAPSHOT.jar
