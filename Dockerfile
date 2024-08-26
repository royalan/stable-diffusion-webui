# use nvidia official image
# reference: https://hub.docker.com/r/nvidia/cuda/tags?page=1&name=11.0.3-runtime-ubuntu20.04
ARG BASE_IMAGE_TAG="11.8.0-20.04-21"

FROM nvidia/cuda:11.8.0-runtime-ubuntu20.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y \
        libgl1  \
        libglib2.0-0 \
        software-properties-common \
        python3-packaging \
        git && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.10 && \
    rm /usr/bin/python3 && \
    ln -s /usr/bin/python3.10 /usr/bin/python3 && \
    python3 get-pip.py && \
    pip3 install httpx==0.24.1

RUN apt-get clean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /root/.cache/pip/* && \
    rm get-pip.py

RUN adduser --disabled-password --gecos '' --uid 1000 appuser
WORKDIR /home/appuser
USER 1000
RUN pip3 install setuptools==65.5.1 && \
    python3 launch.py --no-half --xformers --skip-torch-cuda-test --exit && \
    chmod +x run.sh
CMD ["./run.sh", "."]
