from PIL import Image
from os import listdir, get_terminal_size

START = 1
TOTAL = len(listdir("imgs"))
terminal_width = get_terminal_size().columns


result = []

chex = lambda x: hex(x).replace("0x", "\\x")

width, height = 0, 0

BASE_LENGTH = terminal_width - len(f"Progress:[] {TOTAL}/{TOTAL}") - 5

for i in range(TOTAL):
    img = Image.open(f"imgs/frame_{i + START}.jpg").convert("RGB")

    width, height = img.size
    result.append(f"const char * frame{i}[] = " + "{\n")

    for y in range(height):
        result[i] += "\""
        for x in range(width):
            r, g, b = img.getpixel((x, y))
            result[i] += f"{chex(r)}{chex(g)}{chex(b)}"
        result[i] += "\"};\n" if y == height - 1 else "\",\n"
    progress = int(BASE_LENGTH * (i + 1) / TOTAL)
    print(f"Progress:[{'=' * progress}{'-' * (BASE_LENGTH - progress)}] {i + 1}/{TOTAL}", end="\r")
print("")

with open("frames.c", "w") as frame_file:
    frame_file.write(f"#define FRAME_COUNT {TOTAL}\n")
    frame_file.write(f"#define FRAME_WIDTH {width}\n")
    frame_file.write(f"#define FRAME_HEIGHT {height}\n\n")

    frame_file.write("\n".join(result))

    frame_file.write("\n")
    frame_file.write("const char ** frames[] = {\n")
    for i in range(TOTAL - 1):
        frame_file.write(f"    frame{i},\n")
    frame_file.write(f"    frame{TOTAL - 1}\n" + "};")
