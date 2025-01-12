# - Find PostgreSQL
# Find the PostgreSQL installation by utilizing pg_config
# This module defines
#  POSTGRESQL_INCLUDE_DIR, the directories of the PostgreSQL headers
#  POSTGRESQL_LIBRARY_DIR, the link directories for PostgreSQL libraries
#  POSTGRESQL_FOUND, True if PostgreSQL is found
#  POSTGRESQL_VERSION_STRING, the version of PostgreSQL found
#
# This module defines :prop_tgt:`IMPORTED` target ``PostgreSQL::PostgreSQL``
# if PostgreSQL has been found.

set(POSTGRESQL_BIN
    ""
    CACHE STRING "non-standard path to the postgresql program executables")

if(NOT "${POSTGRESQL_BIN}" STREQUAL "")
  find_program(POSTGRESQL_PG_CONFIG
               NAMES pg_config
               PATHS ${POSTGRESQL_BIN}
               NO_DEFAULT_PATH)
else()
  find_program(POSTGRESQL_PG_CONFIG
               NAMES pg_config
               PATHS /usr/lib/postgresql/*/bin/)
endif()

message(STATUS "POSTGRESQL_PG_CONFIG is " ${POSTGRESQL_PG_CONFIG})
if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --bindir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE T_POSTGRESQL_BIN)
endif()

# search for POSTGRESQL_EXECUTABLE _only_ in the dir specified by pg_config
find_program(POSTGRESQL_EXECUTABLE
             NAMES postgres
             PATHS ${T_POSTGRESQL_BIN}
             NO_DEFAULT_PATH)
message(STATUS "POSTGRESQL_EXECUTABLE is " ${POSTGRESQL_EXECUTABLE})

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --version
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_VERSION_STRING)
endif()
message(STATUS "POSTGRESQL_VERSION_STRING in FindPostgreSQL.cmake is "
               ${POSTGRESQL_VERSION_STRING})

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --includedir-server
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_INCLUDE_DIR)
endif(POSTGRESQL_PG_CONFIG)

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --libdir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_LIBRARY_DIR)
endif()

if(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARY_DIR)
  set(POSTGRESQL_FOUND TRUE)
  message(STATUS "POSTGRESQL_INCLUDE_DIR: ${POSTGRESQL_INCLUDE_DIR}")
  message(STATUS "POSTGRESQL_LIBRARY_DIR: ${POSTGRESQL_LIBRARY_DIR}")
  add_library(PostgreSQL::PostgreSQL UNKNOWN IMPORTED)
  set_target_properties(PostgreSQL::PostgreSQL
                        PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${POSTGRESQL_INCLUDE_DIR}
                                   INTERFACE_INCLUDE_DIRECTORIES
                                   ${POSTGRESQL_LIBRARY_DIR})
else()
  set(POSTGRESQL_FOUND FALSE)
  message(STATUS "PostgreSQL not found.")
endif()

mark_as_advanced(POSTGRESQL_INCLUDE_DIR POSTGRESQL_LIBRARY_DIR)
