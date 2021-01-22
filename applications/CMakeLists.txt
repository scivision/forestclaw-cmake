add_executable(dummy fclaw2d_dummy.c dummy_blackbox.c)
target_link_libraries(dummy PRIVATE forestclaw::forestclaw)
add_test(NAME forestclaw:dummy COMMAND $<TARGET_FILE:dummy>)
