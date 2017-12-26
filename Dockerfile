FROM arm32v7/ubuntu

MAINTAINER Vladislav Fursov

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y wget supervisor unzip ca-certificates

ADD ./acestream-rpi-3.1.14.0.tgz /

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vlc-nox python-gevent python-psutil python-m2crypto

RUN mkdir -p /var/run/sshd && mkdir -p /var/log/supervisor && adduser --disabled-password --gecos "" tv

RUN cd /tmp/ && wget https://github.com/ValdikSS/aceproxy/archive/6dff4771c3.zip -O master.zip \
&& cd /tmp/ && unzip master.zip -d /home/tv/ \
&& mv /home/tv/aceproxy-* /home/tv/aceproxy-master

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8000 62062

ENTRYPOINT ["/start.sh"]