#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <litehtml.h>
#include <X11/Xlib.h>

char* load_html_file(const char* path);
void show_window(const char* title, int width, int height);