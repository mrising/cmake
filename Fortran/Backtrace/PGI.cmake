string(CONCAT generator
  "$<$<STREQUAL:PGI,${CMAKE_Fortran_COMPILER_ID}>"
   ":$<IF:$<BOOL:$<TARGET_PROPERTY:Fortran_BACKTRACE>>"
        ",-traceback;"
        ",-notraceback;"
     ">"
   ">")

target_compile_options(Fortran_Backtrace INTERFACE ${generator})
