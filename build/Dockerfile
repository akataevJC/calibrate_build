FROM python:3.8-slim-buster

ARG AWS_PROFILE=weightco
ARG SECURE_ENV_PATH=secure.env
ARG DEV=1
# Default gunicorn worker uid
ARG UID=1005
# Default gunicorn worker group
ARG GID=205
ENV PYTHONUNBUFFERED=1

COPY requirements/* /
COPY docker-entrypoint.sh /
COPY $SECURE_ENV_PATH /secure.env
ADD https://github.com/mozilla/sops/releases/download/v3.7.0/sops-v3.7.0.linux  /usr/local/bin/sops

RUN chmod +x /usr/local/bin/sops && groupadd -g $GID app && useradd -u $UID -g $GID app
RUN --mount=type=secret,id=aws,target=/root/.aws/credentials sops -d /secure.env > /var/tmp/.env
RUN pip install -qU pipenv && \
    if [ "$DEV" = "1" ] ; then \
        pipenv install --system --skip-lock --dev ; \
    else \
        pipenv install --system --deploy ; \
    fi

USER app

ENTRYPOINT ["/docker-entrypoint.sh"]
