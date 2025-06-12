# Dockerfile for RunPod Eval
FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Base setup
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    build-essential git curl wget unzip pkg-config cmake clang \
    libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zstd \
    liblzma-dev libffi-dev libncursesw5-dev \
    ca-certificates gnupg lsb-release sudo python3-pip make

# Install PyTorch with CUDA 12.1
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install pyenv and Python 3.12.3
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN curl https://pyenv.run | bash && \
    $PYENV_ROOT/bin/pyenv install 3.12.3 && \
    $PYENV_ROOT/bin/pyenv global 3.12.3

# Set default directory
WORKDIR /workspace

# Add non-root user with sudo
RUN useradd -ms /bin/bash poduser && \
    adduser poduser sudo && \
    echo 'poduser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER poduser
ENV HOME="/home/poduser"
