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
	
.PHONY: start
start: ## docker-compose up --build ## (starts the minecraft server)
	@echo "📦 Starting Minecraft Server..."; \
	docker-compose up -d --build --force-recreate;

.PHONY: stop
stop: ## docker-compose stop --rmi all --remove-orphans: ## (stops and cleans up images, but keeps data)
	@echo "🛑 Stopping Minecraft Server and cleaning up..."; \
	docker-compose down --rmi all --remove-orphans;

.PHONY: down
down: ## down server
	@echo "👎🏻 Down server..."; \
	docker-compose down;

.PHONY: build
build: # Rebuild the docker container and try to get the latest papermc version
	@echo "🛠️ Building server and getting latest papermc version" ; \
	make stop; \
	make start; \
	make logs;

.PHONY: restart
restart: # restarts the server
	@echo "💣 Restarting the server (docker)"; \
	docker-compose restart; \
	make logs;

.PHONY: attach
attach: ## docker attach mcserver ## (attaches to minecraft paper jar for issuing commands)
	@echo "📌 Attaching to Minecraft..."; \
	echo "Ctrl-C stops minecraft and exits"; \
	echo "Ctrl-P Ctrl-Q only exits"; \
	echo ""; \
	echo "Type "help" for help."; \
	docker attach mcserver;

.PHONY: logs
logs: ## Show the last 20 lines of the logs
	echo "🧻 Logs..."; \
	docker-compose logs --tail 20 -f ;
