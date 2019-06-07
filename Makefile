PROJECT := browser_on_docker
REPOSITORY := $(PROJECT)/browser_on_docker
TAG := latest
NETWORK := $(PROJECT)_nw
BROWSER := $(PROJECT)_browser
TIME_ZONE := Asia/Tokyo

verify:
	Docker build -t $(REPOSITORY):$(TAG) .
	if [ -z "`docker network ls | grep $(NETWORK)`" ]; then \
		docker network create --driver bridge $(NETWORK); \
	fi
	# FYI:
	#   - https://github.com/SeleniumHQ/docker-selenium
	# TODO: More sophisticated way to wait browser container setup
	if [ -z "`docker ps | grep $(BROWSER)`" ]; then \
		docker run --name $(BROWSER) --network $(NETWORK) -v /dev/shm:/dev/shm -d \
		-e TZ=$(TIME_ZONE) -e START_XVFB=false selenium/standalone-chrome-debug:latest \
		&& sleep 5; \
	fi
	docker run --rm --network $(NETWORK) \
		-e TZ=$(TIME_ZONE) $(REPOSITORY):$(TAG)
