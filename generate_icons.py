import os
import math
from PIL import Image, ImageDraw, ImageFilter, ImageChops

def create_gradient_2d(w, h, top_left, top_right, bot_left, bot_right):
    """Creates a smooth 2D bilinear gradient surface."""
    sw, sh = 128, 128
    simg = Image.new("RGBA", (sw, sh))
    pixels = simg.load()
    for y in range(sh):
        ty = y / (sh - 1.0)
        for x in range(sw):
            tx = x / (sw - 1.0)
            
            r_top = top_left[0] * (1 - tx) + top_right[0] * tx
            g_top = top_left[1] * (1 - tx) + top_right[1] * tx
            b_top = top_left[2] * (1 - tx) + top_right[2] * tx
            a_top = (top_left[3] if len(top_left) > 3 else 255) * (1 - tx) + (top_right[3] if len(top_right) > 3 else 255) * tx

            r_bot = bot_left[0] * (1 - tx) + bot_right[0] * tx
            g_bot = bot_left[1] * (1 - tx) + bot_right[1] * tx
            b_bot = bot_left[2] * (1 - tx) + bot_right[2] * tx
            a_bot = (bot_left[3] if len(bot_left) > 3 else 255) * (1 - tx) + (bot_right[3] if len(bot_right) > 3 else 255) * tx

            r = int(r_top * (1 - ty) + r_bot * ty)
            g = int(g_top * (1 - ty) + g_bot * ty)
            b = int(b_top * (1 - ty) + b_bot * ty)
            a = int(a_top * (1 - ty) + a_bot * ty)

            pixels[x, y] = (r, g, b, a)
            
    return simg.resize((w, h), Image.Resampling.BICUBIC)

def render_credit_card(w, h, corner_r, theme="teal_purple", has_chip=True, has_waves=True):
    """
    Renders an ultra-high-definition credit card with bold glowing neon edges,
    obsidian glass surface, metallic microchip, and clean contactless waves.
    """
    pad = 70
    cw, ch = w + pad * 2, h + pad * 2
    img = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    x0, y0 = pad, pad
    x1, y1 = pad + w, pad + h
    
    if theme == "teal_purple":
        c_tl = (0, 245, 212, 255)    # Radiant neon teal (#00f5d4)
        c_tr = (0, 229, 255, 255)    # Bright electric cyan (#00e5ff)
        c_bl = (99, 102, 241, 255)   # Vivid indigo (#6366f1)
        c_br = (192, 38, 211, 255)   # Electric purple/magenta (#c026d3)
        accent = (0, 245, 212)
        secondary = (192, 38, 211)
    else:  # purple theme (back card)
        c_tl = (236, 72, 153, 255)   # Neon pink (#ec4899)
        c_tr = (192, 38, 211, 255)   # Electric magenta (#c026d3)
        c_bl = (147, 51, 234, 255)   # Electric violet (#9333ea)
        c_br = (79, 70, 229, 255)    # Royal indigo (#4f46e5)
        accent = (236, 72, 153)
        secondary = (168, 85, 247)

    # 1. Base Dark Card Mask
    card_mask = Image.new("L", (cw, ch), 0)
    cmd = ImageDraw.Draw(card_mask)
    cmd.rounded_rectangle([x0, y0, x1, y1], radius=corner_r, fill=255)
    
    # Rich Obsidian Glass Gradient
    bg_dark = create_gradient_2d(
        w, h,
        (30, 42, 65, 255),  # subtle obsidian slate top-left
        (20, 28, 48, 255),
        (14, 20, 34, 255),
        (10, 14, 24, 255)   # deep obsidian bottom-right
    )
    base_surface = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    base_surface.paste(bg_dark, (x0, y0))
    base_surface.putalpha(card_mask)
    img = Image.alpha_composite(img, base_surface)
    
    # 2. Subtle Glassmorphism Diagonal Sheen
    sheen = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    sdraw = ImageDraw.Draw(sheen)
    poly = [
        (x0 - w * 0.15, y0),
        (x0 + w * 0.42, y0),
        (x0 + w * 0.12, y1),
        (x0 - w * 0.45, y1)
    ]
    sdraw.polygon(poly, fill=(255, 255, 255, 25))
    sdraw.line([(x0 + w * 0.40, y0), (x0 + w * 0.10, y1)], fill=(255, 255, 255, 55), width=4)
    sheen = sheen.filter(ImageFilter.GaussianBlur(radius=8))
    s_a = ImageChops.multiply(sheen.split()[3], card_mask)
    sheen.putalpha(s_a)
    img = Image.alpha_composite(img, sheen)
    
    # 3. Card Elements
    elements = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    edraw = ImageDraw.Draw(elements)
    
    if has_chip:
        # Precision EMV chip
        chip_w = int(w * 0.16)
        chip_h = int(h * 0.28)
        chip_x = x0 + int(w * 0.12)
        chip_y = y0 + int(h * 0.32)
        
        # Chip body with rounded corners
        edraw.rounded_rectangle(
            [chip_x, chip_y, chip_x + chip_w, chip_y + chip_h],
            radius=12,
            fill=(34, 46, 68, 240),
            outline=(*accent, 240),
            width=4
        )
        mid_x = chip_x + chip_w // 2
        mid_y = chip_y + chip_h // 2
        edraw.line([(chip_x + 6, mid_y), (chip_x + chip_w - 6, mid_y)], fill=(*accent, 240), width=3)
        edraw.line([(mid_x, chip_y + 4), (mid_x, mid_y - 4)], fill=(*accent, 240), width=3)
        edraw.line([(mid_x, mid_y + 4), (mid_x, chip_y + chip_h - 4)], fill=(*accent, 240), width=3)
        edraw.rounded_rectangle([mid_x - 6, mid_y - 6, mid_x + 6, mid_y + 6], radius=4, fill=(*accent, 255))
        
    if has_waves:
        # Contactless wave symbol (3 concentric bold arcs)
        wave_cx = x0 + int(w * 0.34)
        wave_cy = y0 + int(h * 0.46)
        for i, rad in enumerate([int(h * 0.11), int(h * 0.18), int(h * 0.25)]):
            arc_box = [wave_cx - rad, wave_cy - rad, wave_cx + rad, wave_cy + rad]
            alpha = int(190 + i * 32)
            edraw.arc(arc_box, start=-44, end=44, fill=(*accent, alpha), width=5)

    if not has_chip:
        # Back Card Luxury Holographic Foil Accent Line
        foil_y = y0 + int(h * 0.38)
        edraw.line([(x0 + int(w * 0.10), foil_y), (x1 - int(w * 0.10), foil_y)],
                   fill=(*accent, 200), width=5)
        edraw.line([(x0 + int(w * 0.10), foil_y + 12), (x0 + int(w * 0.50), foil_y + 12)],
                   fill=(*secondary, 180), width=3)

    # Brand Emblem (Top Right of Card)
    emblem_x = x1 - int(w * 0.15)
    emblem_y = y0 + int(h * 0.28)
    er = int(h * 0.12)
    edraw.ellipse([emblem_x - er, emblem_y - er, emblem_x + er, emblem_y + er],
                  outline=(*secondary, 230), width=4)
    edraw.ellipse([emblem_x - int(er * 0.6) - er, emblem_y - er,
                   emblem_x - int(er * 0.6) + er, emblem_y + er],
                  outline=(*accent, 250), width=4)

    # Identifier bar / dashes
    bar_y = y1 - int(h * 0.20)
    for bx in range(x0 + int(w * 0.12), x0 + int(w * 0.46), int(w * 0.085)):
        edraw.rounded_rectangle([bx, bar_y, bx + int(w * 0.055), bar_y + 7], radius=3, fill=(110, 140, 185, 200))

    img = Image.alpha_composite(img, elements)
    
    # 4. Multi-Layer Radiant Glowing Perimeter Border
    border_grad = create_gradient_2d(cw, ch, c_tl, c_tr, c_bl, c_br)
    
    # Wide Outer bloom
    bloom_mask = Image.new("L", (cw, ch), 0)
    bldraw = ImageDraw.Draw(bloom_mask)
    bldraw.rounded_rectangle([x0, y0, x1, y1], radius=corner_r, outline=255, width=24)
    bloom_layer = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    bloom_layer.paste(border_grad, (0, 0), bloom_mask)
    bloom_layer = bloom_layer.filter(ImageFilter.GaussianBlur(radius=16))
    
    # Medium inner glow
    mid_mask = Image.new("L", (cw, ch), 0)
    mid_draw = ImageDraw.Draw(mid_mask)
    mid_draw.rounded_rectangle([x0, y0, x1, y1], radius=corner_r, outline=255, width=14)
    mid_layer = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    mid_layer.paste(border_grad, (0, 0), mid_mask)
    mid_layer = mid_layer.filter(ImageFilter.GaussianBlur(radius=6))
    
    # Core sharp stroke
    stroke_mask = Image.new("L", (cw, ch), 0)
    sdraw = ImageDraw.Draw(stroke_mask)
    sdraw.rounded_rectangle([x0, y0, x1, y1], radius=corner_r, outline=255, width=8)
    stroke_layer = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    stroke_layer.paste(border_grad, (0, 0), stroke_mask)
    
    # Laser highlight line on top-left edge
    laser_highlight = Image.new("RGBA", (cw, ch), (0, 0, 0, 0))
    lhdraw = ImageDraw.Draw(laser_highlight)
    lhdraw.arc([x0, y0, x0 + corner_r * 2, y0 + corner_r * 2], start=180, end=270, fill=(245, 255, 255, 230), width=3)
    lhdraw.line([(x0 + corner_r, y0), (x1 - corner_r, y0)], fill=(245, 255, 255, 190), width=3)
    lhdraw.line([(x0, y0 + corner_r), (x0, y1 - corner_r)], fill=(245, 255, 255, 190), width=3)

    img = Image.alpha_composite(img, bloom_layer)
    img = Image.alpha_composite(img, mid_layer)
    img = Image.alpha_composite(img, stroke_layer)
    img = Image.alpha_composite(img, laser_highlight)
    
    return img

def render_wallet_pocket(w, h, corner_r):
    """
    Renders the modern geometric wallet chassis/pocket with:
    - Ergonomic geometric notch cutout at top
    - Beveled/rounded bottom
    - Glowing neon gradient perimeter & top pocket seam
    - Titanium band with glowing geometric "W" emblem
    """
    pad = 70
    ww, wh = w + pad * 2, h + pad * 2
    img = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    x0, y0 = pad, pad
    x1, y1 = pad + w, pad + h
    
    mask = Image.new("L", (ww, wh), 0)
    mdraw = ImageDraw.Draw(mask)
    
    # Base rounded rect
    mdraw.rounded_rectangle([x0, y0, x1, y1], radius=corner_r, fill=255)
    
    # Subtract geometric notch from top
    notch_poly = [
        (x0 + w * 0.28, y0 - 2),
        (x0 + w * 0.42, y0 + 54),
        (x0 + w * 0.58, y0 + 54),
        (x0 + w * 0.72, y0 - 2),
    ]
    mdraw.polygon(notch_poly, fill=0)
    mdraw.ellipse([x0 + w * 0.42 - 16, y0 + 54 - 16, x0 + w * 0.42 + 16, y0 + 54 + 16], fill=255)
    mdraw.ellipse([x0 + w * 0.58 - 16, y0 + 54 - 16, x0 + w * 0.58 + 16, y0 + 54 + 16], fill=255)
    
    # Wallet Base Gradient (Obsidian Carbon / Matte Titanium)
    bg_wallet = create_gradient_2d(
        w, h,
        (30, 40, 62, 255),
        (22, 30, 48, 255),
        (15, 20, 34, 255),
        (10, 14, 24, 255)
    )
    base_surf = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    base_surf.paste(bg_wallet, (x0, y0))
    base_surf.putalpha(mask)
    img = Image.alpha_composite(img, base_surf)
    
    # Diagonal subtle sheen on wallet
    wsheen = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    wsdraw = ImageDraw.Draw(wsheen)
    wpoly = [
        (x0 - w * 0.15, y0),
        (x0 + w * 0.38, y0),
        (x0 + w * 0.10, y1),
        (x0 - w * 0.40, y1)
    ]
    wsdraw.polygon(wpoly, fill=(255, 255, 255, 24))
    wsheen = wsheen.filter(ImageFilter.GaussianBlur(radius=8))
    ws_a = ImageChops.multiply(wsheen.split()[3], mask)
    wsheen.putalpha(ws_a)
    img = Image.alpha_composite(img, wsheen)
    
    # Inner shadow at the pocket rim
    rim_shadow = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    rsdraw = ImageDraw.Draw(rim_shadow)
    rsdraw.line([(x0 + w * 0.28, y0 + 5), (x0 + w * 0.42, y0 + 58),
                 (x0 + w * 0.58, y0 + 58), (x0 + w * 0.72, y0 + 5)],
                fill=(0, 0, 0, 200), width=10)
    rim_shadow = rim_shadow.filter(ImageFilter.GaussianBlur(radius=6))
    rs_a = ImageChops.multiply(rim_shadow.split()[3], mask)
    rim_shadow.putalpha(rs_a)
    img = Image.alpha_composite(img, rim_shadow)
    
    # Glowing Laser Seam along the top pocket rim
    rim_pts = [
        (x0 + corner_r, y0),
        (x0 + w * 0.28, y0),
        (x0 + w * 0.42, y0 + 54),
        (x0 + w * 0.58, y0 + 54),
        (x0 + w * 0.72, y0),
        (x1 - corner_r, y0)
    ]
    rim_grad = create_gradient_2d(ww, wh, (0, 245, 212, 255), (192, 38, 211, 255),
                                  (0, 245, 212, 255), (192, 38, 211, 255))
    
    # Rim glow and stroke
    rim_mask_glow = Image.new("L", (ww, wh), 0)
    ImageDraw.Draw(rim_mask_glow).line(rim_pts, fill=255, width=18, joint="curve")
    rim_glow = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    rim_glow.paste(rim_grad, (0, 0), rim_mask_glow)
    rim_glow = rim_glow.filter(ImageFilter.GaussianBlur(radius=10))
    
    rim_mask_core = Image.new("L", (ww, wh), 0)
    ImageDraw.Draw(rim_mask_core).line(rim_pts, fill=255, width=8, joint="curve")
    rim_layer = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    rim_layer.paste(rim_grad, (0, 0), rim_mask_core)
    
    img = Image.alpha_composite(img, rim_glow)
    img = Image.alpha_composite(img, rim_layer)
    
    # Glowing Outer Border for Wallet sides and bottom
    wallet_border_mask_glow = Image.new("L", (ww, wh), 0)
    wbgdraw = ImageDraw.Draw(wallet_border_mask_glow)
    wbgdraw.line([(x0, y0 + corner_r), (x0, y1 - corner_r)], fill=255, width=16)
    wbgdraw.arc([x0, y1 - corner_r * 2, x0 + corner_r * 2, y1], start=90, end=180, fill=255, width=16)
    wbgdraw.line([(x0 + corner_r, y1), (x1 - corner_r, y1)], fill=255, width=16)
    wbgdraw.arc([x1 - corner_r * 2, y1 - corner_r * 2, x1, y1], start=0, end=90, fill=255, width=16)
    wbgdraw.line([(x1, y0 + corner_r), (x1, y1 - corner_r)], fill=255, width=16)
    
    wb_glow = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    wb_glow.paste(rim_grad, (0, 0), wallet_border_mask_glow)
    wb_glow = wb_glow.filter(ImageFilter.GaussianBlur(radius=10))
    
    wallet_border_mask_core = Image.new("L", (ww, wh), 0)
    wbcdraw = ImageDraw.Draw(wallet_border_mask_core)
    wbcdraw.line([(x0, y0 + corner_r), (x0, y1 - corner_r)], fill=255, width=7)
    wbcdraw.arc([x0, y1 - corner_r * 2, x0 + corner_r * 2, y1], start=90, end=180, fill=255, width=7)
    wbcdraw.line([(x0 + corner_r, y1), (x1 - corner_r, y1)], fill=255, width=7)
    wbcdraw.arc([x1 - corner_r * 2, y1 - corner_r * 2, x1, y1], start=0, end=90, fill=255, width=7)
    wbcdraw.line([(x1, y0 + corner_r), (x1, y1 - corner_r)], fill=255, width=7)
    
    wb_core = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    wb_core.paste(rim_grad, (0, 0), wallet_border_mask_core)
    
    img = Image.alpha_composite(img, wb_glow)
    img = Image.alpha_composite(img, wb_core)
    
    # Titanium Band / Money Clip with Geometric "W" Logo
    clip_w = int(w * 0.44)
    clip_h = int(h * 0.25)
    clip_x = x0 + (w - clip_w) // 2
    clip_y = y0 + int(h * 0.48)
    
    clip_img = Image.new("RGBA", (ww, wh), (0, 0, 0, 0))
    cdraw = ImageDraw.Draw(clip_img)
    
    # Metallic Clip Base
    cdraw.rounded_rectangle(
        [clip_x, clip_y, clip_x + clip_w, clip_y + clip_h],
        radius=16,
        fill=(32, 42, 64, 250),
        outline=(192, 38, 211, 230),
        width=4
    )
    # Clip top bevel highlight
    cdraw.line([(clip_x + 14, clip_y + 4), (clip_x + clip_w - 14, clip_y + 4)],
               fill=(230, 240, 255, 170), width=3)
    
    # Geometric Modern "W" Monogram in center of clip
    mcx = clip_x + clip_w // 2
    mcy = clip_y + clip_h // 2
    mw = int(clip_w * 0.50)
    mh = int(clip_h * 0.56)
    
    w_pts_left = [
        (mcx - mw // 2, mcy - mh // 2),
        (mcx - mw // 4, mcy + mh // 2),
        (mcx, mcy - mh // 6)
    ]
    w_pts_right = [
        (mcx, mcy - mh // 6),
        (mcx + mw // 4, mcy + mh // 2),
        (mcx + mw // 2, mcy - mh // 2)
    ]
    
    cdraw.line(w_pts_left, fill=(0, 245, 212, 255), width=7, joint="round")
    cdraw.line(w_pts_right, fill=(192, 38, 211, 255), width=7, joint="round")
    cdraw.ellipse([mcx - 5, mcy - mh // 6 - 5, mcx + 5, mcy - mh // 6 + 5], fill=(255, 255, 255, 255))
    
    img = Image.alpha_composite(img, clip_img)
    return img

def render_master_icon(mode="squircle"):
    """
    Renders high-resolution 2048x2048 master icon supersampled for maximum fidelity.
    mode:
      - 'squircle' (ic_launcher.png, icon-192.png, icon-512.png)
      - 'round'    (ic_launcher_round.png)
      - 'foreground' (ic_launcher_foreground.png for adaptive icons, fully transparent background with safe-zone margin)
    """
    S = 2048
    cx, cy = S // 2, S // 2
    canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    
    # 1. Base Dark Obsidian Background (#0b0f19)
    obsidian = (11, 15, 25, 255)
    
    if mode != "foreground":
        if mode == "round":
            r = int(S * 0.468)
            bmask = Image.new("L", (S, S), 0)
            bdraw = ImageDraw.Draw(bmask)
            bdraw.ellipse([cx - r, cy - r, cx + r, cy + r], fill=255)
            
            base_bg = Image.new("RGBA", (S, S), obsidian)
            canvas.paste(base_bg, (0, 0), bmask)
            
            cdraw = ImageDraw.Draw(canvas)
            cdraw.ellipse([cx - r, cy - r, cx + r, cy + r], outline=(36, 50, 78, 220), width=6)
        else:  # squircle
            pad = int(S * 0.035)
            rect = [pad, pad, S - pad, S - pad]
            radius = int(S * 0.22)
            bmask = Image.new("L", (S, S), 0)
            bdraw = ImageDraw.Draw(bmask)
            bdraw.rounded_rectangle(rect, radius=radius, fill=255)
            
            base_bg = Image.new("RGBA", (S, S), obsidian)
            canvas.paste(base_bg, (0, 0), bmask)
            
            cdraw = ImageDraw.Draw(canvas)
            cdraw.rounded_rectangle(rect, radius=radius, outline=(36, 50, 78, 220), width=6)

    # 2. Ambient Lighting / Halo Behind Cards
    ambient = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    adraw = ImageDraw.Draw(ambient)
    
    # Left Teal Ambient Halo
    teal_glow_r = int(S * 0.30)
    adraw.ellipse([cx - int(S * 0.42), cy - int(S * 0.36),
                   cx - int(S * 0.42) + teal_glow_r * 2, cy - int(S * 0.36) + teal_glow_r * 2],
                  fill=(0, 245, 212, 65))
                  
    # Right Purple Ambient Halo
    purple_glow_r = int(S * 0.32)
    adraw.ellipse([cx + int(S * 0.02), cy - int(S * 0.39),
                   cx + int(S * 0.02) + purple_glow_r * 2, cy - int(S * 0.39) + purple_glow_r * 2],
                  fill=(192, 38, 211, 70))

    # Center Deep Blue Aura
    blue_glow_r = int(S * 0.25)
    adraw.ellipse([cx - blue_glow_r, cy - int(S * 0.16) - blue_glow_r,
                   cx + blue_glow_r, cy - int(S * 0.16) + blue_glow_r],
                  fill=(79, 70, 229, 50))

    ambient = ambient.filter(ImageFilter.GaussianBlur(radius=int(S * 0.075)))
    canvas = Image.alpha_composite(canvas, ambient)

    # 3. Sizing for components
    # Safe zone for Android adaptive icon is 66% circle.
    # At 0.88 scale, foreground fits well inside safe zone without edge clipping.
    if mode == "foreground":
        scale_fac = 0.88
    elif mode == "round":
        scale_fac = 1.05
    else:  # squircle
        scale_fac = 1.12
    
    card_w = int(780 * scale_fac)
    card_h = int(490 * scale_fac)
    card_r = int(38 * scale_fac)
    
    wallet_w = int(820 * scale_fac)
    wallet_h = int(410 * scale_fac)
    wallet_r = int(38 * scale_fac)
    
    # Back Card (Purple Theme, angled -10 degrees)
    back_card = render_credit_card(card_w, card_h, card_r, theme="purple", has_chip=False, has_waves=False)
    back_rot = back_card.rotate(10, resample=Image.Resampling.BICUBIC, expand=True)
    
    # Drop shadow for Back Card
    b_shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    back_x = cx - int(back_rot.width * 0.58)
    back_y = cy - int(back_rot.height * 0.82)
    
    bs_mask = Image.new("L", (S, S), 0)
    bs_mask.paste(back_rot.split()[3], (back_x + 8, back_y + 22))
    bs_mask = bs_mask.filter(ImageFilter.GaussianBlur(radius=int(26 * scale_fac)))
    b_shadow.paste((0, 0, 0, 160), (0, 0), bs_mask)
    
    # Front Card (Teal & Purple Theme, angled +3 degrees)
    front_card = render_credit_card(card_w, card_h, card_r, theme="teal_purple", has_chip=True, has_waves=True)
    front_rot = front_card.rotate(-3, resample=Image.Resampling.BICUBIC, expand=True)
    
    # Drop shadow for Front Card
    f_shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    front_x = cx - int(front_rot.width * 0.46)
    front_y = cy - int(front_rot.height * 0.70)
    
    fs_mask = Image.new("L", (S, S), 0)
    fs_mask.paste(front_rot.split()[3], (front_x + 6, front_y + 24))
    fs_mask = fs_mask.filter(ImageFilter.GaussianBlur(radius=int(28 * scale_fac)))
    f_shadow.paste((0, 0, 0, 190), (0, 0), fs_mask)

    # Wallet Pocket
    wallet = render_wallet_pocket(wallet_w, wallet_h, wallet_r)
    wallet_x = cx - wallet.width // 2
    wallet_y = cy - int(wallet.height * 0.12)
    
    # Drop shadow for Wallet
    w_shadow = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    ws_mask = Image.new("L", (S, S), 0)
    w_body_mask = Image.new("L", (wallet_w, wallet_h), 0)
    ImageDraw.Draw(w_body_mask).rounded_rectangle([0, 0, wallet_w - 1, wallet_h - 1], radius=wallet_r, fill=255)
    ws_mask.paste(w_body_mask, (wallet_x + 70, wallet_y + 70 + 20))
    ws_mask = ws_mask.filter(ImageFilter.GaussianBlur(radius=int(32 * scale_fac)))
    w_shadow.paste((0, 0, 0, 200), (0, 0), ws_mask)

    # 4. Composite Layers onto Canvas with proper alpha_composite
    canvas = Image.alpha_composite(canvas, b_shadow)
    
    back_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    back_layer.paste(back_rot, (back_x, back_y))
    canvas = Image.alpha_composite(canvas, back_layer)
    
    canvas = Image.alpha_composite(canvas, f_shadow)
    
    front_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    front_layer.paste(front_rot, (front_x, front_y))
    canvas = Image.alpha_composite(canvas, front_layer)
    
    canvas = Image.alpha_composite(canvas, w_shadow)
    
    wallet_layer = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    wallet_layer.paste(wallet, (wallet_x, wallet_y))
    canvas = Image.alpha_composite(canvas, wallet_layer)

    # If squircle or round, clip canvas to the background shape to guarantee crisp edges and solid background
    if mode != "foreground":
        final_canvas = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        final_canvas.paste(canvas, (0, 0), bmask)
        canvas = final_canvas

    return canvas

def main():
    print("=================================================================")
    print("Generating modern high-end fintech Wallet Manager master assets...")
    print("=================================================================")
    
    print("Rendering 2048x2048 master squircle icon...")
    master_squircle = render_master_icon("squircle")
    
    print("Rendering 2048x2048 master round icon...")
    master_round = render_master_icon("round")
    
    print("Rendering 2048x2048 master foreground icon (safe-zone padded)...")
    master_foreground = render_master_icon("foreground")

    base_res = os.path.join("android", "app", "src", "main", "res")
    
    # Android density configurations: (dir_name, launcher_size, foreground_size)
    mipmap_configs = [
        ("mipmap-mdpi", 48, 108),
        ("mipmap-hdpi", 72, 162),
        ("mipmap-xhdpi", 96, 216),
        ("mipmap-xxhdpi", 144, 324),
        ("mipmap-xxxhdpi", 192, 432),
    ]

    print("\n--- Generating Android Launcher Icons ---")
    for dir_name, size, fg_size in mipmap_configs:
        dir_path = os.path.join(base_res, dir_name)
        os.makedirs(dir_path, exist_ok=True)
        
        # ic_launcher.png (standard icon)
        launcher_path = os.path.join(dir_path, "ic_launcher.png")
        icon_img = master_squircle.resize((size, size), Image.Resampling.LANCZOS)
        icon_img.save(launcher_path, format="PNG", optimize=True)
        print(f"[OK] {launcher_path} ({size}x{size})")
        
        # ic_launcher_round.png (circular icon)
        round_path = os.path.join(dir_path, "ic_launcher_round.png")
        round_img = master_round.resize((size, size), Image.Resampling.LANCZOS)
        round_img.save(round_path, format="PNG", optimize=True)
        print(f"[OK] {round_path} ({size}x{size})")

        # ic_launcher_foreground.png (adaptive foreground)
        fg_path = os.path.join(dir_path, "ic_launcher_foreground.png")
        fg_img = master_foreground.resize((fg_size, fg_size), Image.Resampling.LANCZOS)
        fg_img.save(fg_path, format="PNG", optimize=True)
        print(f"[OK] {fg_path} ({fg_size}x{fg_size})")

    print("\n--- Generating Web PWA Icons ---")
    # Root PWA icons
    pwa_192 = master_squircle.resize((192, 192), Image.Resampling.LANCZOS)
    pwa_192.save("icon-192.png", format="PNG", optimize=True)
    print("[OK] icon-192.png (192x192)")

    pwa_512 = master_squircle.resize((512, 512), Image.Resampling.LANCZOS)
    pwa_512.save("icon-512.png", format="PNG", optimize=True)
    print("[OK] icon-512.png (512x512)")

    print("\n=================================================================")
    print("All Wallet Manager fintech icons generated and replaced successfully!")
    print("=================================================================")

if __name__ == "__main__":
    main()
