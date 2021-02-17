FROM bitnami/nginx
MAINTAINER dl-fr-awl-wldd@atos.net
EXPOSE 8080  

LABEL io.k8s.description="WLDD MQ" \
io.k8s.display-name="WLDD MQ" \
io.openshift.expose-services="8080:http" \
io.openshift.tags="wldd-wmq"

ADD dist ./

ENV HOME=/usr/share/nginx/html
WORKDIR ${HOME}
USER 1001

COPY pwa_vhosts.conf /opt/bitnami/nginx/conf/vhosts/

#COPY nginx.conf /opt/bitnami/nginx/conf/
#RUN ls -la /opt/bitnami/nginx/conf/*

#COPY dist/ /usr/share/nginx/html/
#RUN ls -la /usr/share/nginx/html/*