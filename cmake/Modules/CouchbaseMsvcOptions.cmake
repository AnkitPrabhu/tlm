SET(CB_MSVC_DEBUG "")
SET(CB_MSVC_WARNINGS "")
SET(CB_MSVC_VISIBILITY "")
SET(CB_MSVC_THREAD "")

IF ("${ENABLE_WERROR}" STREQUAL "YES")
   SET(CB_MSVC_WERROR "")
ENDIF()

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CB_MSVC_DEBUG} ${CB_MSVC_WARNINGS} ${CB_MSVC_VISIBILITY} ${CB_MSVC_THREAD} ${CB_MSVC_WERROR}")
SET(CMAKE_LINK_FLAGS "${CMAKE_LINK_FLAGS} ${CB_MSVC_LDFLAGS}")

ADD_DEFINITIONS(-D_CRT_SECURE_NO_WARNINGS=1)
ADD_DEFINITIONS(-D_CRT_NONSTDC_NO_DEPRECATE)

INCLUDE_DIRECTORIES(AFTER ${CMAKE_SOURCE_DIR}/platform/include/win32)

IF (MSVC_VERSION LESS 1800)
   MESSAGE(FATAL_ERROR "You need MSVC 2013 or newer")
ENDIF (MSVC_VERSION LESS 1800)
