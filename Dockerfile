# Usando uma imagem base do Python para garantir que o pip esteja disponível
FROM python:3.9-alpine

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

# Instalar cfn-lint via pip
RUN pip install --upgrade pip && \
    pip install cfn-lint


# Definir o diretório de trabalho
WORKDIR /app

# Copiar o código do repositório para dentro do container
COPY /src/entrypoint.sh .

# Garantir que o entrypoint.sh seja executável
RUN chmod +x /app/entrypoint.sh

# Definir o ponto de entrada
ENTRYPOINT ["/app/entrypoint.sh"]
