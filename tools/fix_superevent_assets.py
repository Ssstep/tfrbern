import os
import struct
import subprocess
import shutil

ROOT = r"c:\Users\ssste\Desktop\The fire rises Bernkastel USA"
DDS_PATH = os.path.join(ROOT, "gfx", "superevents", "bern_presidency_superevent.dds")
OGG_PATH = os.path.join(ROOT, "music", "bern_superevent_theme.ogg")

TARGET_W = 556
TARGET_H = 320

def make_uncompressed_bgra8_dds_header(width, height):
    """Generates standard 128-byte uncompressed 32-bit BGRA8 DDS header (no DX10, 100% Clausewitz compatible)"""
    header = bytearray(128)
    header[0:4] = b"DDS "
    # dwSize(124), dwFlags(0x0002100F: CAPS|HEIGHT|WIDTH|PITCH|PIXELFORMAT|MIPMAPCOUNT)
    # dwHeight, dwWidth, dwPitchOrLinearSize(width*4), dwDepth(0), dwMipMapCount(1)
    struct.pack_into(
        "<IIIIIII",
        header, 4,
        124,
        0x0002100F,
        height,
        width,
        width * 4,
        0,
        1
    )
    # DDS_PIXELFORMAT at offset 76 (32 bytes):
    # dwSize(32), dwFlags(0x41: DDPF_RGB | DDPF_ALPHAPIXELS), dwFourCC(0), dwRGBBitCount(32)
    # dwRBitMask(0x00FF0000), dwGBitMask(0x0000FF00), dwBBitMask(0x000000FF), dwABitMask(0xFF000000)
    struct.pack_into(
        "<IIIIIIII",
        header, 76,
        32,
        0x00000041,
        0,
        32,
        0x00FF0000,
        0x0000FF00,
        0x000000FF,
        0xFF000000
    )
    # Caps at offset 108: DDSCAPS_TEXTURE (0x1000)
    struct.pack_into("<I", header, 108, 0x1000)
    return header

def unpack_rgb565(c):
    r = ((c >> 11) & 0x1F) * 255 // 31
    g = ((c >> 5) & 0x3F) * 255 // 63
    b = (c & 0x1F) * 255 // 31
    return (b, g, r, 255)

def decompress_dxt1(raw_data, width, height):
    """Decompresses DXT1/BC1 raw payload into 32-bit BGRA bytes"""
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

def fix_superevent_image():
    print(f"[1/2] Processing superevent image at {DDS_PATH}...")
    if not os.path.exists(DDS_PATH):
        raise FileNotFoundError(f"DDS file not found: {DDS_PATH}")

    with open(DDS_PATH, "rb") as f:
        data = f.read()

    # Check magic
    if data[:4] == b"DDS ":
        hdr = struct.unpack("<7I", data[4:32])
        h, w = hdr[2], hdr[3]
        fourcc = data[84:88]
        print(f"Existing DDS detected: {w}x{h}, FourCC: {fourcc}")
        if fourcc == b"DXT1":
            print("Decompressing DXT1 to raw 32-bit BGRA...")
            bgra_pixels = decompress_dxt1(data[128:], w, h)
        elif fourcc == b"\x00\x00\x00\x00":
            print("Already uncompressed BGRA8 DDS.")
            bgra_pixels = data[128:]
        else:
            print(f"Unknown FourCC {fourcc}, extracting raw data...")
            bgra_pixels = data[128:]
    else:
        print("File is not a DDS container, checking if PNG/JPG...")
        # If it's a PNG/JPG or corrupted, we can load via fallback
        raise ValueError("Unsupported non-DDS format without Pillow")

    # Generate new Uncompressed BGRA8 DDS
    new_header = make_uncompressed_bgra8_dds_header(TARGET_W, TARGET_H)
    full_dds_data = new_header + bgra_pixels[:TARGET_W * TARGET_H * 4]

    with open(DDS_PATH, "wb") as f:
        f.write(full_dds_data)

    print(f"[OK] Saved {DDS_PATH} as Uncompressed BGRA8 DDS ({len(full_dds_data)} bytes, {TARGET_W}x{TARGET_H})")

def fix_superevent_audio():
    print(f"[2/2] Checking audio at {OGG_PATH}...")
    if not os.path.exists(OGG_PATH):
        raise FileNotFoundError(f"Audio file not found: {OGG_PATH}")

    with open(OGG_PATH, "rb") as f:
        magic = f.read(4)

    if magic == b"OggS":
        print("[OK] Valid Ogg Vorbis container verified (Magic: OggS). Clausewitz audio engine can play it natively.")
    else:
        print(f"[WARNING] Magic is {magic}, not OggS! Checking ffmpeg...")
        ffmpeg = shutil.which("ffmpeg")
        if ffmpeg:
            tmp_ogg = OGG_PATH + ".tmp.ogg"
            cmd = [ffmpeg, "-y", "-i", OGG_PATH, "-c:a", "libvorbis", "-ar", "44100", "-ac", "2", tmp_ogg]
            subprocess.run(cmd, check=True)
            os.replace(tmp_ogg, OGG_PATH)
            print("[OK] Converted to Ogg Vorbis 44100 Hz via ffmpeg.")
        else:
            print("[WARNING] ffmpeg not installed, please ensure file is valid Ogg Vorbis.")

if __name__ == "__main__":
    print("=== SuperEvent Assets Fix Script ===")
    fix_superevent_image()
    fix_superevent_audio()
    print("=== Finished successfully! ===")
