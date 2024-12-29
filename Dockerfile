FROM amazonlinux:2
RUN yum install -y aws-cli
COPY src/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]