all: configure build run

# urls: 
# - http://stackoverflow.com/questions/16853224/read-environment-variable-in-make-file
# - http://stackoverflow.com/questions/10024279/how-to-use-shell-commands-in-makefile
# - http://stackoverflow.com/questions/16467718/how-to-print-out-a-variable-in-makefile
# - https://cmake.org/pipermail/cmake/2010-June/037669.html

DOCKER_COMMAND = docker run \
		--rm \
		-v /etc/group:/etc/group:ro  \
		-v /etc/passwd:/etc/passwd:ro  \
		-u $(shell id -u $$USER):$(shell id -g $$USER)  \
		-v $(shell pwd):$(shell pwd)  \
		-w $(shell pwd)/build \
		$(USER)/google-test-examples:latest

CMAKE_COMMAND = cmake

# $(info DOCKER_COMMAND: $(DOCKER_COMMAND))

configure: build/Makefile

build/Makefile: build_directory	
	$(DOCKER_COMMAND) bash -c "$(CMAKE_COMMAND) .."

build_directory:
	mkdir -p build

build: google-test-examples_test

google-test-examples_test:
	$(DOCKER_COMMAND) bash -c "$(CMAKE_COMMAND) --build ."

run: google-test-examples_test
	$(DOCKER_COMMAND) bash -c "ctest -VV"

clean:
	rm -rf build/

.PHONY: all configure build run clean