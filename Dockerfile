FROM openjdk:8u102-jdk
MAINTAINER David Asabina <vid@bina.me>
ARG SBT_VERSION="0.13.12"
ARG SCALA_VERSION="2.11.8"
# Use fingerprints in the future to verify authenticity of payloads.
RUN \
  wget https://downloads.lightbend.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.deb -O \
    /tmp/scala-${SCALA_VERSION}.deb && \
  dpkg -i /tmp/scala-${SCALA_VERSION}.deb && \
  apt-get update && \
  apt-get install -f && \
  echo "export SCALA_VERSION=${SCALA_VERSION}" >> /root/.bashrc
COPY sbt.bash /usr/local/bin/sbt
RUN \
  wget -O /tmp/sbt-${SBT_VERSION}.zip \
  https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/sbt-${SBT_VERSION}.zip && \
  unzip /tmp/sbt-${SBT_VERSION}.zip  -d /tmp/sbt-${SBT_VERSION} && \
  echo "export SBT_VERSION=${SBT_VERSION}" >> /root/.bashrc && \
  chmod +x /usr/local/bin/sbt && \
  sbt 
WORKDIR /src
CMD /bin/bash -lc /usr/local/bin/sbt
