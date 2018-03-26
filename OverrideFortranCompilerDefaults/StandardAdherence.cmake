include(Backports/IncludeGuard)
include_guard(GLOBAL)

# Standard-semantics options for Intel

string(CONCAT generator
  "$<$<STREQUAL:Intel,${CMAKE_Fortran_COMPILER_ID}>:"
      "$<$<NOT:$<PLATFORM_ID:Windows>>:-standard-semantics;-assume;nostd_mod_proc_name>"
          "$<$<PLATFORM_ID:Windows>:/standard-semantics;/assume:nostd_mod_proc_name>>")

add_library(standard_semantics INTERFACE)
add_library(ofcd::standard_semantics ALIAS standard_semantics)
target_compile_options(standard_semantics INTERFACE
  ${generator}
)

