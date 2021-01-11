ARG PIC_SURE_API_VERSION
ARG PIC_SURE_AUTH_VERSION
ARG PIC_SURE_AGGREGATE_VERSION

FROM hms-dbmi/pic-sure-api:${PIC_SURE_API_VERSION} as PSA
FROM hms-dbmi/pic-sure-auth-microapp:${PIC_SURE_AUTH_VERSION} as PSAMA
FROM mhs/dbmi/pic-sure-aggregate-resource:${PIC_SURE_AGGREAGATE_VERSION} as PSAGG

FROM jboss/wildfly:17.0.0.Final

COPY --from=PSA /opt/jboss/wildfly/standalone/deployments/pic-sure-api-2.war /tmp/pic-sure-api-2.war
COPY --from=PSAMA /opt/jboss/wildfly/standalone/deployments/pic-sure-auth-services.war /tmp/pic-sure-auth-services.war
COPY --from=PSAGG /opt/jboss/wildfly/standalone/deployments/pic-sure-aggregate-data-sharing-resource.war  /tmp/pic-sure-aggregate-resource.war


USER root

RUN mv /tmp/*.war /opt/jboss/wildfly/standalone/deployments/

USER jboss
