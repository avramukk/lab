#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AWS::aws-c-compression" for configuration "Release"
set_property(TARGET AWS::aws-c-compression APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(AWS::aws-c-compression PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaws-c-compression.1.0.0.dylib"
  IMPORTED_SONAME_RELEASE "/nix/store/xjz0ywafbzh3vapmp86vqr90jlsfnl48-aws-c-compression-0.2.18/lib/libaws-c-compression.1.0.0.dylib"
  )

list(APPEND _cmake_import_check_targets AWS::aws-c-compression )
list(APPEND _cmake_import_check_files_for_AWS::aws-c-compression "${_IMPORT_PREFIX}/lib/libaws-c-compression.1.0.0.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
