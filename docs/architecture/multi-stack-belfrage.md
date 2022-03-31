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

https://jira.dev.bbc.co.uk/browse/RESFRAME-4096

Some necessary considerations for creating a new stack:
- If it's serving live traffic, use `multi-belfrage` setup [in the frameworks infra repo](https://github.com/bbc/frameworks-infra/tree/master/belfrage/multi-belfrage) repo.
- [Mozart cosmos events](https://github.com/bbc/mozart-cosmos-events) lambda updates for forwarding alarms and triggering jenkins jobs after deployments.
- [Belfrage Monitor](https://github.com/bbc/belfrage-monitor) and [Monitor's UI](https://github.com/bbc/belfrage-monitor-ui) will require updates to show the stack's real-time data.
- [Grafana](https://github.com/bbc/news-grafana) new dashboards to display the stack's metrics.
- [Belfrage smoke tests](https://github.com/bbc/belfrage) to test the new stack.