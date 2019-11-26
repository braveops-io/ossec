from ubuntu



# Install deps
RUN apt-get update && apt-get install wget -y

# Add OSSEC build deps
RUN apt -y install make gcc libpcre2-dev zlib1g-dev

# Setup tzdata
ENV DEBIAN_FRONTEND=noninteractive
RUN ln -fs /usr/share/zoneinfo/GMT0 /etc/localtime
RUN apt-get install -y tzdata


#Install ossec
WORKDIR /opt
RUN wget https://github.com/ossec/ossec-hids/archive/3.3.0.tar.gz
RUN tar zxvf 3.3.0.tar.gz

WORKDIR /opt/ossec-hids-3.3.0
COPY preloaded-vars.conf /opt/ossec-hids-3.3.0/etc
RUN PCRE2_SYSTEM=yes ./install.sh


#Copy in new config
COPY ossec.conf /var/ossec/etc/ossec.conf


#Install filebeat
WORKDIR /opt
RUN apt -y install curl
RUN  curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.2-amd64.deb
RUN apt install ./filebeat-7.4.2-amd64.deb
COPY filebeat.yml /etc/filebeat/filebeat.yml


#Install startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh
WORKDIR /

CMD ./run.sh