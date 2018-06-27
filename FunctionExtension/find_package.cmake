macro(previous_find_package)
  if(NOT previous_find_package_fn)
    set(previous_find_package_fn find_package)
    set(find_package_args "${ARGN}")
  elseif(NOT find_package_args STREQUAL "${ARGN}")
    set(previous_find_package_fn find_package)
    push(find_package_args)
    set(find_package_args "${ARGN}")
  endif()

  push(previous_find_package_fn)
  set(previous_find_package_fn _${previous_find_package_fn})
  call(${previous_find_package_fn} ${ARGN})
  pop(previous_find_package_fn)
  set(${package}_FOUND ${${package}_FOUND} PARENT_SCOPE)
endmacro()

function(wrap_find_package)
  backup(find_package)
  function(find_package package)
    previous_find_package(${ARGV})
    pop(find_package_args)
  endfunction()
endfunction()
