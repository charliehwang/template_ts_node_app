#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

FROM ubuntu:18.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# The node image includes a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=node
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG USER=root
ARG HOME=/root
ARG SSH_KEY

RUN apt-get update 

# Configure apt and install packages
RUN apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \ 
    #
    # Verify git and needed tools are installed
    && apt-get -y install git iproute2 procps curl
#     #
#     # Remove outdated yarn from /opt and install via package 
#     # so it can be easily updated via apt-get upgrade yarn
#     && rm -rf /opt/yarn-* \
#     && rm -f /usr/local/bin/yarn \
#     && rm -f /usr/local/bin/yarnpkg \
#     && apt-get install -y apt-transport-https lsb-release \
#     && curl -sS https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/pubkey.gpg | apt-key add - 2>/dev/null \
#     && echo "deb https://dl.yarnpkg.com/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/ stable main" | tee /etc/apt/sources.list.d/yarn.list 

# RUN apt-get -y install --no-install-recommends yarn

# use latest node 13 release
RUN	curl -sL https://deb.nodesource.com/setup_13.x | /bin/sh -


# Network Utils
RUN apt-get -y install --no-install-recommends \
    iproute2 iputils-ping 

# Jarvis
RUN apt-get -y install --no-install-recommends \
    nodejs 

#
# Cypress libs
RUN apt-get -y install --no-install-recommends openssl libssl-dev \
    #
    # tmux, etc..
    && apt-get -y install --no-install-recommends \
    vim tar \
    locales tmux \ 
    # 
    # SSH Server
    && apt-get install -y openssh-server \
    #
    # [Optional] Update a non-root user to UID/GID if needed.
    && if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then \
    groupmod --gid $USER_GID $USERNAME \
    && usermod --uid $USER_UID --gid $USER_GID $USERNAME \
    && chown -R $USER_UID:$USER_GID /home/$USERNAME; \
    fi \
    # [Optional] Add add sudo support for non-root user
    && apt-get install -y sudo \
    && echo node ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Install tslint and typescript globally
RUN npm install -g tslint eslint typescript


##############################
# SSH Setup :  https://docs.docker.com/engine/examples/running_ssh_service/#build-an-eg_sshd-image
RUN mkdir /var/run/sshd
RUN echo 'root:ttyrqttyrq' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# RUN /usr/sbin/sshd -D &

WORKDIR $HOME
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf 
# RUN cp .tmux/.tmux.conf.local .

COPY ./.tmux.conf.local $HOME
COPY .bashrc $HOME

# USER $USER
# WORKDIR $HOME
# RUN mkdir -p $HOME/.ssh/ && \
#     echo "$SSH_KEY" > $HOME/.ssh/id_rsa && \
# 		chmod -R 600 $HOME/.ssh/ && \
#     ssh-keyscan -t rsa ether.local >> $HOME/.ssh/known_hosts ; \
# 		chown -R $USER:$USER $HOME/.ssh

# EXPOSE 22
##############################


# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=dialog
