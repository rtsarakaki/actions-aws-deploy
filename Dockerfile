FROM ubuntu:latest

# Atualizar o apt-get e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    sudo \
    python3 \
    python3-pip  # Instalando Python3 e pip

# Baixar e instalar o AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    sudo ./aws/install && \
    rm -rf awscliv2.zip aws/

# Instalar cfn-lint via pip
RUN pip3 install --upgrade pip && \
    pip3 install cfn-lint  # Instalando o cfn-lint

# Copiar o script de entrada
COPY src/entrypoint.sh /entrypoint.sh

# Garantir que o script de entrada tenha permissões de execução
RUN chmod +x /entrypoint.sh

# Definir o ponto de entrada
ENTRYPOINT ["/entrypoint.sh"]
