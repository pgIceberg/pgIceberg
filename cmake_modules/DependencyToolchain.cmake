# ----------------------------------------------------------------------
# FetchContent

include(FetchContent)
set(FC_DECLARE_COMMON_OPTIONS)
if(CMAKE_VERSION VERSION_GREATER_EQUAL 3.28)
  list(APPEND FC_DECLARE_COMMON_OPTIONS EXCLUDE_FROM_ALL TRUE)
endif()

macro(prepare_fetchcontent)
  set(BUILD_SHARED_LIBS OFF)
  set(BUILD_STATIC_LIBS ON)
  set(CMAKE_COMPILE_WARNING_AS_ERROR FALSE)
  set(CMAKE_EXPORT_NO_PACKAGE_REGISTRY TRUE)
  set(CMAKE_POSITION_INDEPENDENT_CODE ON)
endmacro()

# ----------------------------------------------------------------------
# Apache Iceberg C++

function(resolve_iceberg_dependency)
  prepare_fetchcontent()

  set(ICEBERG_ARROW
      ON
      CACHE BOOL "" FORCE)
  set(ICEBERG_BUILD_TESTS
      OFF
      CACHE BOOL "" FORCE)

  fetchcontent_declare(Iceberg
                       GIT_REPOSITORY https://github.com/apache/iceberg-cpp.git
                       GIT_TAG 9a044687a78bbf9c2c6c29ff6a30f91b645d4cfd)
  fetchcontent_makeavailable(Iceberg)
endfunction()

resolve_iceberg_dependency()
