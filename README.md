# Varnish, a caching reverse proxy

[![pipeline status](https://gitlab.com/hermsi1337/docker-varnish/badges/master/pipeline.svg)](https://gitlab.com/hermsi1337/docker-varnish/-/commits/master)
[![Docker Pulls](https://img.shields.io/docker/pulls/hermsi/alpine-varnish?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-varnish/)
[![Docker Stars](https://img.shields.io/docker/stars/hermsi/alpine-varnish?style=flat-square)](https://hub.docker.com/r/hermsi/alpine-varnish/)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/hermsi/alpine-varnish?sort=semver&style=flat-square)](https://hub.docker.com/r/hermsi/alpine-varnish/)
[![Docker Image Size](https://img.shields.io/docker/image-size/hermsi/alpine-varnish?sort=date&style=flat-square)](https://hub.docker.com/r/hermsi/alpine-varnish/)
[![Donate](https://img.shields.io/badge/Donate-PayPal-yellow.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=T85UYT37P3YNJ&source=url)

Use this image to start your own varnish server fast and easy.

## Regular builds, automagically

Thanks to [Gitlab-CI](https://gitlab.com/hermsi1337/docker-varnish) this image is pushed weekly and creates new [tags](https://hub.docker.com/r/hermsi/alpine-varnish/tags/) if there are new versions available.

## Tags

For recent tags check [dockerhub](https://hub.docker.com/r/hermsi/alpine-varnish/tags) or [quay](https://quay.io/repository/hermsi1337/alpine-varnish).  
There are several versions of Varnish available.  
This repository provides very fine grained tags in order to fit your needs.  
The `latest`-tag always points to the "fresh"- , while the `stable`-tag points to the "supported" [releases](https://varnish-cache.org/releases/).

* `7.0`, `7.0.0`, `latest`
* `6.6`, `6.6.1`
* `6.5` (`EOL`)
* `6.4` (`EOL`)
* `6.3` (`EOL`)
* `6.2`, `6.2.0` (`EOL`)
* `6.1`, `6.1.1` (`EOL`)
* `6.0`, `6.0.0`, `stable`
* `5.2`, `5.2.1` (`EOL`)
* `4.1` `4.1.9` (`EOL`)
* `3.0`, `3.0.5` (`EOL`)

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
      VARNISHD_ADDITIONAL_OPTS: -t 36000
      VARNISHLOG: 'true'
      VARNISHLOG_OPTS: -g sessiong
```
