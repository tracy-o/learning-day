# Belfrage Threat Analysis

This analysis utilises a STRIDE and DREAD approach to analyse each identified threat.

STRIDE identifies each threat a target is vulnerable to.
```
S = Spoofing Identity
T = Tampering with data
R = Repudiation
I = Information Disclosure
D = Denial of Service
E = Elevation of user privileges
```

DREAD is used to measure different factors of each threat.
```
D = Damage, scored out of 10
R = Reproducibility, scored out of 10
E = Exploitability, scored out of 10
A = Affected users, scored as a percentage
D = Discoverability, scored out of 10

Total DREAD score is sum / 5.
```

![c4-level-1](../img/architecture/c4-level-1.svg)

## Threat targets

### (Target 1) Belfrage (S, T, R, I, D, E)
**Trust:** 5 **Value:** 5

#### Spoofing identity of a user (S)
A developer with access to private account keys could spoof the identity of a user.

##### Mitigation
- [X] Belfrage to only have access to public account keys to verify tokens.

##### DREAD
```
Damage            = 2/10
Reproducibility   = 10/10
Exploitability    = 2/10
Affected users    = 100%
Discoverability   = 8/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Spoofing identity of EC2 user (S)
All developers with SSH access, have sudo access. This means developers can switch
to the "component" user that we have created, that runs the application.

##### Mitigation
- [X] Cosmos SSH logs
- [ ] Additional logging software to detect user changes.
- [ ] Limit "component" user's permissions, as much as possible to limit damage area.

##### DREAD
```
Damage            = 2/10
Reproducibility   = 4/10
Exploitability    = 4/10
Affected users    = 10%
Discoverability   = 5/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Tampering with page content (T)
A developer alter the content on the page, before it is served to the user.

##### Mitigation
- [X] All code changes and deployments to require peer-review

##### DREAD
```
Damage            = 10/10
Reproducibility   = 1/10
Exploitability    = 2/10
Affected users    = 100%
Discoverability   = 8/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Tampering SSL certificates (T)
If an attacker gained access to Cosmos or AWS Amazon Certificate Manager (ACM), then they could replace the SSL certificate used to encrypt HTTPS traffic, and could therefore perform a packet sniffing attack and decrypt the traffic, containing personal information.

##### Mitigation
- [X] Limit access to ACM through the use of IAM policies.
- [X] Limit developer access to the Belfrage cosmos project.
- [X] Keep Belfrage in it's own AWS account.

##### DREAD
```
Damage            = 7/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 100%
Discoverability   = 2/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Developer SSHing onto an instance with malicious intent (R)
A developer could SSH onto a live instance, and make malicious changes to the instance, or AWS services the instance has permission to call.

##### Mitigation
- [X] Cosmos SSH audit log.
- [X] Limit cosmos project members.
- [X] Limit permissions available to each instance as much as possible.

##### DREAD
```
Damage            = 10/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 100%
Discoverability   = 8/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Personal information disclosure (I)
A malicious, or accidental code change that leads to caching personally identifiable information.

Caching private information, could potentially mean sharing this personal information with other users viewing that same page.

##### Mitigation
- [X] Only cache public responses.

##### DREAD
```
Damage            = 2/10
Reproducibility   = 10/10
Exploitability    = 10/10
Affected users    = 30%
Discoverability   = 1/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Belfrage signature bsig (I)
The `bsig` response header is the cache-key value Belfrage uses internally, and therefore an attacker wishing to perform a DDOS
attack can use this information to be most effective.

##### Mitigation
- [ ] Do not share the `bsig` value as a response header.

##### DREAD
```
Damage            = 1/10
Reproducibility   = 4/10
Exploitability    = 2/10
Affected users    = 1%
Discoverability   = 5/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Denial of service attack (D)
An attacker could target our public Belfrage DNS with a high number of requests per second.

##### Mitigation
- [X] Aggressive Belfrage scaling policy.
- [ ] Protect Belfrage stacks behind GTM with an internal BBC certificate on the network load balancer.

##### DREAD
```
Damage            = 10/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 100%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

#### AWS (S, T, R, I, D, E)
An attacker could target our cloud infrastructure:
- If AWS VPC features are attacked or modified maliciously (VPC, security groups)

- If AWS EC2 features are attacked or modified maliciously (Load balancer, the amazon AMI store)

- If AWS IAM features are attacked or modified maliciously (Lambda invoke permissions, fallback S3 storage permissions, cloudwatch permissions...)

##### Mitigation
- [ ] Provide cloud failover

##### DREAD
```
Damage            = 10/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 100%
Discoverability   = 1/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Elevated developer permissions (E)
A developer from another team could obtain elevated permissions to make malicious infrastructure changes to Belfrage.

##### Mitigation
- [X] Keep Belfrage infrastructure in a separate AWS account, and limit permissions to Belfrage engineers.
- [X] AWS cloud trail audit log.

##### DREAD
```
Damage            = 10/10
Reproducibility   = 1/10
Exploitability    = 5/10
Affected users    = 100%
Discoverability   = 8/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Elevated user permissions on an EC2 (E)
All developers that SSH onto an instance, have sudo access.

##### Mitigation
- [ ] Limit the permissions of users on EC2 instances.

##### DREAD
```
Damage            = 5/10
Reproducibility   = 3/10
Exploitability    = 3/10
Affected users    = 10%
Discoverability   = 8/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Elevated EC2 permissions (E)
An attacker with access to an EC2 would have access to the same AWS resources as that EC2.

##### Mitigation
- [X] Limit EC2 permissions using IAM as much as possible.
- [X] AWS CloudTrail to track the damage caused.

##### DREAD
```
Damage            = 3/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 50%
Discoverability   = 1/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 2) Monitor (I)
**Trust:** 5 **Value:** 5

#### Personal information disclosure (I)
Logs and metrics are sent to the Monitor app, which are then made available to developers. If it receives logs with personal information, then it'll make this available to developers.

An attack could be made to obtain user information by adding personal information to the logs.

##### Mitigation
- [X] Code & deployment review process.
- [X] Best-effort cleansing of personal information before logging in Belfrage.
- [ ] Use of a public, and private log. The private log will have a strict permissions policy to only allow authorised staff to view it.

##### DREAD
```
Damage            = 2/10
Reproducibility   = 6/10
Exploitability    = 1/10
Affected users    = 1%
Discoverability   = 1/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 3) Central Cache Processor - CCP (T)
**Trust:** 5 **Value:** 5

#### Modified distributed cache (T)
If an attacker gained write access to the distributed cache in S3, then they could alter the content of the page which would be seen by users, or delete them making Belfrage service less resilient.

##### Mitigation
- [ ] Encrypt fallback pages in transit and at rest.
- [X] Only authorise Belfrage EC2s to read from the S3 bucket.
- [X] Only authorise CCP EC2s & Belfrage Developers to write in the S3 bucket.
- [X] Only authorise CCP EC2s & Belfrage Developers to delete files in the S3 bucket.

##### DREAD
```
Damage            = 3/10
Reproducibility   = 7/10
Exploitability    = 7/10
Affected users    = 30%
Discoverability   = 5/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 4) Communication with Presentation Layer (D)
**Trust:** 4 **Value:** 5

#### Revoked invocation role (D)
If the role is revoked by a malicious engineer in the Presentation layer account, then Belfrage won't be able to contact the presentation layer.

##### Mitigation
- [X] Fallback pages for public content

##### DREAD
```
Damage            = 7/10
Reproducibility   = 6/10
Exploitability    = 6/10
Affected users    = 30%
Discoverability   = 6/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Presentation layer unavailable (D)
The Presentation layer is relied upon to serve content to the user. If this goes down or suffers an elevated error rate, then Belfrage will
not be able to serve a portion of the traffic.

##### Mitigation
- [X] Use Belfrage's fallback cache to serve stale-if-error in-case of Presentation layer downtime.
- [ ] Store an alternative version to be served from Belfrage, if the content is typically personalised

##### DREAD
```
Damage            = 3/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 50%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 5) Communication with FABL Layer (T, I)
**Trust:** 4 **Value:** 5

#### Compromised client certificate (T, I)
Belfrage uses a client certificate to call FABL. If this certificate is compromised then it would allow an attacker to tamper with the response to the user.

##### Mitigation
- [ ] Verify using a checksum sent in response header, encoded with a second certificate.

##### DREAD
```
Damage            = 7/10
Reproducibility   = 2/10
Exploitability    = 2/10
Affected users    = 60%
Discoverability   = 2/10
Total Score       = (N/A until confirmed scores)
```

-------

#### FABL unavailable (D)
FABL is relied upon to serve content to the user. If this goes down or suffers an elevated error rate, then Belfrage will
not be able to serve a portion of the traffic.

##### Mitigation
- [X] Use Belfrage's fallback cache to serve stale-if-error in-case of FABL downtime.
- [ ] Store an alternative version to be served from Belfrage, if the content is typically personalised

##### DREAD
```
Damage            = 3/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 50%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 6) Communication with Mozart Layer (T, I, D)
**Trust:** 4 **Value:** 5

#### Compromised SSL certificate (T, I)
Mozart doesn't require a client certificate to call it, although traffic is still SSL encrypted which could be compromised.

##### Mitigation
- [ ] Verify using a checksum sent in response header, encoded with a second certificate.

##### DREAD
```
Damage            = 7/10
Reproducibility   = 2/10
Exploitability    = 2/10
Affected users    = 60%
Discoverability   = 2/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Mozart unavailable (D)
Mozart is relied upon to serve content to the user. If this goes down or suffers an elevated error rate, then Belfrage will
not be able to serve a portion of the traffic.

##### Mitigation
- [X] Use Belfrage's fallback cache to serve stale-if-error in-case of Mozart downtime.

##### DREAD
```
Damage            = 3/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 50%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 7) IDCTA Flagpole (D)
**Trust:** 4 **Value:** 4

#### Private content denial of service (D)
Anyone with access to the IDCTA flagpole will be allowed to prevent Belfrage from serving private content.

##### Mitigation
- [X] Limit who has access to the IDCTA flagpole

##### DREAD
```
Damage            = 1/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 30%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 8) Account (D)
**Trust:** 4 **Value:** 5

#### Private content denial of service (D)
If the public keys provided by the Account service is attacked, and becomes unreachable, then Belfrage will reject valid user tokens from accessing personalised content.

In addition to this, all users will be redirected to the account login page, potentially inflicting very high traffic on the account team.

##### Mitigation
- [X] Deploy belfrage with "fallback" certificates baked into the RPM to avoid network calls and dependency on the Account service.

##### DREAD
```
Damage            = 1/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 30%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 9) AWS Logs (R, I)
**Trust:** 3 **Value:** 4

#### Altering the logs (R)
Before logs are sent to AWS, there is a period of time where the logs are stored on the instance, in a file.

A developer has the opportunity to modify the logs on the instance, before they are sent to AWS.

##### Mitigation
- [X] Cosmos SSH access logs.
- [ ] Restrict access to the log files on the instance, to the 'component' user running the application.

##### DREAD
```
Damage            = 1/10
Reproducibility   = 10/10
Exploitability    = 1/10
Affected users    = 1%
Discoverability   = 5/10
Total Score       = (N/A until confirmed scores)
```

-------

#### Personal information in AWS logs (I)
If we have accidentally logged personal information to AWS, then it is possible for AWS to gain access to those logs, and potentially other developers in the same AWS account.

(The AWS data privacy says we need to consent to allowing AWS access, but I'm not sure how this is enforced)

##### Mitigation
- [X] Best-effort to remove personal information from the logs.
- [X] Keep Belfrage in its own AWS account.

##### DREAD
```
Damage            = 1/10
Reproducibility   = 1/10
Exploitability    = 1/10
Affected users    = 1%
Discoverability   = 5/10
Total Score       = (N/A until confirmed scores)
```

-------

### (Target 10) AWS Metrics (I)
**Trust:** 3 **Value:** 4

#### System state (I)
If an attacker gains access to our metrics, then they can see what effect an attack is having on the system.

This would enable an attacker to deliberately exacerbate the issues they're causing.

##### Mitigation
- [X] Protect reading metrics using IAM roles.
- [X] Keep Belfrage in its own AWS account.
- [X] Cert-protected Grafana.

##### DREAD
```
Damage            = 3/10
Reproducibility   = 3/10
Exploitability    = 3/10
Affected users    = 1%
Discoverability   = 3/10
Total Score       = (N/A until confirmed scores)
```