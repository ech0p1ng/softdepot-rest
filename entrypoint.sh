#!/bin/bash

set -e

echo "[INFO] Building .jar..."
mvn clean package -DskipTests

echo "[INFO] Starting app..."
java -jar target/*.jar
