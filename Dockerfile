FROM ubuntu:14.04

# Install packages
RUN apt-get update -y && \
    apt-get install -y \
    git \
    curl \
    rake \
    zsh \
    vim

# Set HOME
ENV HOME /home
WORKDIR $HOME
