[![Build Status](https://travis-ci.org/Didstopia/docker-realm-object-server.svg?branch=master)](https://travis-ci.org/Didstopia/docker-realm-object-server)

# Realm Object Server for Docker

_NOTE: This uses the free Developer Edition of the Realm Object Server._

This Docker image is fully automated, both in terms of testing the latest version of _ROS_, but also generating new tags on both GitHub and Docker Hub.

The `latest` tag is not available for this image, as sticking to a specific version of _ROS_ makes more sense for a production environment.

---

## Usage

Sample usage:
```
docker run -p 9080:9080 -p 9443:9443 --name realm-object-server -v /srv/realm/data:/var/lib/realm/object-server -v /srv/realm/config:/etc/realm -d didstopia/realm-object-server:1.4.1-305
```

When the image runs for the first time, it will create both a `configuration.yml` file under `/etc/realm`, as well as SSH keys for Realm Object Server.

By default, only HTTP is enabled (port 9080), so you'll probably want to edit the config file to, for example, only enable HTTPS (port 9443).

---

## Development

Before you begin you'll need the following:
- httpie
- jq
- packagecloud.io API token

Create a file named `.env`, which currently supports the following environment variables:

```
PACKAGECLOUD_API_TOKEN=
REALM_VERSION=
```

Note that overriding `REALM_VERSION` is optional, and will otherwise query the packagecloud.io API for the latest version. Overriding this is useful when you want to work with a specific version, and not worry about a potential new version coming out at the same time.

You can skip the packagecloud.io API query for the version by setting `REALM_VERSION` to a valid _ROS_ version.
