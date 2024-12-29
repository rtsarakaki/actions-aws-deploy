FROM ubuntu:latest

# Atualizar o apt-get e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    sudo

# Baixar e instalar o AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws/

# Copiar o script de entrada
COPY src/entrypoint.sh /entrypoint.sh

# Garantir que o script de entrada tenha permissões de execução
RUN chmod +x /entrypoint.sh

# Definir o ponto de entrada
ENTRYPOINT ["/entrypoint.sh"]
