all: configure build run

# urls: 
# - http://stackoverflow.com/questions/16853224/read-environment-variable-in-make-file
# - http://stackoverflow.com/questions/10024279/how-to-use-shell-commands-in-makefile
# - http://stackoverflow.com/questions/16467718/how-to-print-out-a-variable-in-makefile
# - https://cmake.org/pipermail/cmake/2010-June/037669.html

DOCKER_IMAGE = $(USER)/google-test-examples:latest
# $(info DOCKER_IMAGE: $(DOCKER_IMAGE))

DOCKER_COMMAND = docker run \
		--rm \
		--tty \
		-v /etc/group:/etc/group:ro  \
		-v /etc/passwd:/etc/passwd:ro  \
		-u $(shell id -u $$USER):$(shell id -g $$USER)  \
		-v $(shell pwd):$(shell pwd)  \
		-w $(shell pwd)/build \
		-e "TERM=xterm-256color" \
		$(DOCKER_IMAGE)
# $(info DOCKER_COMMAND: $(DOCKER_COMMAND))

CMAKE_COMMAND = cmake
# $(info CMAKE_COMMAND: $(CMAKE_COMMAND))

configure: build/Makefile

build/Makefile: docker_image build_directory	
	$(DOCKER_COMMAND) bash -c "$(CMAKE_COMMAND) .."

build_directory:
	mkdir -p build

build: google-test-examples_test

google-test-examples_test: docker_image
	$(DOCKER_COMMAND) bash -c "$(CMAKE_COMMAND) --build ."

PRINT = @echo -e "\e[1;34mBuilding $<\e[0m"

run: docker_image google-test-examples_test
	$(PRINT) && $(DOCKER_COMMAND) bash -c "ctest -VV"


# urls:
# - https://docs.docker.com/engine/reference/commandline/build/#options
# - http://makefiletutorial.com/
#
# DOCKER_IMAGE_FIND = $(shell docker images -q $(DOCKER_IMAGE) 2> /dev/null)
# $(info DOCKER_IMAGE_FIND: $(DOCKER_IMAGE_FIND))
docker_image: build_docker_image

build_docker_image:
ifeq ($(strip $(shell docker images -q $(DOCKER_IMAGE) 2> /dev/null)),)
	docker build -t $(DOCKER_IMAGE) --file docker/Dockerfile .
endif

clean:
	rm -rf build/

clean_docker_image:
ifneq ($(strip $(shell docker images -q $(DOCKER_IMAGE) 2> /dev/null)),)
	docker rmi -f $(DOCKER_IMAGE)
else
	$(info No Docker image: $(DOCKER_IMAGE))
endif

.PHONY: all configure build run build_docker_image clean clean_docker_image