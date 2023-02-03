COMMAND_COLOR = \033[36m
DESC_COLOR    = \033[32m
CLEAR_COLOR   = \033[0m

.PHONY: help
help: ## prints this message ## 
	@echo ""; \
	echo "Usage: make <command>"; \
	echo ""; \
	echo "where <command> is one of the following:"; \
	echo ""; \
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	perl -nle '/(.*?): ## (.*?) ## (.*$$)/; if ($$3 eq "") { printf ( "$(COMMAND_COLOR)%-20s$(DESC_COLOR)%s$(CLEAR_COLOR)\n\n", $$1, $$2) } else { printf ( "$(COMMAND_COLOR)%-20s$(DESC_COLOR)%s$(CLEAR_COLOR)\n%-20s%s\n\n", $$1, $$2, " ", $$3) }';

.PHONY: up
up: ## 🚙 Runs the Minecraft server ## (docker-compose up -d) 
	@echo "📦 Starting Minecraft Server..."; \
	docker-compose up -d;

.PHONY: stop
stop: ## 🛑 Stops the Minecraft server ## (docker-compose stop) 
	@echo "🛑 Stopping Minecraft Server and cleaning up..."; \
	docker-compose stop;

.PHONY: down
down: ## 👎 Stops and remove containers, but keeps data ## (docker-compose down) 
	@echo "👎🏻 Down server..."; \
	docker-compose down;

.PHONY: build
build: ## 📦 Rebuilds the container (Keeps Data) ## (Only with the Dockerfile, otherwise 'update-container' command ) 
	@echo "🛠️ Building server and getting latest papermc version" ; \
	docker-compose down --rmi all --remove-orphans;
	docker-compose up -d --build --force-recreate; \
	make logs;

.PHONY: restart
restart: ## 🔃 Restarts the container  ## (Useful to reload plugins or config files, this will kick all players)
	@echo "💣 Restarting the server (docker)"; \
	docker-compose restart; \
	make logs;

.PHONY: update-container
update-container: ## 💻 Update the container image ## (Only with the docker-compose image, otherwise 'build' command)
	@echo "💣 Restarting the server (docker)"; \
	docker-compose stop; \
	docker-compose pull; \
	docker-compose up -d; \
	make logs;

.PHONY: attach
attach: ## 💻 Attach the Minecraft server console ## (Remember to press Ctrl-P Ctrl-Q to detach, not Ctrl-C) 
	@echo "📌 Attaching to Minecraft..."; \
	echo "Ctrl-C stops Minecraft and exits"; \
	echo "Ctrl-P Ctrl-Q only exits"; \
	echo ""; \
	echo "Type "help" for help."; \
	docker attach mcserver;

.PHONY: logs
logs: ## 🧻 Show the last 20 logs ## (docker-compose logs --tail 20 -f) 
	echo "🧻 Logs..."; \
	docker-compose logs --tail 20 -f ;
