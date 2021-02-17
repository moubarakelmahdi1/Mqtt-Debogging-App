FROM registry.kazan.atosworldline.com/docker-reg/awl-c7-openjdk18:v2 
MAINTAINER dl-fr-awl-wldd@atos.net
EXPOSE 8080  

LABEL io.k8s.description="WLDD MQ Web Services" \
io.k8s.display-name="WLDD MQ WS" \
io.openshift.expose-services="8080:http" \
io.openshift.tags="WlddMQ,ws"
ADD wldd.mq.ws-1.0-SNAPSHOT.jar wldd.mq.ws-1.0-SNAPSHOT.jar

USER nobody

ENV HOME=/opt/app-root/src
WORKDIR ${HOME}


ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar  -Dspring.profiles.active=sdco /wldd.mq.ws-1.0-SNAPSHOT.jar" ]