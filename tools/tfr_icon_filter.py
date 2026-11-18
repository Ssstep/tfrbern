#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
=============================================================================
THE FIRE RISES (TFR) FOCUS ICON POST-PROCESSING FILTER & GFX GENERATOR
=============================================================================
Applies the signature HOI4: The Fire Rises visual style:
1. Resizes/fits to 92x92 tactical emblem dimensions.
2. Composes onto a distressed metallic geometric badge frame at the bottom.
3. Applies chromatic aberration (1px red/blue channel shift).
4. Generates a horizontal CRT scanline pattern (15% opacity).
5. Enhances crushed blacks and neon rim lighting.
6. Automatically outputs interface/bernkastel_goals.gfx with shine animations.
=============================================================================
"""

import os
import sys
import glob
from pathlib import Path

try:
    from PIL import Image, ImageEnhance, ImageDraw, ImageOps
except ImportError:
    print("[WARN] Pillow (PIL) is not installed. To run this script:")
    print("       pip install pillow")
    Image = None

# Configuration Constants
CANVAS_SIZE = (92, 92)
SCANLINE_OPACITY = 0.15      # 15% opacity
SCANLINE_STEP = 2             # Every 2 pixels
CHROMATIC_SHIFT = 1          # 1 pixel shift
NEON_PURPLE = (155, 31, 232)  # #9B1FE8
NEON_CRIMSON = (230, 0, 38)   # #E60026
NEON_CYAN = (0, 229, 255)     # #00E5FF
METALLIC_BASE = (38, 42, 48)  # Distressed dark steel

def apply_chromatic_aberration(im: Image.Image, shift: int = 1) -> Image.Image:
    """Shifts red channel left and blue channel right by `shift` px."""
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    r, g, b, a = im.split()

    # Shift Red channel left
    r_shifted = Image.new("L", im.size, 0)
    r_shifted.paste(r, (-shift, 0))

    # Shift Blue channel right
    b_shifted = Image.new("L", im.size, 0)
    b_shifted.paste(b, (shift, 0))

    # Keep Green in center
    return Image.merge("RGBA", (r_shifted, g, b_shifted, a))

def apply_scanlines(im: Image.Image, opacity: float = 0.15, step: int = 2) -> Image.Image:
    """Overlays horizontal CRT scanlines across the image with given opacity."""
    w, h = im.size
    scanline_layer = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(scanline_layer)

    alpha_val = int(255 * opacity)
    for y in range(0, h, step):
        draw.line([(0, y), (w, y)], fill=(10, 10, 15, alpha_val))

    return Image.alpha_composite(im, scanline_layer)

def draw_tfr_badge_frame(im: Image.Image) -> Image.Image:
    """Draws the distressed metallic geometric chevron/badge frame at the bottom."""
    w, h = im.size
    frame_layer = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(frame_layer)

    # Distressed geometric badge base plate at bottom (y=78..90)
    badge_points = [
        (16, 88), (24, 82), (68, 82), (76, 88), (66, 91), (26, 91)
    ]
    draw.polygon(badge_points, fill=(28, 30, 35, 230), outline=(70, 75, 85, 240))

    # Neon rim highlight along the metallic edge
    draw.line([(24, 82), (68, 82)], fill=(155, 31, 232, 220), width=1) # Purple rim
    draw.line([(16, 88), (26, 91)], fill=(0, 229, 255, 180), width=1)  # Cyan accent

    # Small tactical metallic screws / notches
    draw.rectangle([21, 84, 23, 86], fill=(120, 125, 135, 255))
    draw.rectangle([69, 84, 71, 86], fill=(120, 125, 135, 255))

    return Image.alpha_composite(im, frame_layer)

def enhance_tfr_contrast(im: Image.Image) -> Image.Image:
    """Crushes blacks and pops saturation/contrast for the gritty VHS aesthetic."""
    if im.mode != "RGBA":
        im = im.convert("RGBA")
    r, g, b, a = im.split()
    rgb = Image.merge("RGB", (r, g, b))

    # Increase contrast to crush blacks
    contrast = ImageEnhance.Contrast(rgb)
    rgb = contrast.enhance(1.25)

    # Increase color saturation
    color = ImageEnhance.Color(rgb)
    rgb = color.enhance(1.15)

    r_new, g_new, b_new = rgb.split()
    return Image.merge("RGBA", (r_new, g_new, b_new, a))

def process_image(src_path: Path, dst_path: Path):
    """Processes a single focus icon."""
    with Image.open(src_path) as im:
        im = im.convert("RGBA")

        # Resize / Fit to 92x92 maintaining aspect ratio
        im.thumbnail(CANVAS_SIZE, Image.Resampling.LANCZOS)
        canvas = Image.new("RGBA", CANVAS_SIZE, (0, 0, 0, 0))
        offset_x = (CANVAS_SIZE[0] - im.width) // 2
        offset_y = (CANVAS_SIZE[1] - im.height) // 2
        canvas.paste(im, (offset_x, offset_y), im)

        # Apply TFR pipeline
        canvas = enhance_tfr_contrast(canvas)
        canvas = apply_chromatic_aberration(canvas, shift=CHROMATIC_SHIFT)
        canvas = apply_scanlines(canvas, opacity=SCANLINE_OPACITY, step=SCANLINE_STEP)
        canvas = draw_tfr_badge_frame(canvas)

        dst_path.parent.mkdir(parents=True, exist_ok=True)
        canvas.save(dst_path, format="PNG")
        print(f"[OK] Filtered: {src_path.name} -> {dst_path.name}")

def generate_goals_gfx(goals_dir: Path, gfx_out_path: Path):
    """Auto-generates the complete interface/bernkastel_goals.gfx with shine animations."""
    png_files = sorted(glob.glob(str(goals_dir / "focus_bern_*.png")))
    lines = ["spriteTypes = {"]

    # 1. Base Static Sprites
    lines.append("\t# =====================================================================")
    lines.append("\t# 1. STATIC FOCUS ICONS")
    lines.append("\t# =====================================================================")
    for p in png_files:
        name = Path(p).stem
        sprite_name = f"GFX_{name}"
        rel_path = f"gfx/interface/goals/{Path(p).name}".replace("\\", "/")
        lines.append(f'\tspriteType = {{')
        lines.append(f'\t\tname = "{sprite_name}"')
        lines.append(f'\t\ttexturefile = "{rel_path}"')
        lines.append(f'\t}}')

    # 2. Glowing Shine Animation Sprites
    lines.append("\n\t# =====================================================================")
    lines.append("\t# 2. GLOWING SHINE ANIMATION SPRITES (LEARNING / ACTIVE FOCUS)")
    lines.append("\t# =====================================================================")
    for p in png_files:
        name = Path(p).stem
        sprite_name = f"GFX_{name}_shine"
        rel_path = f"gfx/interface/goals/{Path(p).name}".replace("\\", "/")
        lines.append(f'\tSpriteType = {{')
        lines.append(f'\t\tname = "{sprite_name}"')
        lines.append(f'\t\ttexturefile = "{rel_path}"')
        lines.append(f'\t\teffectFile = "gfx/FX/buttonstate.lua"')
        lines.append(f'\t\tanimation = {{')
        lines.append(f'\t\t\tanimationmaskfile = "{rel_path}"')
        lines.append(f'\t\t\tanimationtexturefile = "gfx/interface/goals/shine_overlay.dds"')
        lines.append(f'\t\t\tanimationrotation = -90.0')
        lines.append(f'\t\t\tanimationlooping = no')
        lines.append(f'\t\t\tanimationtime = 0.75')
        lines.append(f'\t\t\tanimationdelay = 0')
        lines.append(f'\t\t\tanimationblendmode = "add"')
        lines.append(f'\t\t\tanimationtype = "scrolling"')
        lines.append(f'\t\t\tanimationrotationoffset = {{ x = 0.0 y = 0.0 }}')
        lines.append(f'\t\t\tanimationtexturescale = {{ x = 1.0 y = 1.0 }}')
        lines.append(f'\t\t}}')
        lines.append(f'\t\tanimation = {{')
        lines.append(f'\t\t\tanimationmaskfile = "{rel_path}"')
        lines.append(f'\t\t\tanimationtexturefile = "gfx/interface/goals/shine_overlay.dds"')
        lines.append(f'\t\t\tanimationrotation = 90.0')
        lines.append(f'\t\t\tanimationlooping = no')
        lines.append(f'\t\t\tanimationtime = 0.75')
        lines.append(f'\t\t\tanimationdelay = 0')
        lines.append(f'\t\t\tanimationblendmode = "add"')
        lines.append(f'\t\t\tanimationtype = "scrolling"')
        lines.append(f'\t\t\tanimationrotationoffset = {{ x = 0.0 y = 0.0 }}')
        lines.append(f'\t\t\tanimationtexturescale = {{ x = 1.0 y = 1.0 }}')
        lines.append(f'\t\t}}')
        lines.append(f'\t\tlegacy_lazy_load = no')
        lines.append(f'\t}}')

    lines.append("}\n")
    gfx_out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(gfx_out_path, "w", encoding="utf-8") as f:
        f.write("\n".join(lines))
    print(f"[OK] Generated GFX: {gfx_out_path} with {len(png_files)} focuses + shines.")

def main():
    root = Path(__file__).resolve().parent.parent
    goals_dir = root / "gfx" / "interface" / "goals"
    raw_dir = goals_dir / "raw"
    gfx_out = root / "interface" / "bernkastel_goals.gfx"

    print("=== TFR Focus Icon Filter & GFX Generator ===")
    if Image is None:
        print("[FAIL] Pillow is required to process images. Install via: pip install pillow")
        return

    # Process all raw icons if raw directory exists, or re-filter goals directory
    src_dir = raw_dir if raw_dir.exists() else goals_dir
    raw_images = list(src_dir.glob("focus_bern_*.png"))
    print(f"Found {len(raw_images)} icons in {src_dir}")

    for img_path in raw_images:
        out_path = goals_dir / img_path.name
        process_image(img_path, out_path)

    generate_goals_gfx(goals_dir, gfx_out)

if __name__ == "__main__":
    main()
