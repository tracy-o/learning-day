# How to complete deployments

## What are deployments?
A deployment is the act of moving a build from one evironment to another.
Deployments to test are automatic, whenever anything is merged into master a deployment to test is completed. This is a core part of our CI-CD.
Deployments to live and deployments of a non-master branch must be completed manually.

## How to complete a deployment 
1. View the diff between the test and live environment to see what is to be deployed, the easiest way to do this is to use the Moz app on the #belfrage slack channel with `moz diff belfrage` (this compares the git hashes for live and test which can be found on [cosmos](https://cosmos.tools.bbc.co.uk/))

2. Use the diff to post a message on #belfrage and #help-belfrage with a summary of the changes, this allows anyone who has an interest in the deployment to know their changes are soon to go live. 

3. It is now time to go through each belfrage stack on cosmos and use the 'promote to live' button, you can then double check the values used on the config page are the live values. It is best to deploy the stacks in order from least busy to the most busy so you can slowly ramp up the traffic. Currently, this order would be: WWW, Joan, Cedric, Sally, Bruce. Posting each of the [deployment terminals](https://cosmos.tools.bbc.co.uk/deployments/5639226) links into the thread of the message you sent previously.

4. Whilst each stack deployment is going through you want to keep your eye on a few places to ensure nothing out of the ordinary is occuring:   
    a. [Grafana](https://grafana.news.tools.bbc.co.uk/d/cZYVwjIWz/belfrage-dashboards?orgId=1) Any metric which looks to spike or severly drop and continue to do so after a significant time may be cause for concern.   
    b. Specific endpoints ie: https://cedric.belfrage.api.bbc.co.uk/ can be useful to test specific paths for diffrent stacks such as world service routes for the Sally stack, double checking you are actually hitting the new instances not the old ones.    
    c. Log output on specific instances after [sshing in](https://cosmos.tools.bbc.co.uk/services/bruce-belfrage/test/instances), using the command `tail -f /var/log/component/*.log` will print all incoming messages and may show messages which can give you an insight on how the instance is doing.   
    d. The deployment terminal may also provide messages which can show errors.

5. Once each of the stacks has been completed, put a final message on the same thread you have been using mentioning that the deployment is complete. It is also a good idea to recheck the Grafana graphs and direct endpoints to ensure no problems have occured to the previously deployed stacks as sometimes it can take time for issues to arise.

## If something goes wrong
If you believe an error has occured with the deployment and belfrage is acting in an unexpected way, you will need to go through these steps:

1. Notify the thread that you used previously that you will be performing a roll back

2. On cosmos, go through each stack and promote the last stable build which was already on live, from test to 
live. This rolls back the application to before the deployment.

3. Attempt to debug and uncover the source of the issue before re-trying to deploy.

## How to deploy a non-master branch
Deploying a non-master branch can be helpful to test your work as it allows you to debug and test changes which you may not be able to do locally.

1. You must first visit the [belfrage-multi-stack](https://ci.news.tools.bbc.co.uk/job/belfrage-multi-stack/) jenkins job
2. Click 'Scan Repository Now' to ensure your branch is picked up
3. Click on your branch from the list of branches
4. Press 'Build Now' (If the branch has already been built, skip to 5)
5. If the build passes then you will be able to select 'Build with Parameters'
6. Select the stack you want to deploy to from the 'SERVICE' drop down menu
7. Tick the 'FORCE_RELEASE' and press build, this will build your branch and release it on the stack you selected on [cosmos](https://cosmos.tools.bbc.co.uk/projects/belfrage) on test
