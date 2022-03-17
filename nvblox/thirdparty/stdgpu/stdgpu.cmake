# Exports: ${STDGPU_INCLUDE_DIRS}
# Exports: ${STDGPU_LIB_DIR}
# Exports: ${STDGPU_LIBRARIES}

include(ExternalProject)

if(NOT DEFINED STDGPU_INSTALL_DESTINATION)
    set(STDGPU_INSTALL_DESTINATION "<INSTALL_DIR>")
endif()

ExternalProject_Add(
    ext_stdgpu
    PREFIX stdgpu
    URL https://github.com/stotko/stdgpu/archive/refs/tags/1.3.0.tar.gz
    URL_HASH SHA256=c527dabc6735d8b320b316e9a5b120d258d49c2b7ff9689c8a9b5ad474532a05
    UPDATE_COMMAND ""
    CMAKE_ARGS
        -DCMAKE_INSTALL_PREFIX=${STDGPU_INSTALL_DESTINATION}
        -DSTDGPU_BUILD_SHARED_LIBS=ON
        -DSTDGPU_BUILD_EXAMPLES=OFF
        -DSTDGPU_BUILD_TESTS=OFF
        -DSTDGPU_ENABLE_CONTRACT_CHECKS=OFF
    BUILD_ALWAYS TRUE
    BUILD_BYPRODUCTS
        <INSTALL_DIR>/lib/${CMAKE_SHARED_LIBRARY_PREFIX}stdgpu${CMAKE_SHARED_LIBRARY_SUFFIX}
)



ExternalProject_Get_Property(ext_stdgpu INSTALL_DIR)

if(STDGPU_INSTALL_DESTINATION STREQUAL "<INSTALL_DIR>")
    set(STDGPU_INSTALL_DESTINATION ${INSTALL_DIR})
endif()

set(STDGPU_INCLUDE_DIRS ${STDGPU_INSTALL_DESTINATION}/include/) # "/" is critical.
set(STDGPU_LIB_DIR ${STDGPU_INSTALL_DESTINATION}/lib)
set(STDGPU_LIBRARIES stdgpu)

add_library(stdgpu SHARED IMPORTED)
add_dependencies(stdgpu ext_stdgpu)
set_target_properties(stdgpu PROPERTIES IMPORTED_LOCATION ${STDGPU_LIB_DIR}/${CMAKE_SHARED_LIBRARY_PREFIX}stdgpu${CMAKE_SHARED_LIBRARY_SUFFIX})