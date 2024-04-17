from PIL import Image

START = 1
TOTAL = 22


result = []

chex = lambda x: hex(x).replace("0x", "\\x")

width, height = 0, 0

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
