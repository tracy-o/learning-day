# How to generate `.csr` and `.key` files for cert renewal process

First, make any changes required to the `.conf` files in either `/live` or `/test`, usually this is only adding new domains.

Next run: (replace `test` for `live` as required)

```
openssl req -new -newkey rsa:2048 -nodes -sha256 -config certs/test/belfrage.test.api.bbc.co.uk.conf -keyout belfrage.test.api.bbc.co.uk.key -out belfrage.test.api.bbc.co.uk.csr
```

This will create a `.csr` and `.key` file in the root of the repo. The `.csr` will need to be attached to a request made through [Essentials Requests](https://som-myit.onbmc.com/dwp/app/#/itemprofile/13003). If that link has moved, search for "globalsign" in the Essentials Requests catalogue.

The Jira ticket for the last request can be found [here](https://jira.dev.bbc.co.uk/browse/RESFRAME-4550).