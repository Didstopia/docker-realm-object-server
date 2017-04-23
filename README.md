[![Build Status](https://travis-ci.org/Didstopia/docker-realm-object-server.svg?branch=master)](https://travis-ci.org/Didstopia/docker-realm-object-server)

# Realm Object Server for Docker

_NOTE: This uses the free Developer Edition of the Realm Object Server._

**NOTE**: This is still a work in progress. If possible, do not use this in production yet.

More information will be available soon, as there are still a few pieces of the puzzle missing.

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
