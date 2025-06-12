FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Base setup
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y \
    build-essential git curl wget unzip pkg-config cmake clang \
    libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zstd \
    liblzma-dev libffi-dev libncursesw5-dev \
    ca-certificates sudo gnupg lsb-release python3-pip \
    docker.io

# Install PyTorch + CUDA 12.1-compatible version
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# pyenv installation
RUN curl https://pyenv.run | bash && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc && \
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc && \
    bash -c "source ~/.bashrc && pyenv install 3.12.3 && pyenv global 3.12.3"

# Set default directory
WORKDIR /workspace

# Create non-root user
RUN useradd -ms /bin/bash poduser && adduser poduser sudo && echo 'poduser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER poduser
ENV HOME /home/poduser
