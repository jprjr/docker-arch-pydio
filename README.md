# jprjr/pydio

This is an Arch Linux-based image with [Pydio](http://pyd.io) installed.

It's running as a FastCGI app, listening on port 9000.

## Usage

Pydio expects the data folder to have a certain layout. I've made a small
script to setup the data folder structure at `/opt/init_data_folder.sh` -
you should only have to do this once.

### Build

```
$ docker build -t <repo name> .
```

### Initialize data folder structure
```
$ docker run -v /path/to/perm/folder:/var/lib/pydio/data --entrypoint /opt/init_data_folder.sh jprjr/pydio
```

### Run in foreground
```
$ docker run -v /path/to/perm/folder:/var/lib/pydio/data -p 9000 jprjr/pydio
```

### Run in background
```
$ docker run -d -v /path/to/perm/folder:/var/lib/pydio/data -p 9000 jprjr/pydio
```

Alternatively, you should be able to use links and data-only containers for
persistence.

## Exposed ports

* 9000

## Exposed volumes

* `/srv/http/pydio` (explicit from the Dockerfile, you'll need your proxy to access this)
* `/var/lib/pydio/data` (implied by using the -v option, not in the Dockerfile)
