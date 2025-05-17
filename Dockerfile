FROM eclipse-temurin:21-jdk-alpine

WORKDIR /app

COPY . .

RUN apk add --no-cache maven bash

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
