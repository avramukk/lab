#----------------------------------------------------------------
# Generated CMake target import file for configuration "Release".
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "AWS::aws-c-event-stream" for configuration "Release"
set_property(TARGET AWS::aws-c-event-stream APPEND PROPERTY IMPORTED_CONFIGURATIONS RELEASE)
set_target_properties(AWS::aws-c-event-stream PROPERTIES
  IMPORTED_LOCATION_RELEASE "${_IMPORT_PREFIX}/lib/libaws-c-event-stream.1.0.0.dylib"
  IMPORTED_SONAME_RELEASE "/nix/store/na6i3zqb3ibphzzv8vhi86dl0n1s91b9-aws-c-event-stream-0.4.2/lib/libaws-c-event-stream.1.0.0.dylib"
  )

list(APPEND _cmake_import_check_targets AWS::aws-c-event-stream )
list(APPEND _cmake_import_check_files_for_AWS::aws-c-event-stream "${_IMPORT_PREFIX}/lib/libaws-c-event-stream.1.0.0.dylib" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
