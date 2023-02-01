# Docker Minecraft JAVA, Running Purpur on Zulu OpenJDK
This is a docker image to run a Minecraft Java Edition server with Purpur on Zulu OpenJDK. This works on AMD64 and ARM64 Machines.

# What is [PurpurMC](https://purpurmc.org)?
> Purpur is a drop-in replacement for Paper servers designed for configurability and new, fun, exciting gameplay features.


# How to run

## Requirements
* docker
* docker-compose
* A Linux system or WSL2
* Architecture: amd64 or arm64.
  
> **Note**
> I'm running this image on a Oracle arm64 instance on Oracle Cloud.
> Also a Windows Machine with WSL2 (amd64).

## Create a docker-compose.yml file
I work with docker-compose, so I will show you how to run it with docker-compose.

```yml
version: "3.9"

services:
  minecraft:
    container_name: "minecraftpurpur"
    image: "als3bas/zulu-purpurmc:latest"
    restart: unless-stopped
    environment:
      - MEMORYSIZE: "1G"
      - PUID: "1000"
      - PGID: "984"
      - PAPERMC_FLAGS : ""
      - PURPURMC_FLAGS: ""
      ### if you have problems with spark, you can disable it with this flag "-DPurpur.IReallyDontWantSpark=true" on PURPURMC_FLAGS
    volumes:
      - ./:/data:rw
    ports:
      - "25565:25565"
    stdin_open: true
    tty: true
```

## Running


# Known issues

## Running as non-root user

You must set the PUID and PGID environment variables to the user and group id of the user you want to run the server as.
To get this information, run the following command:

```sh
id $USER
uid=1000(alvaro) gid=984(users) groups=984(users),998(wheel),973(docker)
```

And in docker-compose.yml file add the following environment variables:

```yaml
# docker-compose.yml
# In this example the user is alvaro 1000 and the group is users 984
environment:
  - PUID=1000
  - PGID=984
```

> **Note**
> This step is necessary because the server needs to write to the volume, and the user must have the correct permissions to edit outside the container.

##  Failed to download mojang_1.x.x.jar

If you are using WSL2, and you have a problem like this one. 

```sh
...
Downloading mojang_1.19.3.jar
mcserver-zulu  | Failed to download mojang_1.19.3.jar
mcserver-zulu  | java.net.UnknownHostException: piston-data.mojang.com
...
```

You must modify/create the `/etc/docker/daemon.json` file and add your favorite dns server.

Example:
```sh
sudo nano /etc/docker/daemon.json
```
```json
{
  "dns": ["1.1.1.1", "8.8.8.8"]
}
```

# References
* This docker image is based on my repo [docker-papermc-graalvm](https://github.com/als3bas/docker-papermc-graalvm) which uses PaperMC & GraalVM as runtime.
* Based on the work of [mtoensing papermc server](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server)
