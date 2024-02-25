# Valheim Dedicated Server in Docker

**Valheim** is an open-world survival video game, that takes place in a world where slain Vikings go to prove
themselves fit for the halls of Valhalla. As one such, the player begins with nothing and soon discovers that to reach
the Norse afterlife, they must defeat the evils that stalk Valheim. Led only by their instincts and occasional hints
from a raven, the player must prepare to fight the sworn enemies of Odin himself.

![Valheim Logo](https://raw.githubusercontent.com/LacledesLAN/gamesvr-valheim/main/.misc/logo_valheim.png "Valheim Dedicated Server in Docker")

## About The Server

This repository is maintained by [Laclede's LAN](https://lacledeslan.com). This image has been optimized for LAN party
events where internet access can be limited, oversaturated and/or unreliable. This image is not recommended for use as
an "always on" server, as it lacks maintenance tooling, such ass the ability to self-update.

If any documentation is unclear or it has any issues please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Linux

### Download

```shell
docker pull lacledeslan/gamesvr-valheim;
```

### Run Interactive Server

```shell
docker run -it --rm -p 2456-2458:2456-2458/udp --cap-add=sys_nice lacledeslan/gamesvr-valheim /app/valheim_server.x86_64 -name "My Valheim" -nographics -batchmode -password "PASSWORD" -port 2456 -world "Dedicated" -public 0
```

## Getting Started with Game Servers in Docker

[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable,
self-sufficient containers. For a crash course on running Dockerized game servers check out [Using Docker for Game
Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks,
and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for [Working with our
Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can
also browse all of our other Dockerized game servers: [Laclede's LAN Game Servers
Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers).
