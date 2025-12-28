#!/bin/bash

set -e

echo "Starting User Service Quick Setup..."

echo -e "\nChecking prerequisites..."

if ! command -v java &> /dev/null; then
    echo "Java is not installed, please install Java 17+"
    exit 1
fi
echo "Java found"

if ! command -v mvn &> /dev/null; then
    echo "Maven is not installed, please install Maven 3.9+"
    exit 1
fi
echo "Maven found"

if ! command -v docker &> /dev/null; then
    echo "Docker is not installed, please install Docker"
    exit 1
fi
echo "Docker found"

echo -e "\nStarting PostgreSQL database..."
if docker ps -a | grep -q postgres-userservice; then
    echo "Removing existing PostgreSQL container..."
    docker rm -f postgres-userservice
fi

docker run -d \
  --name postgres-userservice \
  -e POSTGRES_DB=userdb \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine

echo "PostgreSQL started on port 5432"

echo "Waiting for PostgreSQL to be ready..."
sleep 5

echp -e "\nBuilding application..."
mvn clean package -DskipTests

echo "Application built successfully"

echo -e "\nRunning database migrations..."
mvn flyway:migrate \
  -Dflyway.url=jdbc:postgresql://localhost:5432/userdb \
  -Dflyway.user=postgres \
  -Dflyway.password=postgres

echo "Database migrations completed"

echo -e "\nRunning tests..."
mvn test

echo "Tests passed"

echo -e "\n==================================="
echo -e "Setup completed successfully!"
echo -e "==================================="
echo ""
echo "To start the application, run:"
echo "  mvn spring-boot:run"
echo ""
echo "Or run the JAR directly:"
echo "  java -jar target/user-service-1.0.0.jar"
echo ""
echo "Application will be available at:"
echo "  http://localhost:8080/api/users"
echo ""
echo "Health check:"
echo "  http://localhost:8080/actuator/health"
echo ""
echo "To stop PostgreSQL:"
echo "  docker stop postgres-userservice"
echo ""