import os
import math
from PIL import Image, ImageDraw, ImageFont

def render_master_icon(mode="squircle"):
    """
    Renders high-resolution 1024x1024 master icon.
    mode:
      - 'squircle' (ic_launcher.png, icon-192.png, icon-512.png)
      - 'round'    (ic_launcher_round.png)
      - 'foreground' (ic_launcher_foreground.png for adaptive icons)
    """
    S = 1024
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = S / 2, S / 2

    # 1. Base Dark Navy Background (#0b0f19)
    if mode != "foreground":
        navy = (11, 15, 25, 255)  # #0b0f19
        if mode == "round":
            r = 480
            bbox = [cx - r, cy - r, cx + r, cy + r]
            draw.ellipse(bbox, fill=navy)
            
            # Radial subtle ambient glow
            for i in range(120):
                gr = r - i * 3
                if gr <= 0: break
                alpha = int(45 * (1 - i / 120))
                draw.ellipse([cx - gr, cy - gr, cx + gr, cy + gr], fill=(16, 28, 48, alpha))
            
            # Subtle outer rim
            draw.ellipse(bbox, outline=(28, 42, 68, 200), width=4)
        else:  # squircle
            pad = 28
            radius = 210
            rect = [pad, pad, S - pad, S - pad]
            draw.rounded_rectangle(rect, radius=radius, fill=navy)
            
            # Radial ambient glow inside squircle
            ambient = Image.new("RGBA", (S, S), (0, 0, 0, 0))
            adraw = ImageDraw.Draw(ambient)
            for i in range(140):
                gr = 480 - i * 3
                if gr <= 0: break
                alpha = int(45 * (1 - i / 140))
                adraw.ellipse([cx - gr, cy - gr, cx + gr, cy + gr], fill=(16, 28, 48, alpha))
            
            mask = Image.new("L", (S, S), 0)
            mdraw = ImageDraw.Draw(mask)
            mdraw.rounded_rectangle(rect, radius=radius, fill=255)
            img.paste(ambient, (0, 0), mask)
            draw = ImageDraw.Draw(img)
            
            # Subtle outer border
            draw.rounded_rectangle(rect, radius=radius, outline=(28, 42, 68, 200), width=4)

    # 2. Subtle Cyan & Emerald Ambient Glow & Ring
    # For foreground adaptive icon, scale down slightly so it stays well within the 66% safe zone
    badge_r = 295 if mode != "foreground" else 245
    glow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    gdraw = ImageDraw.Draw(glow)
    
    # Cyan (#06b6d4) to Emerald (#10b981) ambient aura
    aura_spread = 45 if mode != "foreground" else 35
    for i in range(aura_spread):
        gr = badge_r + aura_spread - i
        t = i / float(aura_spread)
        cr = int(6 * (1 - t) + 16 * t)
        cg = int(182 * (1 - t) + 185 * t)
        cb = int(212 * (1 - t) + 129 * t)
        alpha = int(40 * (1 - t) ** 1.5)
        gdraw.ellipse([cx - gr, cy - gr, cx + gr, cy + gr], fill=(cr, cg, cb, alpha))
        
    # Dual-tone perimeter accent ring
    ring_r = badge_r + 10
    ring_w = 7 if mode != "foreground" else 6
    for deg in range(360):
        rad = math.radians(deg - 45)
        t = (math.sin(rad) + 1) / 2.0
        cr = int(6 * (1 - t) + 16 * t)
        cg = int(182 * (1 - t) + 185 * t)
        cb = int(212 * (1 - t) + 129 * t)
        gdraw.arc([cx - ring_r, cy - ring_r, cx + ring_r, cy + ring_r],
                  start=deg, end=deg + 2, fill=(cr, cg, cb, 240), width=ring_w)

    img = Image.alpha_composite(img, glow)

    # 3. Golden Badge (Metallic luxury medallion)
    badge_mask = Image.new("L", (S, S), 0)
    bmdraw = ImageDraw.Draw(badge_mask)
    bmdraw.ellipse([cx - badge_r, cy - badge_r, cx + badge_r, cy + badge_r], fill=255)

    gold_grad = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    lx = cx - badge_r * 0.4
    ly = cy - badge_r * 0.4
    max_d = badge_r * 2.2
    
    # Rich metallic gold radial highlight
    for y in range(int(cy - badge_r), int(cy + badge_r) + 1):
        for x in range(int(cx - badge_r), int(cx + badge_r) + 1):
            dx = x - lx
            dy = y - ly
            dist = math.sqrt(dx*dx + dy*dy)
            t = min(1.0, max(0.0, dist / max_d))
            # Stops:
            # 0.00 -> champagne highlight #fff2a3 (255, 242, 163)
            # 0.35 -> bright gold #fbb718 (251, 183, 24)
            # 0.70 -> amber gold #d97706 (217, 119, 6)
            # 1.00 -> deep bronze #873e00 (135, 62, 0)
            if t < 0.35:
                st = t / 0.35
                r = int(255 * (1 - st) + 251 * st)
                g = int(242 * (1 - st) + 183 * st)
                b = int(163 * (1 - st) + 24 * st)
            elif t < 0.70:
                st = (t - 0.35) / 0.35
                r = int(251 * (1 - st) + 217 * st)
                g = int(183 * (1 - st) + 119 * st)
                b = int(24 * (1 - st) + 6 * st)
            else:
                st = (t - 0.70) / 0.30
                r = int(217 * (1 - st) + 135 * st)
                g = int(119 * (1 - st) + 62 * st)
                b = int(6 * (1 - st) + 0 * st)
            gold_grad.putpixel((x, y), (r, g, b, 255))
            
    gold_grad.putalpha(badge_mask)
    img = Image.alpha_composite(img, gold_grad)
    draw = ImageDraw.Draw(img)

    # Highlight and inner milled bevel rings on gold badge
    draw.ellipse([cx - badge_r, cy - badge_r, cx + badge_r, cy + badge_r],
                 outline=(255, 250, 210, 240), width=5)
    draw.ellipse([cx - (badge_r - 5), cy - (badge_r - 5), cx + (badge_r - 5), cy + (badge_r - 5)],
                 outline=(145, 75, 5, 170), width=3)
    
    in_r = badge_r - (28 if mode != "foreground" else 22)
    draw.ellipse([cx - in_r, cy - in_r, cx + in_r, cy + in_r], outline=(255, 245, 180, 220), width=3)
    draw.ellipse([cx - in_r + 2, cy - in_r + 2, cx + in_r - 2, cy + in_r - 2], outline=(150, 80, 5, 180), width=3)

    # 4. 'WM' Monogram in Center
    font_path = "C:\\Windows\\Fonts\\segoeuib.ttf"
    if not os.path.exists(font_path):
        font_path = "C:\\Windows\\Fonts\\arialbd.ttf"

    font_size = int(220 * (badge_r / 295.0))
    font = ImageFont.truetype(font_path, font_size)
    text = "WM"
    t_bbox = font.getbbox(text)
    tw = t_bbox[2] - t_bbox[0]
    th = t_bbox[3] - t_bbox[1]
    tx = cx - tw / 2 - t_bbox[0]
    ty = cy - th / 2 - t_bbox[1] - (4 if mode != "foreground" else 2)

    # Engraved bevel highlight at top
    draw.text((tx, ty + 2), text, font=font, fill=(255, 250, 200, 220))
    # Crisp Dark Navy monogram (#0b0f19)
    draw.text((tx, ty), text, font=font, fill=(11, 15, 25, 255))

    # 5. Cyan/Emerald Accent Underline Bar
    bar_w = int(100 * (badge_r / 295.0))
    bar_y = cy + th / 2 + (18 if mode != "foreground" else 14)
    bar_h = 6 if mode != "foreground" else 5
    for bx in range(int(cx - bar_w / 2), int(cx + bar_w / 2)):
        t = (bx - (cx - bar_w / 2)) / float(bar_w)
        cr = int(6 * (1 - t) + 16 * t)
        cg = int(182 * (1 - t) + 185 * t)
        cb = int(212 * (1 - t) + 129 * t)
        draw.line([(bx, bar_y), (bx, bar_y + bar_h)], fill=(cr, cg, cb, 240))

    return img

def main():
    print("Generating official Wallet Manager master assets...")
    master_squircle = render_master_icon("squircle")
    master_round = render_master_icon("round")
    master_foreground = render_master_icon("foreground")

    base_res = os.path.join("android", "app", "src", "main", "res")
    
    # Density configs: (dir_name, launcher_size, foreground_size)
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
        
        # ic_launcher.png
        launcher_path = os.path.join(dir_path, "ic_launcher.png")
        icon_img = master_squircle.resize((size, size), Image.Resampling.LANCZOS)
        icon_img.save(launcher_path, format="PNG", optimize=True)
        print(f"Created: {launcher_path} ({size}x{size})")
        
        # ic_launcher_round.png
        round_path = os.path.join(dir_path, "ic_launcher_round.png")
        round_img = master_round.resize((size, size), Image.Resampling.LANCZOS)
        round_img.save(round_path, format="PNG", optimize=True)
        print(f"Created: {round_path} ({size}x{size})")

        # ic_launcher_foreground.png (for adaptive icons)
        fg_path = os.path.join(dir_path, "ic_launcher_foreground.png")
        fg_img = master_foreground.resize((fg_size, fg_size), Image.Resampling.LANCZOS)
        fg_img.save(fg_path, format="PNG", optimize=True)
        print(f"Created: {fg_path} ({fg_size}x{fg_size})")

    # Root PWA icons
    pwa_192 = master_squircle.resize((192, 192), Image.Resampling.LANCZOS)
    pwa_192.save("icon-192.png", format="PNG", optimize=True)
    print("Created: icon-192.png (192x192)")

    pwa_512 = master_squircle.resize((512, 512), Image.Resampling.LANCZOS)
    pwa_512.save("icon-512.png", format="PNG", optimize=True)
    print("Created: icon-512.png (512x512)")

    print("All official Wallet Manager icons generated successfully!")

if __name__ == "__main__":
    main()
