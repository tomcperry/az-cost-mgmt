FROM docker.io/library/ubuntu:24.04


ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        git \
        curl \
        neovim \
        bash-completion \
    && userdel ubuntu \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN 

USER $USERNAME
