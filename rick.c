#include <signal.h>
#include <stdio.h>

#ifdef _WIN32

#include <windows.h>
// https://stackoverflow.com/questions/5801813/c-usleep-is-obsolete-workarounds-for-windows-mingw
void usleep(__int64 usec) {
    HANDLE timer;
    LARGE_INTEGER ft;

    ft.QuadPart = -(10 * usec); // Convert to 100 nanosecond interval, negative
                                // value indicates relative time

    timer = CreateWaitableTimer(NULL, TRUE, NULL);
    SetWaitableTimer(timer, &ft, 0, NULL, NULL, 0);
    WaitForSingleObject(timer, INFINITE);
    CloseHandle(timer);
}

#else

#include <sys/ioctl.h>
#include <unistd.h>

#ifndef TIOCGWINSZ
#include <termios.h>
#endif

#endif

#include "frames.c"

int max_row, min_row, max_col, min_col, raw_terminal_width, terminal_height;

void update_size() {
#ifdef _WIN32
    CONSOLE_SCREEN_BUFFER_INFO csbi;
    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), &csbi);

    raw_terminal_width = (csbi.srWindow.Right - csbi.srWindow.Left + 1);
    int terminal_width = raw_terminal_width / 2;
    terminal_height = csbi.srWindow.Bottom - csbi.srWindow.Top;
#else
    struct winsize w;
    ioctl(0, TIOCGWINSZ, &w);
    raw_terminal_width = w.ws_col;
    int terminal_width = raw_terminal_width / 2;
    terminal_height = w.ws_row - 1;
#endif

    min_col = (FRAME_WIDTH - terminal_width) / 2;
    max_col = FRAME_WIDTH - min_col - 1;

    min_row = (FRAME_HEIGHT - terminal_height) / 2;
    max_row = FRAME_HEIGHT - min_row;
}

int main() {
    signal(SIGINT, SIG_IGN);

    const char *output = "  ";
    const int delay_ms = 80;

    char r, g, b;
    int x, y, i = 0, last;

    update_size();

    while (1) {
        /* Reset cursor */
        // printf("\033[m\033[H");
        last = -1;
        for (y = min_row; y < max_row; ++y) {
            if (y - min_row >= terminal_height)
                break;
            ;
            int output_count = 0;
            for (x = min_col; x < max_col; ++x) {
                if (output_count >= raw_terminal_width)
                    break;
                if (x < 0 || x >= FRAME_WIDTH || y < 0 || y >= FRAME_HEIGHT) {
                    if (last != -1) {
                        printf("\033[m%s", output);
                        last = -1;
                    } else {
                        printf("%s", output);
                    }
                    output_count += 2;
                    continue;
                }

                r = frames[i][y][x * 3 + 0];
                g = frames[i][y][x * 3 + 1];
                b = frames[i][y][x * 3 + 2];

                int color = b;
                color += g << 8;
                color += r << 16;

                if (color != last) {
                    printf("\033[48;2;%hhu;%hhu;%hhum%s", r, g, b, output);
                    last = color;
                } else {
                    printf("%s", output);
                }
                output_count += 2;
            }
            while (output_count < raw_terminal_width) {
                putc(' ', stdout);
                ++output_count;
            }
            putc('\n', stdout);
        }

        if (++i == FRAME_COUNT) {
            i = 0;
        }
        update_size();
        usleep(1000 * delay_ms);
    }
}
