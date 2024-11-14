include(GNUInstallDirs)
include(CheckSourceCompiles)

check_source_compiles(Fortran
"
program a
use, intrinsic :: ieee_arithmetic, only : ieee_next_after
implicit none
print *, ieee_next_after(0.,0.)
end program
"
f03ieee
)


check_source_compiles(Fortran
[=[
program a
implicit none

complex :: x

print *, x%RE, x%IM
end program
]=]
f08prop
)

if(NOT f08prop)
  message(FATAL_ERROR "${CMAKE_Fortran_COMPILER_ID} does not have Fortran 2008 %RE %IM real imaginary properties.")
endif()


check_source_compiles(Fortran
[=[
program a
implicit none

complex :: x

print *, acosh(x)
end program
]=]
f08hyper
)

if(NOT f08hyper)
  message(FATAL_ERROR "${CMAKE_Fortran_COMPILER_ID} does not have Fortran 2008 hyperbolic functions.")
endif()

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  add_compile_options(-fimplicit-none -Werror=line-truncation
  "$<$<CONFIG:Debug>:-fcheck=all;-fexceptions;-ffpe-trap=invalid,zero,overflow;-finit-real=nan;-Wconversion>"
  )
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "^Intel")
  add_compile_options(
  -traceback
  "$<$<CONFIG:Debug>:-warn;-fpe0>"
  )
endif()
