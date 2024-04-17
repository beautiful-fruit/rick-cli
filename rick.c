#include <signal.h>
#include <stdio.h>
#include <unistd.h>

#include <sys/ioctl.h>

#ifndef TIOCGWINSZ
#include <termios.h>
#endif

#include "frames.c"

int max_row, min_row, max_col, min_col;

void newline(int n) {
    int i = 0;
    for (i = 0; i < n; ++i) {
        /* We will send `n` linefeeds to the client */
        /* Send a regular line feed */
        putc('\n', stdout);
    }
}

void update_size() {
    struct winsize w;
    ioctl(0, TIOCGWINSZ, &w);
    int terminal_width = w.ws_col;
    int terminal_height = w.ws_row;

    min_col = (FRAME_WIDTH - terminal_width / 2) / 2;
    if (min_col < 0)
        min_col = 0;
    max_col = FRAME_WIDTH + (terminal_width / 2 - FRAME_WIDTH) / 2;
    if (max_col >= FRAME_WIDTH)
        max_col = FRAME_WIDTH - 1;

    min_row = (FRAME_HEIGHT - (terminal_height - 1)) / 2;
    if (min_row < 0)
        min_row = 0;
    max_row = (FRAME_HEIGHT + (terminal_height - 1)) / 2;
    if (max_row >= FRAME_HEIGHT)
        max_col = FRAME_HEIGHT - 1;
}

int main() {
    signal(SIGINT, SIG_IGN);

    const char *output = "  ";
    const int delay_ms = 80;

    char r, g, b;
    int x, y, i, last;

    update_size();

    while (1) {
        /* Reset cursor */
        printf("\033[m\033[H");
        for (y = min_row; y < max_row; ++y) {
            for (x = min_col; x < max_col; ++x) {
                r = frames[i][y][x * 3 + 0];
                g = frames[i][y][x * 3 + 1];
                b = frames[i][y][x * 3 + 2];
                // printf("%d,%d %hhu %hhu %hhu\n", x, y, r, g, b);
                // getchar();

                int color = b;
                color += g << 8;
                color += r << 16;

                if (color != last) {
                    printf("\033[48;2;%hhu;%hhu;%hhum%s", r, g, b, output);
                } else {
                    /* Same color, just send the output characters */
                    printf("%s", output);
                }
            }
            /* End of row, send newline */
            newline(1);
        }

        /* Reset the last color so that the escape sequences rewrite */
        last = 0;

        if (++i == FRAME_COUNT) {
            /* Loop animation */
            i = 0;
        }
        update_size();
        /* Wait */
        usleep(1000 * delay_ms);
    }
}
