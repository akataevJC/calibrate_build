"""
Gunicorn configuration file. Read more on settings here:
https://docs.gunicorn.org/en/latest/settings.html#config-file
"""
bind = "0.0.0.0:8000"
workers = 2
accesslog = "-"
errorlog = "-"
loglevel = "debug"
forwarded_allow_ips = "*"
timeout = 60
