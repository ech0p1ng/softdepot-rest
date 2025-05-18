#!/bin/bash

set -e

echo "[INFO] Building .jar..."
mvn clean package -DskipTests

echo "[INFO] Starting app with remote debug on port 5005..."
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=0.0.0.0:5005 -jar target/*.jar
