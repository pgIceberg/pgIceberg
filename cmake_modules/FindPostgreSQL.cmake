# - Find PostgreSQL
# Find the PostgreSQL installation by utilizing pg_config
# This module defines
#  POSTGRESQL_FOUND, True if PostgreSQL is found
#  POSTGRESQL_VERSION_STRING, the version of PostgreSQL found
#  POSTGRESQL_INCLUDE_DIR, the directory of the PostgreSQL headers
#  POSTGRESQL_LIBRARY_DIR, the link directory for PostgreSQL libraries
#  POSTGRESQL_BIN_DIR, the directory of the PostgreSQL binaries
#  POSTGRESQL_SHARE_DIR, the directory of PostgreSQL share objects
#  POSTGRESQL_REGRESS, pg_regress executable
#
# This module defines :prop_tgt:`IMPORTED` target ``PostgreSQL::PostgreSQL``
# if PostgreSQL has been found.

set(POSTGRESQL_BIN_DIR
    ""
    CACHE STRING "non-standard path to the postgresql program executables")

if(NOT "${POSTGRESQL_BIN_DIR}" STREQUAL "")
  find_program(POSTGRESQL_PG_CONFIG
               NAMES pg_config
               PATHS ${POSTGRESQL_BIN_DIR}
               NO_DEFAULT_PATH)
else()
  find_program(POSTGRESQL_PG_CONFIG
               NAMES pg_config
               PATHS /usr/lib/postgresql/*/bin/)
endif()
message(STATUS "POSTGRESQL_PG_CONFIG: ${POSTGRESQL_PG_CONFIG}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --version
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_VERSION_STRING)
endif()
message(STATUS "POSTGRESQL_VERSION_STRING: ${POSTGRESQL_VERSION_STRING}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --includedir-server
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_INCLUDE_DIR)
endif()
message(STATUS "POSTGRESQL_INCLUDE_DIR: ${POSTGRESQL_INCLUDE_DIR}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --libdir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_LIBRARY_DIR)
endif()
message(STATUS "POSTGRESQL_LIBRARY_DIR: ${POSTGRESQL_LIBRARY_DIR}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --sharedir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_SHARE_DIR)
endif()
message(STATUS "POSTGRESQL_SHARE_DIR: ${POSTGRESQL_SHARE_DIR}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --pkglibdir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE T_POSTGRESQL_PKGLIB_DIR)
endif()

find_program(POSTGRESQL_REGRESS
             NAMES pg_regress
             PATHS ${T_POSTGRESQL_PKGLIB_DIR}/pgxs/src/test/regress
             NO_DEFAULT_PATH)
message(STATUS "POSTGRESQL_REGRESS: ${POSTGRESQL_REGRESS}")

if(POSTGRESQL_PG_CONFIG)
  execute_process(COMMAND ${POSTGRESQL_PG_CONFIG} --bindir
                  OUTPUT_STRIP_TRAILING_WHITESPACE
                  OUTPUT_VARIABLE POSTGRESQL_BIN_DIR)
endif()
message(STATUS "POSTGRESQL_BIN_DIR: ${POSTGRESQL_BIN_DIR}")

if(POSTGRESQL_INCLUDE_DIR AND POSTGRESQL_LIBRARY_DIR)
  set(POSTGRESQL_FOUND TRUE)
  add_library(PostgreSQL::PostgreSQL UNKNOWN IMPORTED)
  set_target_properties(PostgreSQL::PostgreSQL
                        PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${POSTGRESQL_INCLUDE_DIR}
                                   INTERFACE_INCLUDE_DIRECTORIES
                                   ${POSTGRESQL_LIBRARY_DIR})
  message(STATUS "PostgreSQL found.")
else()
  set(POSTGRESQL_FOUND FALSE)
  message(STATUS "PostgreSQL not found.")
endif()

mark_as_advanced(POSTGRESQL_INCLUDE_DIR POSTGRESQL_LIBRARY_DIR)
