ARG PIC_SURE_API_VERSION
ARG PIC_SURE_AUTH_VERSION

FROM hms-dbmi/pic-sure-api:${PIC_SURE_API_VERSION} as PSA
FROM hms-dbmi/pic-sure-auth-microapp:${PIC_SURE_AUTH_VERSION} as PSAMA

FROM jboss/wildfly:23.0.0.Final

COPY --from=PSA /opt/jboss/wildfly/standalone/deployments/pic-sure-api-2.war /tmp/pic-sure-api-2.war

USER root

RUN mv /tmp/*.war /opt/jboss/wildfly/standalone/deployments/

USER jboss
