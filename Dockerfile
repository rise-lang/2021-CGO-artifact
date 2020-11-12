FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

# Install basics
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends ca-certificates libssl-dev curl openssh-client gnupg dirmngr git && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install C/C++ build tools
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends make g++ clang-8 llvm-8 llvm-8-dev zlib1g-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/* && \
  ln -s /usr/bin/llvm-config-8 /usr/bin/llvm-config && \
  ln -s /usr/bin/clang-8 /usr/bin/clang && \
  ln -s /usr/bin/clang-cpp-8 /usr/bin/clang++

# Install Rust
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends cargo && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SBT_VERSION 1.3.5

# Install OpenJDK and sbt
RUN \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install -y --no-install-recommends openjdk-8-jdk sbt && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# Install R
RUN \
  apt-get update && \
  apt install -y --no-install-recommends r-base r-cran-tidyverse pkg-config libxml2-dev libcurl4-openssl-dev fonts-dejavu-core && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# TODO: some persistence?
# VOLUME /data