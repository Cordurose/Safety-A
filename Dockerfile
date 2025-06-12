FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt update && apt install -y \
    build-essential git curl wget unzip pkg-config cmake clang \
    libssl-dev libbz2-dev libreadline-dev libsqlite3-dev zstd \
    liblzma-dev libffi-dev libncursesw5-dev ca-certificates \
    gnupg lsb-release sudo python3-pip make openssh-server

# Install PyTorch (CUDA 12.1)
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Install pyenv and Python 3.12.3
ENV PYENV_ROOT="/root/.pyenv"
ENV PATH="$PYENV_ROOT/bin:$PATH"
RUN curl https://pyenv.run | bash && \
    $PYENV_ROOT/bin/pyenv install 3.12.3 && \
    $PYENV_ROOT/bin/pyenv global 3.12.3

# SSH Setup
RUN mkdir /var/run/sshd

# Replace this with your actual public key:
# Install and configure SSH
RUN apt update && apt install -y openssh-server

# Create SSH config directory and authorized_keys
RUN mkdir -p /root/.ssh && \
    echo "ssh-ed25519 AAAAC3Nz...yourkey... your_email@example.com" >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# Start SSH service on container boot
RUN mkdir -p /var/run/sshd
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
