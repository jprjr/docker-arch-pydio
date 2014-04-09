#!/usr/bin/env bash

# Do a bunch of crazy stuff to figure out where this script is
abspath_portable() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

abs_path=$(abspath_portable "$0")
script_dir=$(dirname "${abs_path}")
script_abs_path=$(readlink "${abs_path}" || echo "${abs_path}")
script_abs_dir=$(cd "$(dirname "${script_abs_path}")" && pwd -P)

docker run -d --name pydio_ng jprjr/pydio
# nginx can't use environment variables
# exposed by link - so we'll edit the conf
# before running
wget -N http://stedolan.github.io/jq/download/linux64/jq && chmod +x jq
pydio_ip=$(docker inspect pydio_ng | ./jq -r '.[0].NetworkSettings.IPAddress')
cp nginx/conf.d/pydio_php.conf.dist nginx/conf.d/pydio_php.conf
sed -i "s/##PYDIO_IP##/$pydio_ip/g" nginx/conf.d/pydio_php.conf
docker run -d -v "${script_abs_dir}"/nginx:/etc/nginx --link pydio_ng:pydio --volumes-from pydio_ng -p 80:80 jprjr/debian-nginx
