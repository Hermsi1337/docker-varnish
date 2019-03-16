# Varnish, a caching reverse proxy
Use this image to start your own varnish server fast and easy.

## Regular builds, automagically
[![Build Status](https://travis-ci.org/Hermsi1337/docker-varnish.svg?branch=master)](https://travis-ci.org/Hermsi1337/docker-varnish)   
Thanks to [Travis-CI](https://travis-ci.org/) this image is pushed weekly and creates new [tags](https://hub.docker.com/r/hermsi/alpine-varnish/tags/) if there are new versions available.

## Tags
There are several versions of Varnish available.      
This repository provides very fine grained tags in order to fit your needs.   
The `latest`-tag always points to the "fresh"- , while the `stable`-tag points to the "supported" [releases](https://varnish-cache.org/releases/).
* `6.1.1-r0`, `6.1.1`, `6.1`, `latest`
* `6.0.2-r0`, `6.0.0-r1`, `6.0.0`, `6.0`, `6`, `stable`
* `5.2.1-r0`, `5.2.1`, `5.2`, `5`
* `4.1.9-r0`, `4.1.9`, `4.1`, `4`
* `3.0.5-2ubuntu0.1`, `3.0.5`, `3.0`, `3`

## Usage

### Configuration
#### VCL
You can either run this image with or without a [vcl-file](https://varnish-cache.org/docs/6.0/users-guide/vcl.html).   
If you don't provide a vcl, the Varnish-proxy uses a builtin default configuration.

The vcl-file is expected under the following path: `/etc/varnish/default.vcl`   
You can change this path by using the env `VARNISH_VCL_PATH`:   
`VARNISH_VCL_PATH=/custom/path/varnish.vcl`

In case you want to run the varnishd without a vcl-file, you have to configure your backend manually.   
This is done by using the env `VARNISH_VCL_DEFAULT_BACKEND`:   
`VARNISH_VCL_DEFAULT_BACKEND=127.0.0.1:80`

#### Cache size
You can also modify the maximum cache size by env `VARNISH_RAM_STORAGE`, default is `128M`:   `VARNISH_RAM_STORAGE=1G`

#### Additional varnishd options
In case you want to feed the [varnishd](https://varnish-cache.org/docs/6.0/reference/varnishd.html) with custom [options](https://varnish-cache.org/docs/6.0/reference/varnishd.html#options), use env `VARNISHD_OPTS`:   
`VARNISHD_OPTS="-t 36000"`   

The following options are set by default:   
`-a :${VARNISH_PORT} -s default=malloc,${VARNISH_RAM_STORAGE}`   

If you want to overwrite those default-options - for example in order to store cache in a file instead of ram - use env `VARNISHD_DEFAULT_OPTS`:   
`VARNISHD_DEFAULT_OPTS=-a ${VARNISH_PORT} -s file,/tmp/varnish_storage.bin,50%` 

#### Varnishlog
By default, the `varnishd` runs in foreground and blocks `stdout`. Therefore there will be no logs available with `docker logs`.   
If you want [varnishlog](https://varnish-cache.org/docs/6.0/reference/varnishlog.html) to `stdout` you can use the env `VARNISHLOG`:   
`VARNISHLOG="true"`

It is also possible to pass additional [options](https://varnish-cache.org/docs/6.0/reference/varnishlog.html#options) to `varnishlog` by using env `VARNISHLOG_OPTS`:   
`VARNISHLOG_OPTS="-g session"`

### Get things running
#### With docker run
##### Basic
`$ docker run -d -v /host/path/varnish.vcl:/etc/varnish/default.vcl hermsi/alpine-varnish:stable`
##### Custom cache size
`$ docker run -d -v /host/path/varnish.vcl:/etc/varnish/default.vcl -e VARNISH_RAM_STORAGE=512M hermsi/alpine-varnish:stable`
##### Varnishlog enabled
`$ docker run -d -v /host/path/varnish.vcl:/etc/varnish/default.vcl -e VARNISHLOG=true hermsi/alpine-varnish:stable`

### With docker-compose
```yaml
version: '3'

services:
  varnish:
    image: hermsi/alpine-varnish
    volumes:
      - ./varnish.vcl:/etc/varnish/default.vcl
    environment:
      VARNISH_PORT: 8080
      VARNISH_RAM_STORAGE: 1G
      VARNISH_VCL_PATH: /etc/varnish/default.vcl
      VARNISHD_OPTS: -t 36000
      VARNISHLOG: true
      VARNISHLOG_OPTS: -g session 
```
