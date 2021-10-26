# How to complete deployments

## What are deployments?
Deployments give us a method to move what has been tested on our test environment to our live environment.

# How to complete a deployment 
1. View the diff between the test and live environment to view what is to be deployed, the easiest way to do this is to use the Moz app on the #belfrage slack channel with `moz diff belfrage' (this compares the git hashes for live and test which can be found on [cosmos](https://cosmos.tools.bbc.co.uk/))

2. Use the diff to post a message on #belfrage and #help-belfrage with a summary of the changes, this allows anyone who has an interest in the deployment to know their changes are soon to go live or for them to object if they do not wish changes to go live.

3. It is now time to go through each belfrage stack on cosmos and use the 'promote to live' button, you can then double check the values used on the config page are the live values. It is best to deploy the stacks in order from lest busy to the most busy so you can slowly ramp up the traffic. Currently, this order would be: WWW, Cedric, Sally, Bruce. Posting each of the [deployment terminals](https://cosmos.tools.bbc.co.uk/deployments/5639226) into the thread of the message you sent previously.

4. Whilst each stack deployment is going through you want to keep your eye on a few places to ensure nothing out of the ordinary is occuring:
    a. [Grafana](https://grafana.news.tools.bbc.co.uk/d/cZYVwjIWz/belfrage-dashboards?orgId=1) Any metric which looks to spike or severly drop and continue to do so after a significant time may be cause for concern.
    b. Specific endpoints ie: https://cedric.belfrage.api.bbc.co.uk/ can act as a good 'smoke test' to your deployments.
    c. Log output on specific instances after [sshing in](https://cosmos.tools.bbc.co.uk/services/bruce-belfrage/test/instances), using the command `cat /var/log/component/app.log` may show messages which can give you an insight on how the instance is doing.
    d. The deployment terminal may also provide messages which can show errors.

5. Once each of the stacks has been completed, put a final message on the same thread you have been using mentioning that the deployment is complete. Always good to keep an eye out on the previously mentioned data sources just to ensure no issues.