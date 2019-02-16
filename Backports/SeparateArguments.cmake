include_guard(GLOBAL)
include(FunctionExtension)

if(CMAKE_VERSION VERSION_LESS 3.9.6)
  macro(previous_separate_arguments arg policy)
    if(NOT previous_separate_arguments_fn)
      set(previous_separate_arguments_fn separate_arguments)
    endif()

    push(previous_separate_arguments_fn)
    set(previous_separate_arguments_fn _${previous_separate_arguments_fn})
    string(REGEX REPLACE "\"" "" argn_string "${ARGN}")
    call(${previous_separate_arguments_fn} ${arg} ${policy} "\"${argn_string}\"")
    pop(previous_separate_arguments_fn)
  endmacro()

  backup(separate_arguments)

  function(separate_arguments var policy args)
    if (policy STREQUAL "NATIVE_COMMAND")
      if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        previous_separate_arguments(${var} WINDOWS_COMMAND "${args}")
      else()
        previous_separate_arguments(${var} UNIX_COMMAND "${args}")
      endif()
    else()
      previous_separate_arguments(${var} ${policy} "${args}")
    endif()
  endfunction()
endif()

install(FILES
  ${CMAKE_CURRENT_LIST_DIR}/SeparateArguments.cmake
  DESTINATION share/cmake/shacl/.cmake/Backports)
