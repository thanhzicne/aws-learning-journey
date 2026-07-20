FROM eclipse-temurin:17-jre

WORKDIR /app
COPY target/ecommerce-api.jar /app/ecommerce-api.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/ecommerce-api.jar"]
