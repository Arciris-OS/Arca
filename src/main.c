#include "window.h"

char* load_html_file(const char* path) {
    FILE* fp = fopen(path, "rb");
    if (!fp) return NULL;
    fseek(fp, 0, SEEK_END);
    long size = ftell(fp);
    rewind(fp);
    char* buf = (char*)malloc(size + 1);
    if (!buf) { fclose(fp); return NULL; }
    fread(buf, 1, size, fp);
    buf[size] = '\0';
    fclose(fp);
    return buf;
}

char* set_app_title(const char* html, const char* title) {
    const char* marker = "<div class=\"app-title\">";
    char* pos = strstr(html, marker);
    if (!pos) return strdup(html);

    size_t before_len = pos - html + strlen(marker);
    const char* after = strstr(pos, "</div>");
    if (!after) return strdup(html);

    after += strlen("</div>");
    size_t after_offset = after - html;

    size_t new_html_len = before_len + strlen(title) + strlen(html) - (after_offset - before_len) + 1;
    char* new_html = (char*)malloc(new_html_len);
    if (!new_html) return NULL;

    memcpy(new_html, html, before_len);
    strcpy(new_html + before_len, title);
    strcat(new_html, html + after_offset);
    return new_html;
}

void show_window(const char* title, int width, int height) {
    Display* dpy = XOpenDisplay(NULL);
    if (!dpy) {
        fprintf(stderr, "XOpenDisplay failed\n");
        return;
    }
    int screen = DefaultScreen(dpy);
    Window win = XCreateSimpleWindow(dpy, RootWindow(dpy, screen), 100, 100, width, height, 1,
                                     BlackPixel(dpy, screen), WhitePixel(dpy, screen));
    XStoreName(dpy, win, title);
    XSelectInput(dpy, win, ExposureMask | KeyPressMask);
    XMapWindow(dpy, win);

    char* html = load_html_file("desgin/window.html");
    if (!html) {
        fprintf(stderr, "HTMLファイル読み込み失敗\n");
        XDestroyWindow(dpy, win);
        XCloseDisplay(dpy);
        return;
    }

    char* html_with_title = set_app_title(html, title);
    free(html);

    litehtml::context ctx;
    std::shared_ptr<litehtml::document> doc = ctx.create_document(html_with_title, nullptr, nullptr);
    free(html_with_title);

    XEvent ev;
    int running = 1;
    while (running) {
        XNextEvent(dpy, &ev);
        if (ev.type == Expose) {
            XClearWindow(dpy, win);
            if (doc) {
                std::string doc_title = doc->title();
                XDrawString(dpy, win, DefaultGC(dpy, screen), 50, 50, doc_title.c_str(), doc_title.length());
            }
        } else if (ev.type == KeyPress) {
            running = 0;
        }
    }

    XDestroyWindow(dpy, win);
    XCloseDisplay(dpy);
}

int main() {
    show_window("Arca Window(w)", 800, 600);
    return 0;
}