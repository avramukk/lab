#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AWS::aws-c-sdkutils" for configuration "Release"
set_property(TARGET AWS::aws-c-sdkutils APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(AWS::aws-c-sdkutils PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaws-c-sdkutils.1.0.0.dylib"
  IMPORTED_SONAME_RELEASE "/nix/store/j4l24bbpd540shn6gkh81ap5bqkizcy9-aws-c-sdkutils-0.1.16/lib/libaws-c-sdkutils.1.0.0.dylib"
  )

list(APPEND _cmake_import_check_targets AWS::aws-c-sdkutils )
list(APPEND _cmake_import_check_files_for_AWS::aws-c-sdkutils "${_IMPORT_PREFIX}/lib/libaws-c-sdkutils.1.0.0.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
