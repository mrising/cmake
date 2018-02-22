string(CONCAT generator
  "$<$<STREQUAL:${CMAKE_Fortran_COMPILER_ID},Intel>"
    ":$<$<NOT:$<PLATFORM_ID:Windows>>"
       ":$<$<BOOL:${FortranTypes.integer.32}>:-integer-size;32>;"
        "$<$<BOOL:${FortranTypes.integer.64}>:-integer-size;64>>;"
     "$<$<PLATFORM_ID:Windows>"
       ":$<$<BOOL:${FortranTypes.integer.32}>:/integer-size:32>;"
        "$<$<BOOL:${FortranTypes.integer.64}>:/integer-size:64>>>")

target_compile_options(Fortran_Integer_Fortran INTERFACE ${generator})

target_compile_definitions(Fortran_Integer_C INTERFACE
  $<$<NOT:$<OR:$<BOOL:${FortranTypes.integer.64}>,
               $<BOOL:${FortranTypes.integer.32}>>>:F90_INT_4BYTE>)

unset(generator)
