
FROM ubuntu:24.04

# Evitar preguntas durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar SSH, sudo y Python
RUN apt-get update && apt-get install -y \
    openssh-server \
    sudo \
    python3 \
    && apt-get clean

# Crear directorio necesario para SSH
RUN mkdir -p /run/sshd

# Crear usuario ansible con contraseña ansible
RUN useradd -m -s /bin/bash ansible && \
    echo 'ansible:ansible' | chpasswd

# Dar privilegios sudo sin contraseña
RUN echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible && \
    chmod 0440 /etc/sudoers.d/ansible

# Permitir autenticación SSH mediante contraseña
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Exponer puerto SSH
EXPOSE 22

# Iniciar servidor SSH
CMD ["/usr/sbin/sshd", "-D"]
