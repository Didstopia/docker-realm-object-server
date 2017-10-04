# Realm Object Server (Developer Edition) for Docker

[![Build Status](https://travis-ci.org/Didstopia/docker-realm-object-server.svg?branch=master)](https://travis-ci.org/Didstopia/docker-realm-object-server)
[![Join the chat at https://gitter.im/Didstopia/docker-realm-object-server](https://badges.gitter.im/Didstopia/docker-realm-object-server.svg)](https://gitter.im/Didstopia/docker-realm-object-server?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Provides a clean, easy and up to date way to run [Realm Object Server](https://realm.io/docs/realm-object-server/) inside a Docker container.

## How is this different?

In a nutshell: this project is fully automated.

In addition to testing the latest version of _Realm Object Server_, we also generate new tags on both GitHub and Docker Hub, all on a daily basis, so everything is always up to date and properly tested.

Note that the `latest` tag should not be used. Instead, use a specific version of _Realm Object Server_, as that it is both safer and more stable when running in a production environment.

## Basic Usage

Sample usage:
```
docker run -d -p 9080:9080 -p 9443:9443 -v /srv/realm/data:/var/lib/realm/object-server -v /srv/realm/config:/etc/realm -v /srv/realm/auth:/usr/local/lib/realm/auth/providers --name realm-object-server didstopia/realm-object-server:1.8.3-83
```

When the image runs for the first time, it will create both a `configuration.yml` file under `/etc/realm`, as well as SSH keys for _Realm Object Server_.

By default, only HTTP is enabled (port 9080), so you'll probably want to edit the config file to, for example, only enable HTTPS (port 9443).

## Using npm modules

Realm Functions can use Node.js/npm modules, but they need to be installed first.

You can specify an environment variable called `REALM_NPM_MODULES` with a value of comma separated npm modules you want to install and keep up to date, eg. `REALM_NPM_MODULES="request,mongoose"`.

You can also specify versions for the modules, just like you would when using `npm install`, eg. `REALM_NPM_MODULES="mongoose@4.11.13"`.

## Backup/Restore

By default, the Realm database is backed up to `/backups` once a day. Currently the backup script only works if 
the database exists at `/var/lib/realm/object-server`.

As automated backups are still a work in progress, you need to specifically enable automatic backups by setting the environment variable `ENABLE_BACKUPS="true"`.

## Troubleshooting

If you get `Error: Failed to resolve ':::9080'`, then you don't have IPv6 enabled (which you should have). If you for some reason can't enable IPv6, then you have to edit `configuration.yml`, replacing `listen_address: '::'` with `listen_address: '0.0.0.0'`.

## Contributing/Development

You should be able to follow the logic in `.travis.yml` for setting up the environment, as well as for building the image.
Do note that the `Dockerfile` and the scripts contain special logic for handling production vs. test builds.

PRs and issue submission are very welcome, and will be merged/fixed in a timely fashion.

You can build and run a development build with the following commands:
```bash
docker build -t didstopia/realm-object-server:development-test . && \
BUILDID=`docker history didstopia/realm-object-server:development-test | grep "LABEL TEST=FALSE" | awk '{print $1}'` && \
docker tag $BUILDID didstopia/realm-object-server:development && \
docker run -it --rm -p 9080:9080 -p 9443:9443 -e ENABLE_BACKUPS="true" -e REALM_NPM_MODULES="mongoose,request" -v $(pwd)/data:/app --name realm-object-server didstopia/realm-object-server:development
```

## Licenses

This project is provided under the [MIT License](https://github.com/Didstopia/docker-realm-object-server/blob/master/LICENSE).

The following license also apply to this project:
- [Realm Object Server (Developer License Terms)](https://realm.io/legal/developer-license-terms/)
