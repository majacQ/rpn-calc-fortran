
if(CMAKE_Fortran_COMPILER_ID STREQUAL GNU)
  list(APPEND FFLAGS -march=native -fimplicit-none)
  #-Wall #-Wextra #-Wpedantic  -Warray-temporaries -Werror=array-bounds

  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -fcheck=all -fexceptions -ffpe-trap=invalid,zero,overflow -finit-real=nan -Wconversion)
  endif()

  if (UNIX AND NOT APPLE)
    list(APPEND FFLAGS -fstack-protector-all)
  endif()

  #if(CMAKE_Fortran_COMPILER_VERSION VERSION_GREATER_EQUAL 8)
  #  list(APPEND FFLAGS -std=f2018)
  #endif()

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Intel)

  if(CMAKE_BUILD_TYPE STREQUAL Debug)
    list(APPEND FFLAGS -warn -fpe0 -traceback)# -debug extended -check all)
  endif()

  if(WIN32)
    list(APPEND FFLAGS /4Yd)# /stand:f18)
  else()
    list(APPEND -implicitnone)# -stand f18)
  endif()
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL Flang)

elseif(CMAKE_Fortran_COMPILER_ID STREQUAL PGI)

endif()

include(CheckFortranSourceCompiles)

check_fortran_source_compiles("use, intrinsic:: ieee_arithmetic; end"
  f08ieee SRC_EXT f90)

if(NOT f08ieee)
  message(FATAL_ERROR "IEEE_arithmetic not supported by your compiler")
endif()

check_fortran_source_compiles("print *,atanh((1.,1.)); end" f08hyper SRC_EXT f90)
