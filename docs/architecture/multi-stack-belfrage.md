# Belfrage Stacks

Belfrage operates across multiple stacks. We have a set of stacks used for damage limitation when rolling out new releases, and another set of stacks used for varying reasons.

At the time of writing, stacks designed to serve live requests are:
- bruce-belfrage
    - Bruce is the main stack for webcore traffic 
    - [Cosmos](https://cosmos.tools.bbc.co.uk/services/bruce-belfrage)
    - [Live endpoint](https://bruce.belfrage.api.bbc.co.uk/)
    - [Test endpoint](https://bruce.belfrage.test.api.bbc.co.uk/)

- cedric-belfrage
    - Cedric serves CDN traffic from Akamai
    - [Cosmos](https://cosmos.tools.bbc.co.uk/services/cedric-belfrage)
    - [Live endpoint](https://cedric.belfrage.api.bbc.co.uk/)
    - [Test endpoint](https://cedric.belfrage.test.api.bbc.co.uk/)
    - [Confluence](https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+CDN)

- sally-belfrage
    - Sally serves world service traffic 
    - [Cosmos](https://cosmos.tools.bbc.co.uk/services/sally-belfrage)
    - [Live endpoint](https://sally.belfrage.api.bbc.co.uk/)
    - [Test endpoint](https://sally.belfrage.test.api.bbc.co.uk/)

- sydney-belfrage
    - Sydney serves world service traffic 
    - [Cosmos](https://cosmos.tools.bbc.co.uk/services/sydney-belfrage)
    - [Live endpoint](https://sydney.belfrage.api.bbc.co.uk/)
    - [Test endpoint](https://sydney.belfrage.test.api.bbc.co.uk/)

- joan-belfrage
    - Joan is a proxy for news traffic between GTM and Mozart 
    - [Cosmos](https://cosmos.tools.bbc.co.uk/services/joan-belfrage)
    - [Live endpoint](https://joan.belfrage.api.bbc.co.uk/)
    - [Test endpoint](https://joan.belfrage.test.api.bbc.co.uk/)
    - [Architecture Diagram](../img/joan-belf-arch.png)


Other stacks running belfrage are:
- [belfrage-preview](https://cosmos.tools.bbc.co.uk/services/belfrage-preview)
- [belfrage-playground](https://cosmos.tools.bbc.co.uk/services/belfrage-playground)
- [original belfrage stack being decommissioned](https://cosmos.tools.bbc.co.uk/services/belfrage)


## Adding a new stack
Here is a ticket which has links to the varying PRs required to setup a new stack that receives live user traffic.

Links that may help:
- https://jira.dev.bbc.co.uk/browse/RESFRAME-4096
    - Ticket to create Sally, one of our stacks. Contains links to all required PRs
- https://jira.dev.bbc.co.uk/browse/RESFRAME-3400
    - Original Multistack ticket. Contains list of required updated areas.
- https://confluence.dev.bbc.co.uk/display/BELFRAGE/Creating+new+Belfrage+stacks
    - More documentation relating to creating a stack.


Some necessary considerations for creating a new stack:
- If it's serving live traffic, use `multi-belfrage` setup [in the frameworks infra repo](https://github.com/bbc/frameworks-infra/tree/master/belfrage/multi-belfrage) repo.
- [Mozart cosmos events](https://github.com/bbc/mozart-cosmos-events) lambda updates for forwarding alarms and triggering jenkins jobs after deployments.
- [Grafana](https://github.com/bbc/news-grafana) new dashboards to display the stack's metrics.
- [Belfrage smoke tests](https://github.com/bbc/belfrage) to test the new stack.
- Update documentation
    - [Belfrage Documentation](https://github.com/bbc/belfrage/tree/master/docs)
    - [Runbook](https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book)
