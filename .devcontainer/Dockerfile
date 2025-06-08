FROM docker.io/library/ubuntu:24.04


ARG USERNAME=code
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get upgrade -y \
    && apt-get -y install --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        lsb-release \
        gnupg \
        git \
        curl \
        neovim \
        bash-completion \
    && userdel ubuntu \
    && groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME

RUN mkdir -p /etc/apt/keyrings \
    && curl -sLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/keyrings/microsoft.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/microsoft.gpg \
    && echo "Types: deb" >> /etc/apt/sources.list.d/azure-cli.sources \
    && echo "URIs: https://packages.microsoft.com/repos/azure-cli/" >> /etc/apt/sources.list.d/azure-cli.sources \
    && echo "Suites: $(lsb_release -cs)" >> /etc/apt/sources.list.d/azure-cli.sources \
    && echo "Components: main" >> /etc/apt/sources.list.d/azure-cli.sources \
    && echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/azure-cli.sources \
    && echo "Signed-by: /etc/apt/keyrings/microsoft.gpg"  >> /etc/apt/sources.list.d/azure-cli.sources \
    && cat /etc/apt/sources.list.d/azure-cli.sources \
    && apt-get update \
    && apt-get -y install --no-install-recommends azure-cli

USER $USERNAME
