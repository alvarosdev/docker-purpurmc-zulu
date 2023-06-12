<img src="https://github.com/als3bas/docker-purpurmc-zulu/blob/main/assets/logo_margins.png?raw=true" align="center" />


![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/als3bas/zulu-purpurmc/latest?label=latest&style=for-the-badge)
![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/als3bas/zulu-purpurmc/preview?label=preview&style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/als3bas/zulu-purpurmc?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/als3bas/docker-purpurmc-zulu?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/als3bas/docker-purpurmc-zulu/stable.yml?label=stable%20build&style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/als3bas/docker-purpurmc-zulu/experimental.yml?label=preview%20build&style=for-the-badge)

----

> **Disclaimer:** This project is designed for servers with diverse purposes and may not be the most suitable option for a large-scale server with a high player concurrency. It is important to note that it may require additional improvements and adjustments to effectively cater to such specific requirements. We recommend thoroughly evaluating the performance and scalability aspects before implementing it in a production environment.


This repository provides a Docker image that enables the execution of a [PurpurMC](https://purpurmc.org) server on the [Zulu OpenJDK](https://www.azul.com/downloads) platform. 

- **PurpurMC** serves as an enhanced, drop-in substitute for PaperMC servers, aiming at greater flexibility and adding new, enjoyable gameplay features.
  
- **Zulu OpenJDK** is a complimentary, fully compliant, and 100% open-source implementation of the Java SE Platform, Standard Edition.

Feel free to fork this repository and adapt it according to your requirements.

## Why Choose Zulu over Temurin, Graalvm, Corretto, etc?
The choice for Zulu was influenced by a desire for exploration, as most OpenJDK implementations are quite similar. The main concern with Zulu is that it depends on a single company, Azul, which retains the right to change their license or policies at their discretion.


# Prerequisites
The following requirements are necessary to run the Docker image:

* **Docker**: An essential platform to deploy applications inside software containers. Check out the [installation guide](https://docs.docker.com/desktop/) if not already installed.
* **Docker-compose**: A tool for defining and running multi-container Docker applications. 
* **Operating System**: Linux, [WSL2](https://learn.microsoft.com/en-us/windows/wsl/install), or MacOS are preferable.
* **Architecture**: The system architecture should be either amd64 or arm64.

# Configuring a docker-compose File
Although I recommend using docker-compose for its convenience and utility, you can opt for the Docker CLI if you prefer.

> **Caution**
> Remember to replace the PUID and PGID environment variables to operate as a non-root user.

Here's a sample `docker-compose.yml` configuration for the project:

```yml
version: "3.9"

services:
  minecraft:
    container_name: "mcserver"
    image: "als3bas/zulu-purpurmc:latest"
    restart: unless-stopped
    environment:
      - MEMORYSIZE: "1G"
      - PUID: "xxxx"
      - PGID: "xxxx"
      - PAPERMC_FLAGS : ""
      - PURPURMC_FLAGS: ""
    volumes:
      - ./:/data:rw
    ports:
      - "25565:25565"
    stdin_open: true
    tty: true
```

# Executing as a Non-root User

For security reasons, it's recommended to run the server as a non-root user. You can achieve this by setting the PUID and PGID environment variables to match the user and group ID of the chosen non-root user.

To retrieve these values, use the following command:

```sh
id $USER
# Output: uid=1000(alvaro) gid=984(users) groups=984(users),998(wheel),973(docker)

# docker-compose.yml
# In this example, 'alvaro' is the user with ID 1000 and 'users' is the group with ID 984.
environment:
  - PUID=1000
  - PGID=984
```

# Updating the Container

For keeping your container up-to-date, you have two options. You can either use the provided makefile command:

```sh
make update-container
```
or manually stop, pull the latest image, and restart the container using Docker Compose:
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

## Utilizing the Makefile 
You can leverage the Makefile provided in this repository for common operations. Here's a brief overview of what you can do:

```sh
# To start the server
make start

# To stop the server
make stop

# To bring down the server
make down

# To build the server (useful for updating the PurpurMC version). 
# Don't worry about losing your world, plugins, or configuration files — they are safe.
make build

# To restart the server (useful for refreshing configuration or plugin files)
make restart

# To attach to the server console. This allows you to execute server commands like /op, /reload, etc.
# Remember to use CTRL + P + Q to detach from the console without stopping the server
make attach

# To display the last 20 lines of the server log
make logs
```


# Common issues

* I can't upload/remove/edit files. [🔎 Click Here](#Executing-as-a-Non-root-User)
* Problems downloading .jar from mojang servers [🔎 Click Here](#Problems-downloading-jar-from-mojang-servers)
* The server crashes with Spark Profiler Modify the [🔎 docker-compose.yml](#Configuring-a-docker-compose-File)
  * Add this flag `-DPurpur.IReallyDontWantSpark=true` to the `PURPURMC_FLAGS` environment variable.


#  Problems downloading .jar from mojang servers

The `make logs` will show you something like this:

```sh
Downloading mojang_1.xx.xx.jar
mcserver-zulu  | Failed to download mojang_1.xx.xx.jar
mcserver-zulu  | java.net.UnknownHostException: xxxxxxxx.mojang.com
```

Probably you're using WSL2 and you have problems with the DNS server.
You have to modify/create the `/etc/docker/daemon.json` file and add your favorite dns server.

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
* This repo and the previous one are based on the work of [mtoensing](https://github.com/mtoensing/Docker-Minecraft-PaperMC-Server)

