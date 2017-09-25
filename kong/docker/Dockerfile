FROM kong:latest

RUN yum install patch -y

COPY patch.diff /tmp

RUN patch -d /usr/local/share/lua/5.1 -p1 < /tmp/patch.diff
