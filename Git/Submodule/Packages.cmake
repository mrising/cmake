# Here we're using the existance of global properties to act as something
# analoguous to C/C++ header guards to ensure the contents of this file are not
# redundantly defined.

get_property(
  git.submodule.packages.cmake
  GLOBAL PROPERTY git.submodule.packages.cmake SET)

if(NOT git.submodule.packages.cmake)
  include(CMakeDependentOption)
  include(CMakeDependentCacheVar)
  include(CMakeDependentSelection)

  #
  # This package supports the use of a file to reproduce previous
  # configurations. We refer to these as specification files.
  #
  # Options in this cmake module are written in such a way that they
  # will not override values specified at the command line or through
  # a specification file.
  #
  set(git.submodule.packages.specification "" CACHE FILEPATH
    "Path to consumed git submodule packages specification file")

  if(git.submodule.packages.specification)
    if(NOT EXISTS git.submodule.packages.specification)
      message("git.submodule.packages.specification variable defined")
      message("specification file path: ${git.submodule.packages.specification}")
      message(FATAL_ERROR "No file exists at this path")
    endif()

    include("${git.submodule.packages.specification}")
  endif()

  #
  # This option is intended to allow an end user to opt-out of the use of git
  # submodule packages by toggling this option.
  #
  # Here we use 'end user' to mean the person invoking CMake, rather than a
  # project including this module.
  #
  option(git.submodule.packages "Enable git submodule package support" ON)

  CMAKE_DEPENDENT_OPTION(git.submodule.packages.eager
    "find_package will prefer to consume dependencies via submodules when available"
    ON "git.submodule.packages" OFF)

  CMAKE_DEPENDENT_OPTION(git.submodule.packages.update
    "Update to head of branch-tracking submodules on first configuration"
    ON "git.submodule.packages" OFF)

  mark_as_advanced(git.submodule.packages.update)

  CMAKE_DEPENDENT_CACHE_VAR(git.submodule.packages.cache
    PATH
    "Location for git submodule packages directory clones"
    "${CMAKE_BINARY_DIR}/git-submodule-packages"
    "git.submodule.packages" "")

  mark_as_advanced(git.submodule.packages.cache)

  CMAKE_DEPENDENT_CACHE_VAR(git.submodule.packages.specification.sink
    FILEPATH
    "Location for generated git submodule packages specification file"
    "${CMAKE_BINARY_DIR}/git-submodule-packages/specification.cmake"
    "git.submodule.packages" "")

  mark_as_advanced(git.submodule.packages.specification.sink)

  if(git.submodule.packages)
    #
    # We search for and require git iff git submodule packages are enabled.
    #
    find_package(Git REQUIRED)

    get_filename_component(
      git.submodule.packages.specification_dir
      "${git.submodule.packages.specification.sink}"
      DIRECTORY)

    file(MAKE_DIRECTORY
      "${git.submodule.packages.cache}"
      "${git.submodule.packages.specification_dir}")

    string(CONCAT content
      "option(git.submodule.packages\n"
      "  \"Enable git submodule support for CMake find_package\" ON)\n"
      "\n")

    file(WRITE "${git.submodule.packages.specification.sink}" "${content}")
  endif()

  include(FunctionExtension)
  include(GeneratedSources/ListBinaryDir)

  include(Git/Submodule/Packages/list)
  include(Git/Submodule/Packages/init)
  include(Git/Submodule/Packages/update)
  include(Git/Submodule/Packages/package)
  include(Git/Submodule/Packages/find_package)

  set_property(
    GLOBAL PROPERTY git.packages.cmake
    "This is a header guard")

  install(FILES "${CMAKE_CURRENT_LIST_DIR}/Packages.cmake"
    DESTINATION share/cmake/shacl/.cmake/Git/Submodule)

  install(DIRECTORY "${CMAKE_CURRENT_LIST_DIR}/Packages"
    DESTINATION share/cmake/shacl/.cmake/Git/Submodule)
endif()

git_submodule_list()
