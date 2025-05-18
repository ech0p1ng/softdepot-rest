FROM eclipse-temurin:21-jdk-alpine AS base

WORKDIR /app

COPY . .

RUN apk add --no-cache maven bash


FROM base AS production

RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

FROM base AS dev

RUN chmod +x entrypoint-dev.sh

ENTRYPOINT ["./entrypoint-dev.sh"]
