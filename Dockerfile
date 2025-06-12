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
RUN mkdir -p /root/.ssh && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQD778gjWSqVl7niSkStiENbkxV1IYYeKpp9p+bTsaOIkIH/0niAewFO3tfNVkiMflW9bz1PcR4EyaMnduFjb559HFo5kQ2RNx/HHeSkxkvUkwx0skt1G8rYAMXHokyd4QertjfalMsfjIEAZLZP9gYVuCcu/wGPDjwejMuwz7j++TA6m4WMUcmz2zmp9R91Ev90D4zNHETyyHpUaIvYu4GK/7BdvWOQ3CaB2ru/TVWPMGyNH5IKaA6KW3fNSCF6KFQBzOS0QZxgLTtELoltdAKBzjysZUtlTI0bWqQCouukWDSE58BmiarmS4WhdW/nhe2dH2WrsaxrRT2PwSrIkVIkZp31zTJqX5F4FWrIpC/EJnA6X2QAbKOhmtZd275lpi3fYBNMYByMSCSc1tWN5+a5wR2U22G1PL+3pbmiQ0Owc/kxlpwJSZVT426Hioh1i/SRoUZMtTDH8Sqcx8o5sEbAXsmOclDWXT3QsSjAdwX5He0l/zmGn3zIORIHMVgfmTh4o/rcYgdhdSrujFB5DVVcoXJGsqetCNZbsGK7YZC7l1Pv3fWrjrNE2YYLq3tfUKh49tb0lzYaF3PXzMlKxtsTRx6gp43KjLtzVgXElW0zTkrVJl2Cvkysz3Y/hbwATjBbjpzfbEg7ZqT/PxIOa5i9o5HCg7OXgvjxHM+ZaEZhGQ== vanessanwauwa@gmail.com" >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys && \
    chmod 700 /root/.ssh && \
    chown -R root:root /root/.ssh

# Allow root login via SSH and disable password login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Expose port for SSH
EXPOSE 22

# Default workdir
WORKDIR /workspace

# Start SSH by default
CMD ["/usr/sbin/sshd", "-D"]
