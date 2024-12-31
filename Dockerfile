# Usar uma imagem base leve
FROM python:3.9-alpine

# Instalar dependências necessárias
RUN apk add --no-cache \
    curl \
    unzip \
    bash

# Instalar AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws/

# Instalar cfn-lint via pip
RUN pip install --no-cache-dir cfn-lint

# Definir o diretório de trabalho
WORKDIR /app

# Copiar o script de entrada
COPY /src/entrypoint.sh .

# Garantir que o script seja executável
RUN chmod +x /app/entrypoint.sh

# Definir o ponto de entrada
ENTRYPOINT ["/app/entrypoint.sh"]
