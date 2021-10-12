# How do we build Belfrage?
GitHub PRs -> Jenkins -> Cosmos -> Manual Deploys

## Pr checks
When a PR is pushed to GitHub, we automatically run the belfrage jenkins job, that checks formatting of the codebase, and runs the tests. This then reports back to GitHub the status of the PR.

## Creating a release of master.
When a PR is merged to master the same jenkins build job is run. This time it packages up the application into an RPM and creates a Cosmos Release. The release can then be deployed to the `test` environment manually.

## Releasing a branch
It is possible to release a non-master branch of Belfrage using the `FORCE_RELEASE` parameter on the Jenkins job when ran manually. This bypasses the release checks that typically prevent a release from being pushed when on a non-master branch. This allows us to test branches of Belfrage on the cosmos `test` environment. These branch releases are identifiable by the cosmos release ID having the name of the branch appended to the release ID. For example `253.my.test.branch`, instead of a master release of `254`, so that we don't accidentally push a branch release to `live`.

## Building a production release of the elixir app
We use the `distillery` tool to build a production version of Belfrage. It creates an executable file, with some supporting configuration files, and compresses them into a `.tar`. This `.tar` file is then packaged into an RPM, that forms the release.

## Releasing the cosmos config
The configuration values for Belfrage are stored in the belfrage-build repo. To update Cosmos with any changes in belfrage-build the same Jenkins job can be run. The job accepts an ENVIRONMENT parameter, and if it’s run on the master branch, it will push the environment specific cosmos config to the specified environment.

The values would then be deployed on the next Belfrage release, or a cosmos "configuration deployment".

## Deploying Belfrage on cosmos.
The cosmos releases are not automatically promoted through the environments. Once they are released to cosmos, they remain there until a developer decides to promote a release. We do not deploy non-master releases to `live`.

## Build Diagram

![](https://user-images.githubusercontent.com/1760227/66404805-0c9c6400-e9e1-11e9-9fc2-d3e55d851f28.png)

## Links
- [Jenkinsfile](https://github.com/bbc/belfrage/blob/master/Jenkinsfile)
- [Jenkins build](https://ci.news.tools.bbc.co.uk/job/bbc/job/belfrage/job/master/build?delay=0sec)
- [Belfrage on cosmos](https://cosmos.tools.bbc.co.uk/services/belfrage)
- [Distillery](https://github.com/bitwalker/distillery)
- [Belfrage build](https://github.com/bbc/belfrage-build)