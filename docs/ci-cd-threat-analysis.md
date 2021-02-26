# CI/CD Threat Analysis

This threat analysis focusses on the CI/CD pipeline only. This covers Jenkins to build and push the RPM to Cosmos.

The external dependencies are applied in a few different places:
- Belfrage - libraries - hex package manager / github
- Build - Jenkins plugins
- Cosmos - RPMs

Legend fixed column:
- Yes - Remediation has already been done
- No - Remediation has not yet been done
- N/A - No remediation is deemed applicable as part of our threat assessment

Risk ID | Description | Remediation | Fixed? | Priority
--- | --- | --- | --- | ---
R1 | GitHub access for developers | Only Belfrage developers can merge and the code is reviewed with PRs. The main branch is protected. Developers have 2FA enabled. | Yes | N/A
R2 | GitHub access for Jenkins | Jenkins has credentials to access GitHub | No | Low
R3 | Tampering of Belfrage source code in GitHub | Protect the deployment branch and require code review before merge. Contributors have 2FA enabled. | Yes | N/A
R4 | Belfrage external libraries from hex package manager being modified | We point to a specific commit and can check the codebase | N/A | N/A
R5 | Belfrage external libraries from github being modified | We point to a specific commit and can check the codebase | N/A | N/A
R6 | Jenkins access | Any developer with a developer certificate can access Jenkins. | No | Low
R7 | Jenkins admin access | People on other teams and departments have admin access which gives them more control and could effect us | No | Medium
R8 | Jenkins plugins | These are only on Jenkins and the application build is inside a Docker container which they will not access. They could affect the binary output but this seems very low. We can review the plugins to remove unnecessary ones. | No | Low
R9 | Container images used for build | We use the latest public images. We could specify a particular version we have checked or build our own. | No | Low
R10 | Resources outside of container during pipeline steps and could be effected by plugins | Some part of the pipeline are in containers. Other parts are run direclty on Jenkins. Plugins could have vulnerabilities. | No | Low
R11 | Cosmos-release pushing something else | This would have to be done by someone with access to Jenkins | No | Low
R12 | Third-party RPM dependency vulnerabilities | Automated vulnerability scanning. Most RPM dependencies are from the BBC. | No | Medium
R13 | Tampering of repository service RPM dependencies | Ensure we use GPG keys, where possible, on included repositories. Most RPM dependencies are from the BBC. https://jira.dev.bbc.co.uk/browse/RESFRAME-4073  | Yes | Low
R14 | CentOS CVEs | Cosmos checks the CentOS CVEs and patches and highlights where these have been applied. They get applied during deployment. | Yes | N/A
R15 | Cosmos deploys | Cosmos controls access through Cosmos projects | N/A | N/A
