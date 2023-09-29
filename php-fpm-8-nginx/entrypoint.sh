#!/bin/sh

preEntrypointPath=/pre-entrypoint.sh

if [ -f "$preEntrypointPath" ]; then
    echo "$preEntrypointPath exists and will call it"
    . "$preEntrypointPath"
fi

/usr/bin/supervisord -n -c /etc/supervisord.conf
