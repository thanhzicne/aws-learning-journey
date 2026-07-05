---
title: "Week 9 Worklog"
date: 2026-05-14
weight: 9
chapter: false
pre: " <b> 1.9. </b> "
---

## Week 9 Objectives

- Write a Dockerfile for the Spring Boot backend and React frontend (Nginx).
- Configure `docker-compose.yml` to run the full stack locally.
- Push Docker images to Docker Hub.
- Run containers on EC2.

### Tasks for This Week

| Day | Task | Start Date | End Date | Reference |
| --- | --- | --- | --- | --- |
| Mon | Learn Docker fundamentals: images, containers, Dockerfile, layer caching. Install Docker locally | 15/06/2026 | 15/06/2026 | [Deploy Application on Docker](https://000015.awsstudygroup.com) |
| Tue | Write Dockerfile for Spring Boot backend. Build and test the backend container locally | 16/06/2026 | 16/06/2026 | [Deploy Application on Docker – Deploy on Local](https://000015.awsstudygroup.com/2-deploy-local/) |
| Wed | **Practice Docker:** Write a multi-stage Dockerfile for the React frontend (Nginx). Configure `docker-compose.yml` for the full stack | 17/06/2026 | 17/06/2026 | [Deploy Application on Docker – Docker Compose](https://000015.awsstudygroup.com/7-docker-compose/) |
| Thu | Push images to Docker Hub. Configure EC2 to pull and run containers from Docker Hub | 18/06/2026 | 18/06/2026 | [Deploy Application on Docker – Push Image](https://000015.awsstudygroup.com/8-push-image/2-use-docker-hub/) |
| Fri | Review, test the full stack on EC2, write worklog report. Selecting the group project topic and drawing the project architecture diagram using AWS services. Plan Week 10 | 19/06/2026 | 19/06/2026 | [Deploy Application on Docker – Configure EC2](https://000015.awsstudygroup.com/5-configure-ec2/) |

### Week 9 Results

Key concepts learned in Docker and Containerization:

- **Image:** A read-only template containing everything needed to run an application (OS, runtime, code, dependencies). Built from a Dockerfile, layer by layer.
- **Container:** A running instance of an image. Isolated from the host and other containers, but shares the host OS kernel.
- **Dockerfile:** A script that defines how to build an image. Each instruction (`FROM`, `COPY`, `RUN`…) creates a new layer.
- **Layer Caching:** Docker caches each layer. If a layer is unchanged, Docker reuses the cache → faster builds. This is why you should `COPY package.json` first, then `RUN npm install`, before copying the rest of the source code.
- **Multi-stage Build:** A technique using multiple `FROM` statements in one Dockerfile. The first stage builds the app; the second stage copies only the necessary artifact → a lean production image with no build tools included.
- **Docker Compose:** A tool for defining and running multi-container applications via a `docker-compose.yml` file. Automatically creates an internal network so services can reach each other by service name.
- **Docker Hub:** A public registry for storing and sharing Docker images — similar to GitHub but for container images.

```text
Docker Architecture:
  Dockerfile  →  docker build  →  Image  →  docker run  →  Container
                                    ↓
                               Docker Hub
                                    ↓
                             EC2: docker pull → Container
```

#### Exercise 1: Dockerfile for Backend (Spring Boot)

**Dockerfile instructions and their meaning:**

| Instruction | Meaning |
| :--- | :--- |
| `FROM eclipse-temurin:17-jre-alpine` | Base image: JRE only (runtime), not the full JDK — reduces image size |
| `WORKDIR /app` | Sets the default working directory inside the container |
| `COPY target/*.jar app.jar` | Copies the pre-built JAR file into the image |
| `EXPOSE 8080` | Documents the port the container listens on (metadata only, does not open the port) |
| `ENTRYPOINT` | Command that runs when the container starts; allows passing `JAVA_OPTS` from outside |

```dockerfile
# Backend Dockerfile
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/*.jar app.jar
EXPOSE 8080
ENV JAVA_OPTS=""
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
```

> **Screenshot:** ![Backend Dockerfile build](/images/evidence/week-09/01-backend-dockerfile-build.png)

#### Exercise 2: Multi-stage Dockerfile for Frontend (React + Nginx)

**Why use a Multi-stage Build:**

- **Stage 1 (build):** Uses `node:18-alpine` to compile the React app. The Node image is fairly large (~300 MB) but is only needed during the build step.
- **Stage 2 (serve):** Uses `nginx:alpine` (~25 MB) to serve the static files. Only the `dist/` folder from stage 1 is copied over — no Node, npm, or source code is included.

Result: the production image is ~30 MB instead of ~350 MB if a single stage were used.

```dockerfile
# Frontend Dockerfile (Multi-stage)
FROM node:22-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
```

**Note on `nginx.conf`:** Configure `try_files $uri /index.html` so React Router works correctly — this prevents 404 errors when the page is refreshed.

> **Screenshot:** ![Frontend image build](/images/evidence/week-09/02-frontend-image-build.png)

#### Exercise 3: Docker Compose for Local Dev

**Docker Compose key concepts:**

- **`depends_on`:** Controls the startup order of services, but does not guarantee a service is ready to accept requests (only that the container has started).
- **`environment`:** Passes environment variables into a container. Using `${DB_PASSWORD}` reads the value from a `.env` file instead of hardcoding credentials.
- **`volumes`:** Mounts a directory or named volume. `mysql_data:/var/lib/mysql` ensures MySQL data persists after the container restarts.
- **Internal Network:** Compose automatically creates a private network. Services call each other by service name (e.g., the backend connects to the DB via hostname `db`).

```yaml
version: '3.8'
services:
  backend:
    build: ./backend
    ports:
      - "8080:8080"
    environment:
      - DB_URL=jdbc:mysql://db:3306/ecommerce
      - DB_PASSWORD=${DB_PASSWORD}
    depends_on:
      - db

  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  db:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: ecommerce
      MYSQL_ROOT_PASSWORD: ${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:
```

Commonly used Compose commands:

```bash
docker-compose up -d             # Start the full stack (detached mode)
docker-compose ps                # Check the status of all containers
docker-compose logs -f backend   # Stream logs for the backend service
docker-compose down              # Stop and remove containers (keep volumes)
docker-compose down -v           # Stop and remove containers and volumes
```

> **Screenshot:** ![Docker Compose running](/images/evidence/week-09/03-docker-compose-running.png)

#### Exercise 4: Push Images to Docker Hub & Run on EC2

**Image tagging and push workflow:**

Docker Hub requires images to be tagged in the format `username/repository:tag` before pushing:

```bash
# Build and tag images
docker build -t yourusername/ecommerce-backend:latest ./backend
docker build -t yourusername/ecommerce-frontend:latest ./frontend

# Login to Docker Hub
docker login

# Push to Docker Hub
docker push yourusername/ecommerce-backend:latest
docker push yourusername/ecommerce-frontend:latest
```

On EC2, pull images from Docker Hub and run them:

```bash
# Pull images from Docker Hub
docker pull yourusername/ecommerce-backend:latest
docker pull yourusername/ecommerce-frontend:latest

# Run with Docker Compose (EC2 must have docker-compose installed)
docker-compose up -d
```

> **Screenshot:** ![Docker Hub images](/images/evidence/week-09/04-docker-hub-images.png)
>
> **Screenshot:** ![Containers running on EC2](/images/evidence/week-09/05-deploy-web-on-ec2.png)
>
> **Screenshot:** ![Containers running on EC2](/images/evidence/week-09/06-web-running-on-ec2.png)

#### Challenges Encountered

| Problem | Solution |
| :--- | :--- |
| Backend container crashes immediately when running alone | Spring Boot requires a database connection on startup — RDS must be running or use Docker Compose to start all services together |
| `Communications link failure` when connecting to RDS | RDS Security Group does not allow port 3306 from local machine — add inbound rule MySQL/Aurora port 3306 source My IP |
| `docker-compose` not found on EC2 Ubuntu | Install manually with `sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose` |
| `push access denied` when pushing to Docker Hub | Not logged in or incorrect image tag — run `docker login` first, then tag with correct format `username/repo:tag` before pushing |
| Blank page with `e.map is not a function` error on EC2 | `productService.js` was calling the wrong API URL — missing port 8080, fixed by changing to `http://13.210.73.163:8080/api` |

## Week 10 Plan

- Learn Amazon ECS (Elastic Container Service): Cluster, Task Definition, Service.
- Push images to Amazon ECR instead of Docker Hub.
- Deploy backend and frontend containers on ECS Fargate.
- Configure an Application Load Balancer for the ECS Service.
