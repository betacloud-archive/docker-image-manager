# This file is subject to the terms and conditions defined in file 'LICENSE',
# which is part of this repository.

FROM ubuntu:16.04
LABEL maintainer="Betacloud Solutions GmbH (https://www.betacloud-solutions.de)"

ARG VERSION
ENV VERSION ${VERSION:-latest}

ENV DEBIAN_FRONTEND noninteractive

ENV USER_ID ${USER_ID:-45000}
ENV GROUP_ID ${GROUP_ID:-45000}

ENV IMAGE_MANAGER_ACTION ${IMAGE_MANAGER_ACTION:-show}
ENV IMAGE_MANAGER_CLOUD ${IMAGE_MANAGER_CLOUD:-service}
ENV IMAGE_MANAGER_IMAGEFILE ${IMAGE_MANAGER_IMAGEFILE:-/configuration/images.yml}

USER root

ADD files/run.sh /run.sh
ADD files/images.yml /configuration/images.yml
ADD files/clouds.yml /configuration/clouds.yml
ADD files/image-manager.py /application/image-manager.py
ADD files/requirements.txt /application/requirements.txt

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        qemu-utils \
        python-pip \
    && pip install -r /application/requirements.txt \
    && groupadd -g $GROUP_ID dragon \
    && useradd -g dragon -u $USER_ID -m -d /home/dragon dragon \
    && chmod +x /application/image-manager.py \
    && mkdir /data \
    && chown -R dragon: /data \
    && apt-get clean \
    && rm -rf \
      /var/lib/apt/lists/* \
      /var/tmp/*

USER dragon
WORKDIR /configuration

VOLUME ["/configuration", "/data"]

CMD ["/run.sh"]
