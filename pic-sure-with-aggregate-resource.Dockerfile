ARG PIC_SURE_API_VERSION
ARG PIC_SURE_AUTH_VERSION
ARG PIC_SURE_AGGREGATE_VERSION
ARG PIC_SURE_VISUALIZATION_VERSION

FROM hms-dbmi/pic-sure-api:${PIC_SURE_API_VERSION} as PSA
FROM hms-dbmi/pic-sure-auth-microapp:${PIC_SURE_AUTH_VERSION} as PSAMA
FROM hms-dbmi/pic-sure-aggregate-resource:${PIC_SURE_AGGREGATE_VERSION} as PSAGG
FROM hms-dbmi/pic-sure-visualization-resource:${PIC_SURE_VISUALIZATION_VERSION} as PSV

FROM jboss/wildfly:17.0.0.Final

COPY --from=PSA /opt/jboss/wildfly/standalone/deployments/pic-sure-api-2.war /tmp/pic-sure-api-2.war
COPY --from=PSAMA /opt/jboss/wildfly/standalone/deployments/pic-sure-auth-services.war /tmp/pic-sure-auth-services.war
COPY --from=PSAGG /opt/jboss/wildfly/standalone/deployments/pic-sure-aggregate-data-sharing-resource.war  /tmp/pic-sure-aggregate-resource.war
COPY --from=PSV /opt/jboss/wildfly/standalone/deployments/pic-sure-visualization-resource.war  /tmp/pic-sure-visualization-resource.war 


USER root

RUN mv /tmp/*.war /opt/jboss/wildfly/standalone/deployments/

USER jboss
