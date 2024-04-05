ARG PIC_SURE_API_VERSION
ARG PIC_SURE_AUTH_VERSION
ARG PIC_SURE_AGGREGATE_VERSION
ARG PIC_SURE_VISUALIZATION_VERSION

# Define a stage for dependency resolution using Maven
FROM maven:3.6.3-jdk-11 as dependencies
# Copy your pom.xml file into the image
COPY pom.xml /tmp/
# Resolve and download dependencies, potentially using the dependency:copy-dependencies goal to place them into a target directory
RUN mvn -f /tmp/pom.xml dependency:copy-dependencies -DoutputDirectory=/tmp/dependencies

FROM hms-dbmi/pic-sure-api:${PIC_SURE_API_VERSION} as PSA
FROM hms-dbmi/pic-sure-auth-microapp:${PIC_SURE_AUTH_VERSION} as PSAMA
FROM hms-dbmi/pic-sure-aggregate-resource:${PIC_SURE_AGGREGATE_VERSION} as PSAGG
FROM hms-dbmi/pic-sure-visualization-resource:${PIC_SURE_VISUALIZATION_VERSION} as PSV

FROM jboss/wildfly:17.0.0.Final

# Now, copy the resolved dependencies from the 'dependencies' stage into the WildFly deployments directory
COPY --from=dependencies /tmp/dependencies/*.jar /opt/jboss/wildfly/modules/system/layers/base/com/sql/mysql/main/
# Copy the script that generates module.xml
COPY generate-module-xml.sh /tmp/generate-module-xml.sh
# Run the script to generate module.xml dynamically
RUN /tmp/generate-module-xml.sh

COPY --from=PSA /opt/jboss/wildfly/standalone/deployments/pic-sure-api-2.war /tmp/pic-sure-api-2.war
COPY --from=PSAMA /opt/jboss/wildfly/standalone/deployments/pic-sure-auth-services.war /tmp/pic-sure-auth-services.war
COPY --from=PSAGG /opt/jboss/wildfly/standalone/deployments/pic-sure-aggregate-data-sharing-resource.war  /tmp/pic-sure-aggregate-resource.war
COPY --from=PSV /opt/jboss/wildfly/standalone/deployments/pic-sure-visualization-resource.war  /tmp/pic-sure-visualization-resource.war

USER root

RUN mv /tmp/*.war /opt/jboss/wildfly/standalone/deployments/

USER jboss
