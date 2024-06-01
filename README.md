<img src="https://github.com/als3bas/docker-purpurmc-zulu/blob/main/assets/logo_margins.png?raw=true" align="center" />

![Docker Image Version (tag latest semver)](https://img.shields.io/docker/v/als3bas/zulu-purpurmc/latest?label=latest&style=for-the-badge)
![Docker Pulls](https://img.shields.io/docker/pulls/als3bas/zulu-purpurmc?style=for-the-badge)
![GitHub](https://img.shields.io/github/license/als3bas/docker-purpurmc-zulu?style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/als3bas/docker-purpurmc-zulu/stable.yml?label=stable%20build&style=for-the-badge)
![GitHub Workflow Status (with event)](https://img.shields.io/github/actions/workflow/status/als3bas/docker-purpurmc-zulu/experimental.yml?label=preview%20build&style=for-the-badge)


## About this Project

This project provides a Docker image that enables the execution of a PurpurMC server on the Zulu OpenJDK platform. PurpurMC serves as an enhanced, drop-in substitute for PaperMC servers, aiming at greater flexibility and adding new, enjoyable gameplay features.

Zulu OpenJDK is a complimentary, fully compliant, and 100% open-source implementation of the Java SE Platform, Standard Edition.

Feel free to fork this repository and adapt it according to your requirements.

### Why Choose Zulu over Temurin, Graalvm, Corretto, etc?

The choice for Zulu was influenced by a desire for exploration, as most OpenJDK implementations are quite similar. The main concern with Zulu is that it depends on a single company, Azul, which retains the right to change their license or policies at their discretion.

## Prerequisites

The following requirements are necessary to run the Docker image:
- **Docker**: An essential platform to deploy applications inside software containers. Check out the installation guide if not already installed.
- **Docker-compose**: A tool for defining and running multi-container Docker applications.
- **Operating System**: Preferably Linux, WSL2, or macOS.
- **Architecture**: The system architecture should be either amd64 or arm64.

## Configuring a Docker-compose File

Although I recommend using Docker Compose for its convenience and utility, you can opt for the Docker CLI if you prefer.

#### Caution
Remember to replace the `PUID` and `PGID` environment variables to operate as a non-root user.

Here's a sample `docker-compose.yml` configuration for the project:

```yaml
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
      - PAPERMC_FLAGS: ""
      - PURPURMC_FLAGS: ""
    volumes:
      - ./:/data:rw
    ports:
      - "25565:25565"
    stdin_open: true
    tty: true
```

### Executing as a Non-root User

For security reasons, it's recommended to run the server as a non-root user. You can achieve this by setting the `PUID` and `PGID` environment variables to match the user and group ID of the chosen non-root user.

To retrieve these values, use the following command:

```sh
id $USER
```

Output: `uid=1000(alvaro) gid=984(users) groups=984(users),998(wheel),973(docker)`

In this example, 'alvaro' is the user with ID `1000` and 'users' is the group with ID `984`.

```yaml
environment:
  - PUID=1000
  - PGID=984
```

## Running the Server

### Start

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

### Start the Server

```sh
make start
```

### Stop the Server

```sh
make stop
```

### Bring Down the Server

```sh
make down
```

### Build the Server

Useful for updating the PurpurMC version. Your world, plugins, or configuration files are safe.

```sh
make build
```

### Restart the Server

Useful for refreshing configuration or plugin files.

```sh
make restart
```

### Attach to the Server Console

Allows you to execute server commands like `/op`, `/reload`, etc. Remember to use `CTRL + P + Q` to detach from the console without stopping the server.

```sh
make attach
```

### Display the Last 20 Lines of the Server Log

```sh
make logs
```

## Updating the Container

To keep your container up to date, you have two options:

### Using the Makefile Command

```sh
make update-container
```

### Manually Using Docker Compose

```sh
docker-compose stop
docker-compose pull
docker-compose up -d
```

## Common Issues

### I can't upload/remove/edit files.

Don't forget the PUID and GUID. :P 


### Problems downloading `.jar` from Mojang servers

The `make logs` command will show you something like this:

```sh
Downloading mojang_1.xx.xx.jar
mcserver-zulu  | Failed to download mojang_1.xx.xx.jar
mcserver-zulu  | java.net.UnknownHostException: xxxxxxxx.mojang.com
```

Probably you're using WSL2 and you have problems with the DNS server. Modify/create the `/etc/docker/daemon.json` file and add your preferred DNS server.

Example:

```sh
sudo nano /etc/docker/daemon.json
```

Add:

```json
{
  "dns": ["1.1.1.1", "8.8.8.8"]
}
```

### The server crashes with Spark Profiler

Modify the `docker-compose.yml`. Add this flag `-DPurpur.IReallyDontWantSpark=true` to the `PURPURMC_FLAGS` environment variable.

## References

This repo is based on the work of `mtoensing`.

## Disclaimer

This project is designed for servers with diverse purposes and may not be the most suitable option for a large-scale server with high player concurrency. It may require additional improvements and adjustments to effectively cater to such specific requirements. Thoroughly evaluate the performance and scalability aspects before implementing it in a production environment.
