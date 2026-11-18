import os
import struct

SRC_DDS = r"C:\Users\ssste\Downloads\superevent_image.dds"
DST_DDS = r"c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\superevents\bern_presidency_superevent.dds"
BACKUP_DDS = r"c:\Users\ssste\Desktop\The fire rises Bernkastel USA\gfx\superevents\bern_presidency_superevent_tv_original.dds"

TARGET_W = 556
TARGET_H = 320

def make_uncompressed_bgra8_dds_header(width, height):
    header = bytearray(128)
    header[0:4] = b"DDS "
    struct.pack_into("<IIIIIII", header, 4, 124, 0x0002100F, height, width, width * 4, 0, 1)
    struct.pack_into("<IIIIIIII", header, 76, 32, 0x00000041, 0, 32, 0x00FF0000, 0x0000FF00, 0x000000FF, 0xFF000000)
    struct.pack_into("<I", header, 108, 0x1000)
    return header

def unpack_rgb565(c):
    r = ((c >> 11) & 0x1F) * 255 // 31
    g = ((c >> 5) & 0x3F) * 255 // 63
    b = (c & 0x1F) * 255 // 31
    return (b, g, r, 255)

def decompress_dxt1(raw_data, width, height):
    out_bgra = bytearray(width * height * 4)
    block_idx = 0
    for by in range(0, height, 4):
        for bx in range(0, width, 4):
            offset = block_idx * 8
            if offset + 8 > len(raw_data):
                break
            c0, c1 = struct.unpack('<HH', raw_data[offset:offset+4])
            b0, g0, r0, a0 = unpack_rgb565(c0)
            b1, g1, r1, a1 = unpack_rgb565(c1)
            colors = [(b0, g0, r0, a0), (b1, g1, r1, a1)]
            if c0 > c1:
                colors.append(((2*b0 + b1)//3, (2*g0 + g1)//3, (2*r0 + r1)//3, 255))
                colors.append(((b0 + 2*b1)//3, (g0 + 2*g1)//3, (r0 + 2*r1)//3, 255))
            else:
                colors.append(((b0 + b1)//2, (g0 + g1)//2, (r0 + r1)//2, 255))
                colors.append((0, 0, 0, 0))

            lut = struct.unpack('<I', raw_data[offset+4:offset+8])[0]
            for py in range(4):
                y = by + py
                if y >= height:
                    continue
                for px in range(4):
                    x = bx + px
                    if x >= width:
                        continue
                    shift = (py * 4 + px) * 2
                    ci = (lut >> shift) & 0x3
                    c = colors[ci]
                    out_idx = (y * width + x) * 4
                    out_bgra[out_idx:out_idx+4] = bytes(c)
            block_idx += 1
    return out_bgra

with open(SRC_DDS, "rb") as f:
    raw = f.read()

# Backup original DXT1
with open(BACKUP_DDS, "wb") as f:
    f.write(raw)

bgra = decompress_dxt1(raw[128:], TARGET_W, TARGET_H)
hdr = make_uncompressed_bgra8_dds_header(TARGET_W, TARGET_H)
uncompressed_dds = hdr + bgra

with open(DST_DDS, "wb") as f:
    f.write(uncompressed_dds)

print(f"[OK] Restored TV superevent to {DST_DDS} ({len(uncompressed_dds)} bytes, {TARGET_W}x{TARGET_H} uncompressed BGRA8 DDS)")
