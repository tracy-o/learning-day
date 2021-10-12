# Updating Elixir / Erlang for Belfrage! 
This guide will help you update the Belfrage application (and any other Elixir / Erlang apps) to a new version of Elixir / Erlang as well as update the application dependencies. 

1. The first step is to create a new Docker image using your new Elixir / Erlang versions. This is a bit of a nuicance to do as we are only able to access the Amazon Elastic Container Registry (ECR) through a jenkins job
    * Our Dockerfile in Devops-tools-ecr Repo: https://github.com/bbc/devops-tools-ecr/tree/master/containers/elixir-centos7
    * The Jenkins job: https://ci.news.tools.bbc.co.uk/job/bbc/job/devops-tools-ecr/
We need to create a new Docker image, passing in parameters for our wanted Elixir and Erlang versions as well as tagging the image with the Elixir version. To do this we have to replay the Jenkins job with slightly altered code inside the main script:



```
docker build -t elixir-centos7:xxxx --build-arg GIT_COMMIT=${REMOTE_GIT_COMMIT} --build-arg RUN_DISPLAY_URL=${env.RUN_DISPLAY_URL} --build-arg REPO_ADDRESS=${env.remote_repo_address} --build-arg ELIXIR_VERSION=xxxx --build-arg ERLANG_VERSION=zzzz .
docker push ${dockerRegistry}/elixir-centos7:xxxx
```
This code edit will build an image with Elixir version xxxx, Erlang version zzzz, the image will be tagged with the Elixir version xxxx and finally pushed up to AWS ECR which will make the image available to us.

2. Now it is time to make the changes within the repositories of the applications you wish to update, the new docker image you have created must be imported and used within the Jenkinsfile your application uses. This code below will import your Docker image and assign it to the variable `DockerImage`:

```
library 'devops-tools-jenkins'
def dockerRegistry = libraryResource('dockerregistry').trim()
def dockerImage = "${dockerRegistry}/bbc-news/elixir-centos7:xxxx"
```
Where xxxx is the version of ELixir you tagged the image with.

3. If all you needed to do was update Elixir / Erlang you can stop here. Just make sure you test and check everything works as expected. Carry on to read how to update application dependencies. 

4. When working with your Elixir / Erlang application you can run this series of commands:
(Making sure you are using the correct Elixir, Erlang versions in your local environment)
```
mix deps.get
mix deps.unlock --all
mix deps.update --all
mix hex.outdated
```
which will get all current dependencies, unlock your current mix.lock file so you are able to change the versions, update all depencies and then give you a status on all your dependencies. 
We want all the deps to be up-to-date so you may have to go through the mix.exs file and change the versions, be weary of this table (found in iex with `h Version`):

    `~>`           | Translation               
    `~> 2.0.0`     | `>= 2.0.0 and < 2.1.0`    
    `~> 2.1.2`     | `>= 2.1.2 and < 2.2.0`    
    `~> 2.1.3-dev` | `>= 2.1.3-dev and < 2.2.0`
    `~> 2.0`       | `>= 2.0.0 and < 3.0.0`    
    `~> 2.1`       | `>= 2.1.0 and < 3.0.0`  

Which can help you understand why for example you specifiy version 1.2 but 1.5 is being used in the mix.lock file. 

5. You will again of course need to run tests and check everything is working as expected.
