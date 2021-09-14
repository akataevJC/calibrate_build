#!/bin/bash
set -e

# set up environment variables from file, ignoring line starting with '#'
export $(grep -v '^#' /var/tmp/.env | xargs)

case "$1" in
server)
  gunicorn project.wsgi
  exit 0
  ;;
lint)
  black . --check --diff
  flake8 .
  mypy .
  isort . -c
  exit 0
  ;;
help)
  echo "Useful commands:"
  echo
  echo "server           Run gunicorn server."
  echo "bash             Open container bash."
  echo "pytest           Run tests with pytest runner. Check pytest docs for available options."
  echo "lint             Run linters check."
  echo "django           Get available django commands."
  exit 0
  ;;
django)
  python manage.py "${@:2}"
  exit 0
esac

exec "$@"