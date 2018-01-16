# rock-containers
Repo to store container sources

## Structure
This repo contains a structure allowing for tailoring applications
agnostic to the container management backend. The idea is that we
can create a new subdirectory to support a different orchestration
provider.

```
example/
  docker/
    Dockerfile
    other-files
    foo.txt
  kubernetes/
    pod1.json
    pod2.json
    whatever-goes-here.json
```

This sort of mirrors the structure used by Project Atomic's 
[nulecule library](https://github.com/projectatomic/nulecule-library).

## Containers

All the containers should be built upon **rocknsm/base**, which can be
found on [Docker Hub](https://hub.docker.com/r/rocknsm/base/) and in the
`base` directory. `base` is built upon the `centos/systemd` container. We
run our containers using systemd (See this [blog post](https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container/)
for discussion on the rationale. TLDR; you get lots of monitoring and
resource abilities and a familiar init structure.

**Requirements**. The one thing you have to ensure you do for this to work is
run the following on the host. After that, it just works :tm:
```
sudo setsebool container_manage_cgroup 1
```

Currently these containers are development. They add two things to the base
systemd container: [RockNSM Devel Repo](https://copr.fedorainfracloud.org/coprs/g/rocknsm/rocknsm-2.1/) and
[confd](https://github.com/kelseyhightower/confd). The first let's us easily
build and deploy RPMs and the second lets us template configuration files
and configure them using environment variables.

## TODO

We have several containers to build to make them [12 Factor](https://12factor.net/)
compliant. Check out the `example` and `zookeeper` builds to see examples
how to do it.

Lastly, I don't claim to be the end-all-be-all expert on these things. I accept
(and enjoy) a good argument. I have strong opinions, but happy to listen.

Thanks!


