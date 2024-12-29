FROM ubuntu:latest

# Atualizar o apt-get e instalar dependências
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    sudo \
    python3-venv \
    python3-pip

# Criar um ambiente virtual
RUN python3 -m venv /env

# Ativar o ambiente virtual e instalar o cfn-lint
RUN /env/bin/pip install --upgrade pip && \
    /env/bin/pip install cfn-lint

# Copiar o script de entrada
COPY src/entrypoint.sh /entrypoint.sh

# Garantir que o script de entrada tenha permissões de execução
RUN chmod +x /entrypoint.sh

# Definir o ponto de entrada
ENTRYPOINT ["/entrypoint.sh"]
