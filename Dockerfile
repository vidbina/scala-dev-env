FROM openjdk:8u102-jdk
MAINTAINER David Asabina <vid@bina.me>
ARG SBT_VERSION 
ARG SCALA_VERSION
ENV SBT_OPTS ""
# Copy local deb since the scala-lang.org endpoints are not secure
COPY scala-${SCALA_VERSION}.deb /tmp/scala-${SCALA_VERSION}.deb
RUN \
  dpkg -i /tmp/scala-2.11.8.deb && \
  apt-get update && \
  apt-get install -f && \
  echo "export SCALA_VERSION=${SCALA_VERSION}" >> /root/.bashrc && \
COPY sbt.bash /usr/local/bin/sbt
RUN \
  wget -O /tmp/sbt-${SBT_VERSION}.zip \
  https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip /tmp/sbt-${SBT_VERSION}.zip  -d /tmp/sbt-${SBT_VERSION} && \
  echo "export SBT_VERSION=${SBT_VERSION}" >> /root/.bashrc && \
  chmod +x /usr/local/bin/sbt && \
  sbt 
#RUN \
#  cd /tmp && git clone https://github.com/scala/scala.git && cd scala && \
#  git checkout v${SCALA_VERSION} && \
#  sbt dist/mkBin
WORKDIR /src
CMD /bin/bash
