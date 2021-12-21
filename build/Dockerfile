FROM python:3.8-slim-buster

ARG AWS_PROFILE
ARG SECURE_ENV_PATH=secure.env
# Default gunicorn worker uid
ARG UID=1005
# Default gunicorn worker group
ARG GID=205
ENV PYTHONUNBUFFERED=1

COPY requirements.txt /
COPY docker-entrypoint.sh /
COPY $SECURE_ENV_PATH /secure.env
ADD https://github.com/mozilla/sops/releases/download/v3.7.0/sops-v3.7.0.linux  /usr/local/bin/sops

RUN chmod +x /usr/local/bin/sops && groupadd -g $GID app && useradd -u $UID -g $GID app
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials sops -d /secure.env > /var/tmp/.env
RUN pip install -qU pip && pip install -r requirements.txt
USER app

ENTRYPOINT ["/docker-entrypoint.sh"]
