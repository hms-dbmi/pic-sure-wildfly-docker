#ARG PIC_SURE_API_VERSION
#ARG PIC_SURE_AUTH_VERSION

#FROM hms-dbmi/pic-sure-api:${PIC_SURE_API_VERSION} as PSA
#FROM hms-dbmi/pic-sure-auth-microapp:${PIC_SURE_AUTH_VERSION} as PSAMA

FROM jboss/wildfly:17.0.0.Final

#COPY --from=PSA /opt/jboss/wildfly/standalone/deployments/pic-sure-api-2.war /tmp/pic-sure-api-2.war
#COPY --from=PSAMA /opt/jboss/wildfly/standalone/deployments/pic-sure-auth-services.war /tmp/pic-sure-auth-services.war

## DEBUGGING
#USER root
#RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
#RUN yum -y install ngrep

#RUN mv /tmp/*.war /opt/jboss/wildfly/standalone/deployments/

USER jboss
