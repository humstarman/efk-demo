FROM centos:7.5.1804

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh
