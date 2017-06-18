# Realm Object Server (Developer Edition) for Docker
[![Build Status](https://travis-ci.org/Didstopia/docker-realm-object-server.svg?branch=master)](https://travis-ci.org/Didstopia/docker-realm-object-server)
[![Join the chat at https://gitter.im/Didstopia/docker-realm-object-server](https://badges.gitter.im/Didstopia/docker-realm-object-server.svg)](https://gitter.im/Didstopia/docker-realm-object-server?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Provides a clean, easy and up to date way to run [Realm Object Server](https://realm.io/docs/realm-object-server/) inside a Docker container.

## How is this different?

In a nutshell: this project is fully automated.

In addition to testing the latest version of _Realm Object Server_, we also generate new tags on both GitHub and Docker Hub, all on a daily basis, so everything is always up to date and properly tested.

Note that the `latest` tag is not available for this image, as sticking to a specific version of _Realm Object Server_ makes much more sense for a production environment.

---

## Basic Usage

Sample usage:
```
docker run -p 9080:9080 -p 9443:9443 --name realm-object-server -v /srv/realm/data:/var/lib/realm/object-server -v /srv/realm/config:/etc/realm -d didstopia/realm-object-server:1.4.1-305
```

When the image runs for the first time, it will create both a `configuration.yml` file under `/etc/realm`, as well as SSH keys for _Realm Object Server_.

By default, only HTTP is enabled (port 9080), so you'll probably want to edit the config file to, for example, only enable HTTPS (port 9443).

---

## Contributing/Development

Before you begin you'll need the following:
- httpie
- jq
- packagecloud.io API token

You should be able to follow the logic in `.travis.yml` for setting up the environment, as well as for building the image.
Do note that the `Dockerfile` and the scripts contain special logic for handling production vs. test builds.

Create a file named `.env`, which currently supports the following environment variables:

```
PACKAGECLOUD_API_TOKEN=
REALM_VERSION=
```

Note that overriding `REALM_VERSION` is optional, and will otherwise query the packagecloud.io API for the latest version. Overriding this is useful when you want to work with a specific version, and not worry about a potential new version coming out at the same time.

You can skip the packagecloud.io API query for the version by setting `REALM_VERSION` to a valid _ROS_ version.

PRs and issue submission are very welcome, and will be merged/fixed in a timely fashion.

## Licenses

This project is provided under the [MIT License](https://github.com/Didstopia/docker-realm-object-server/blob/master/LICENSE).

The following license also apply to this project:
- [Realm Object Server (Developer License Terms)](https://realm.io/legal/developer-license-terms/)
