FROM maven:3.8.1-openjdk-16-slim AS MAVEN_BUILD

COPY pom.xml /tmp/

RUN mvn -B dependency:go-offline -f /tmp/pom.xml -s /usr/share/maven/ref/settings-docker.xml

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package



FROM openjdk:16-jdk-oraclelinux8

RUN mkdir -p /opt/bdo/services/

WORKDIR /opt/bdo/services/

COPY --from=MAVEN_BUILD /tmp/target/*.jar /opt/bdo/services/ccm-common-framework.jar

ENV PORT=8081

EXPOSE ${PORT}

ENTRYPOINT ["java","-jar","ccm-common-framework.jar","--spring.profiles.active=dev","--server.port=${PORT}"]