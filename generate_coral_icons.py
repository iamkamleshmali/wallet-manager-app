import os
import math
from PIL import Image, ImageDraw, ImageFilter

def create_radial_linear_gradient(w, h, c_top_left, c_bottom_right):
    """Creates a high-precision 2D diagonal gradient surface."""
    sw, sh = 256, 256
    simg = Image.new("RGBA", (sw, sh))
    pixels = simg.load()
    for y in range(sh):
        for x in range(sw):
            t = (x + y) / float(sw + sh - 2)
            r = int(c_top_left[0] * (1 - t) + c_bottom_right[0] * t)
            g = int(c_top_left[1] * (1 - t) + c_bottom_right[1] * t)
            b = int(c_top_left[2] * (1 - t) + c_bottom_right[2] * t)
            a = int(c_top_left[3] * (1 - t) + c_bottom_right[3] * t)
            pixels[x, y] = (r, g, b, a)
    return simg.resize((w, h), Image.Resampling.BICUBIC)

def render_coral_wallet_icon(size=1024, mode="squircle"):
    """
    Renders the official Wallet Manager website logo:
    - Warm orange/coral gradient (#FF6B4A -> #FF4757 / #FF3838)
    - Clean white line-art rounded wallet with subtle flap and closure card
    - mode: 'squircle' (standard launcher), 'round' (circular), 'foreground' (adaptive icon foreground)
    """
    S = size
    scale = S / 1024.0

    # 1. Background
    # Website gradient: warm vibrant coral orange to ruby-red/coral
    # Top-Left: #FF7043 (RGB: 255, 112, 67)
    # Bottom-Right: #FF3D3D (RGB: 255, 61, 61)
    bg_gradient = create_radial_linear_gradient(
        S, S,
        (255, 115, 65, 255),
        (255, 50, 60, 255)
    )

    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))

    if mode != "foreground":
        # Draw background squircle or circle
        mask = Image.new("L", (S, S), 0)
        mdraw = ImageDraw.Draw(mask)
        if mode == "squircle":
            corner_r = int(230 * scale)
            mdraw.rounded_rectangle([0, 0, S, S], radius=corner_r, fill=255)
        elif mode == "round":
            mdraw.ellipse([4, 4, S - 4, S - 4], fill=255)
        
        canvas.paste(bg_gradient, (0, 0), mask)

        # Subtle top-inner highlight on squircle edge for premium 3D feel
        h_draw = ImageDraw.Draw(canvas)
        if mode == "squircle":
            h_draw.rounded_rectangle([0, 0, S, S], radius=corner_r, outline=(255, 255, 255, 45), width=int(3 * scale))
    else:
        # Foreground for Android adaptive icon (72dp safe zone in 108dp asset)
        # Background is provided by ic_launcher_background.xml
        pass

    # 2. Render White Line-Art Wallet Icon
    # Supersampled 4x for crystal clear antialiasing
    SS = 4
    SW = S * SS
    wallet_layer = Image.new("RGBA", (SW, SW), (0, 0, 0, 0))
    wdraw = ImageDraw.Draw(wallet_layer)

    # Coordinates scaled in supersampled space
    # Center of wallet: SW // 2, SW // 2
    cx, cy = SW // 2, SW // 2
    
    # Determine wallet bounding box
    # In 'foreground' mode, content is scaled down to 60% so it stays completely inside Android circle mask
    content_scale = 0.52 if mode == "foreground" else 0.58
    ww = int(SW * content_scale)
    wh = int(ww * 0.72) # wallet aspect ratio
    
    left = cx - ww // 2
    right = cx + ww // 2
    top = cy - wh // 2
    bottom = cy + wh // 2

    line_w = int(28 * scale * SS)
    corner_rw = int(80 * scale * SS)

    # A. Wallet Outer Body (Rounded Rectangle with open flap seam)
    wdraw.rounded_rectangle(
        [left, top, right, bottom],
        radius=corner_rw,
        outline=(255, 255, 255, 255),
        width=line_w
    )

    # B. Horizontal flap line across the wallet upper third
    flap_y = top + int(wh * 0.38)
    
    # C. Wallet Clasp / Card Pocket Notch on the right side
    # Clasp box: rounded tab extending from right
    clasp_w = int(ww * 0.28)
    clasp_h = int(wh * 0.38)
    clasp_right = right
    clasp_left = clasp_right - clasp_w
    clasp_top = flap_y - clasp_h // 2
    clasp_bottom = flap_y + clasp_h // 2
    clasp_r = int(32 * scale * SS)

    # Fill clasp background with matching coral so it masks the background line cleanly
    # or clear background then redraw clasp
    clasp_fill = (255, 75, 62, 255) if mode != "foreground" else (255, 75, 62, 255)
    wdraw.rounded_rectangle(
        [clasp_left, clasp_top, clasp_right, clasp_bottom],
        radius=clasp_r,
        fill=clasp_fill,
        outline=(255, 255, 255, 255),
        width=line_w
    )

    # D. Inside the clasp: a small circular latch dot
    dot_r = int(18 * scale * SS)
    dot_cx = clasp_left + int(clasp_w * 0.42)
    dot_cy = (clasp_top + clasp_bottom) // 2
    wdraw.ellipse(
        [dot_cx - dot_r, dot_cy - dot_r, dot_cx + dot_r, dot_cy + dot_r],
        fill=(255, 255, 255, 255)
    )

    # Downsample wallet_layer with high quality Lanczos antialiasing
    wallet_final = wallet_layer.resize((S, S), Image.Resampling.LANCZOS)

    # Composite wallet onto canvas
    canvas = Image.alpha_composite(canvas, wallet_final)

    return canvas

def generate_all_icons():
    print("Generating official Coral Wallet Manager launcher and PWA icons...")
    
    master_squircle = render_coral_wallet_icon(size=1024, mode="squircle")
    master_round = render_coral_wallet_icon(size=1024, mode="round")
    master_foreground = render_coral_wallet_icon(size=1024, mode="foreground")

    # Android mipmap densities
    base_res = os.path.join("android", "app", "src", "main", "res")
    mipmap_configs = [
        ("mipmap-mdpi", 48, 108),
        ("mipmap-hdpi", 72, 162),
        ("mipmap-xhdpi", 96, 216),
        ("mipmap-xxhdpi", 144, 324),
        ("mipmap-xxxhdpi", 192, 432),
    ]

    for dir_name, size, fg_size in mipmap_configs:
        dir_path = os.path.join(base_res, dir_name)
        os.makedirs(dir_path, exist_ok=True)

        # Standard icon
        p = os.path.join(dir_path, "ic_launcher.png")
        master_squircle.resize((size, size), Image.Resampling.LANCZOS).save(p, optimize=True)

        # Round icon
        pr = os.path.join(dir_path, "ic_launcher_round.png")
        master_round.resize((size, size), Image.Resampling.LANCZOS).save(pr, optimize=True)

        # Adaptive Foreground icon
        pfg = os.path.join(dir_path, "ic_launcher_foreground.png")
        master_foreground.resize((fg_size, fg_size), Image.Resampling.LANCZOS).save(pfg, optimize=True)
        print(f"Generated {dir_name} icons.")

    # Root PWA / Web icons
    master_squircle.resize((192, 192), Image.Resampling.LANCZOS).save("icon-192.png", optimize=True)
    master_squircle.resize((512, 512), Image.Resampling.LANCZOS).save("icon-512.png", optimize=True)
    
    # Save a copy inside assets/images if needed for in-app display
    assets_dir = os.path.join("assets", "images")
    os.makedirs(assets_dir, exist_ok=True)
    master_squircle.resize((512, 512), Image.Resampling.LANCZOS).save(os.path.join(assets_dir, "wallet_logo.png"), optimize=True)
    print("All icons successfully generated!")

if __name__ == "__main__":
    generate_all_icons()
