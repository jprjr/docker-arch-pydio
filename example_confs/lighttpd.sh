#!/usr/bin/env bash

# Do a bunch of crazy stuff to figure out where this script is
abspath_portable() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

abs_path=$(abspath_portable "$0")
script_dir=$(dirname "${abs_path}")
script_abs_path=$(readlink "${abs_path}" || echo "${abs_path}")
script_abs_dir=$(cd "$(dirname "${script_abs_path}")" && pwd -P)

docker run -d --name pydio_li jprjr/pydio
docker run -d -v "${script_abs_dir}"/lighttpd:/etc/lighttpd --link pydio_li:pydio --volumes-from pydio_li -p 80:80 jprjr/lighttpd
