cmake_minimum_required(VERSION 2.8)

set(build_dir ${CMAKE_CURRENT_LIST_DIR}/build)

if(NOT EXISTS ${build_dir})
	  file(MAKE_DIRECTORY ${build_dir})
endif()

execute_process(
  COMMAND id -u $ENV{USER}
  OUTPUT_VARIABLE id_user
)
execute_process(
  COMMAND id -g $ENV{USER}
  OUTPUT_VARIABLE id_group
)
# url: http://stackoverflow.com/questions/39496043/how-to-strip-trailing-newline-in-cmake-variable
string(REGEX REPLACE "\n$" "" id_user "${id_user}")
string(REGEX REPLACE "\n$" "" id_group "${id_group}")
#
MESSAGE(id_user: ${id_user})
MESSAGE(id_group: ${id_group})

# urls: 
# - https://denibertovic.com/posts/handling-permissions-with-docker-volumes/
# - http://stackoverflow.com/questions/690223/how-to-retrieve-a-user-environment-variable-in-cmake-windows
SET(DOCKER_RUN_CMD 
	docker run 
		--rm
		-v /etc/group:/etc/group:ro 
		-v /etc/passwd:/etc/passwd:ro 
		-u ${id_user}:${id_group} 
		-v ${build_dir}/..:${build_dir}/.. 
		-w ${build_dir} 
		$ENV{USER}/google-test-examples:latest
)

execute_process(
  COMMAND ${DOCKER_RUN_CMD} bash -c "${CMAKE_COMMAND} .."
)

execute_process(
  COMMAND ${DOCKER_RUN_CMD} bash -c "${CMAKE_COMMAND} --build ."
  WORKING_DIRECTORY ${build_dir}
)


execute_process(
  COMMAND ${DOCKER_RUN_CMD} bash -c "ctest -VV"
  WORKING_DIRECTORY ${build_dir}
  RESULT_VARIABLE test_result
)

if(${test_result})
  message(FATAL_ERROR "test failed")
endif()
