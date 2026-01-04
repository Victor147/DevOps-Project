# DevOps Project: User Service CI/CD Pipeline

This project demonstrates a complete automated software delivery process (CI/CD) for a Spring Boot application ("User Service"), deployed to Kubernetes on DigitalOcean.

## 🚀 Pipeline Overview

The pipeline is defined in `.github/workflows/ci-cd-pipeline.yml` and covers the following stages:

1.  **Code Quality & SAST:**
    *   **Checkstyle:** Enforces coding standards.
    *   **PMD:** Static analysis for code defects.
    *   **SpotBugs:** Detects potential bugs.
    *   **SonarCloud:** Comprehensive code quality and security analysis.
2.  **Unit Testing:** Runs JUnit tests with JaCoCo for code coverage.
3.  **Security Scanning:**
    *   **OWASP Dependency Check:** Scans dependencies for known vulnerabilities (CVEs).
    *   **Trivy:** Scans the Docker image for OS-level vulnerabilities.
4.  **Database Migrations:** Validates SQL migrations using **Flyway**.
5.  **Build & Publish:** Builds the Docker image and pushes it to **Docker Hub**.
6.  **Deployment:** Automatically deploys to **Kubernetes (DigitalOcean)** using `kubectl`.

## 🛠️ Tech Stack

*   **Language:** Java 17 (Spring Boot 3.2.6)
*   **Build Tool:** Maven
*   **CI/CD:** GitHub Actions
*   **Containerization:** Docker
*   **Orchestration:** Kubernetes (DigitalOcean)
*   **Database:** PostgreSQL (Production), H2 (Testing)
*   **Security:** SonarCloud, Trivy, OWASP Dependency Check

## 💻 How to Run Locally

You can run the application locally using the provided Kubernetes manifests.

1.  **Prerequisites:** Docker Desktop (with Kubernetes enabled) or Minikube.
2.  **Build the Image:**
    ```bash
    docker build -t user-service:latest .
    ```
3.  **Deploy to Local Cluster:**
    ```bash
    kubectl apply -f k8s/local/namespace.yaml
    kubectl apply -f k8s/local/deployment.yaml
    kubectl apply -f k8s/local/service.yaml
    ```
4.  **Access the App:**
    ```bash
    kubectl port-forward svc/user-service 8080:80 -n local-dev
    # Open http://localhost:8080/actuator/health
    ```

## ☁️ Production Deployment

The application is automatically deployed to DigitalOcean on every push to the `main` branch.
*   **Namespace:** `production`
*   **Database:** In-cluster PostgreSQL with Persistent Volume.
*   **Access:** Exposed via LoadBalancer/NodePort.
