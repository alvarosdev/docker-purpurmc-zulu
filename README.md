# Minecraft Java server 1.19 with PurpurMC & Zulu OpenJDK

This is a docker image for [PurpurMC](https://purpurmc.org) with [Zulu OpenJDK (Debian)](https://www.azul.com/downloads) as runtime.
You're free to fork this repo and modify it to your liking.

# What is [PurpurMC](https://purpurmc.org)?
Purpur is a drop-in replacement for Paper servers designed for configurability and new, fun, exciting gameplay features.

# What is [Zulu OpenJDK](https://www.azul.com/downloads)?
> Zulu OpenJDK is a free, fully compliant, 100% open-source implementation of the Java SE Platform, Standard Edition.
>
> That's  _The Official description of Zulu OpenJDK_ on their website.

### IMHO:
> Zulu has a good Garbage Collector and memory usage, and it is (according to internet nerds) stable than others OpenJDK implementations.
> I'm not a Java Developer so I don't know if this is true, but I have been using it for a long time and I haven't had any problems running the game and the server.

# Requirements
* docker
* docker-compose
* A Linux system or WSL2
* Architecture: amd64 or arm64.

# Creating a docker-compose.yml file
I work with docker-compose, so I will show you how to run it with docker-compose.

```yml
version: "3.9"

services:
  minecraft:
    container_name: "mcserver"
    image: "als3bas/zulu-purpurmc:latest"
    # if you want to use the Dockerfile in this repo
    # uncomment the following lines and comment the image line
    # build: 
    #   context: .
    #   dockerfile: Dockerfile
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

# Update the container

```sh
make update-container
```
or
```sh
docker-compose stop
docker-compose pull
docker-compose up -d
``` 

# Running the server

### Run
Run the server with the following command:

```sh
docker-compose up -d --build
```

### Stop
Stop the server with the following command:

```sh
docker-compose stop
``` 

### Logs
To see the logs of the server, run the following command:

```sh
docker-compose logs -f 
```

## Using the makefile 
You can use the makefile on this repo
```sh
# run the server
make start

# stop the server
make stop

# down the server
make down

# build the server
# useful if you want to update the purpurmc version
# you won't lose your world, plugins or config files 😉
make build

# restart the server
# useful if you want to update the config or plugin files 
make restart

# attach to the server console
# you can use the server commands like /op /reload, etc
# Remember to use CTRL + P + Q to detach from the console without stopping the server
make attach

# show the last 20 lines of the log
make logs
```


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
