if (NOT IS_DIRECTORY ${CMAKE_BINARY_DIR}/etc/catkin/profile.d)
  file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/etc/catkin/profile.d)
endif()

function(catkin_add_env_hooks_impl BUILDSPACE INSTALLSPACE)

  assert_file_exists(${CMAKE_CURRENT_SOURCE_DIR}/${BUILDSPACE}.in
    "User-supplied environment file (buildspace) missing")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${BUILDSPACE}.in
    ${CMAKE_BINARY_DIR}/etc/catkin/profile.d/${BUILDSPACE}
    )

  assert_file_exists(${CMAKE_CURRENT_SOURCE_DIR}/${INSTALLSPACE}.in
    "User-supplied environment file (installable) missing")

  configure_file(${CMAKE_CURRENT_SOURCE_DIR}/${INSTALLSPACE}.in
    ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${INSTALLSPACE}
    )

  install(FILES ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${INSTALLSPACE}
    DESTINATION
    etc/catkin/profile.d)

endfunction()

function(catkin_add_env_hooks ARG_PATH)

  parse_arguments(ARG
    "SHELLS;EXTRAS" ""
    ${ARGN})

  foreach(shell ${ARG_SHELLS})
    catkin_add_env_hooks_impl(
      ${ARG_PATH}.buildspace.${shell}
      ${ARG_PATH}.${shell}
      )
  endforeach()

endfunction()


function(catkin_generic_hooks)
  foreach(shell sh bash zsh)
    configure_file(${catkin_EXTRAS_DIR}/templates/setup.${shell}.buildspace.in
      ${CMAKE_BINARY_DIR}/setup.${shell})

    configure_file(${catkin_EXTRAS_DIR}/templates/setup.${shell}.installable.in
      ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/setup.${shell})

    configure_file(${catkin_EXTRAS_DIR}/templates/env.sh.installable.in
      ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/env.sh)

    install(FILES
      ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/setup.${shell}
      DESTINATION ${CMAKE_INSTALL_PREFIX}
      )
  endforeach()

  configure_file(${catkin_EXTRAS_DIR}/templates/env.sh.buildspace.in
    ${CMAKE_BINARY_DIR}/env.sh)

  install(PROGRAMS
    ${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/env.sh
    DESTINATION ${CMAKE_INSTALL_PREFIX}
    )

endfunction()