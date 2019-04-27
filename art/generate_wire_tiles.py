from PIL import Image, ImageDraw

cable_tray_hub = Image.open("cable_tray_hub.png")
cable_tray_straight = Image.open("cable_tray_straight.png")
cable_tray_edge = Image.open("cable_tray_edge.png")

wire_names = ["data", "power", "3phase"]
wire_offsets = [11, 15, 19]
wire_colors = [(34, 0, 255, 255), (255, 216, 0, 255), (255, 0, 0, 255)]

### GENERATE CABLE TRAY IMAGES
main = Image.new("RGBA", (32 * 4, 32 * 4), (255,255,255,0))
main.putalpha(0)

for i in range(16):
    # up, down , left, right
    sides = [i & 1 > 0, i & 2 > 0, i & 4 > 0, i & 8 > 0]
    im = Image.new("RGBA", (32, 32), (255,255,255,0))
    draw = ImageDraw.Draw(im)

    updown = sides[0] and sides[1] and not sides[2] and not sides[3]
    leftright = not sides[0] and not sides[1] and sides[2] and sides[3]
    tee = not (updown or leftright)

    if tee:
        im.paste(cable_tray_hub, (0,0), cable_tray_hub)
    else:
        rot = cable_tray_straight.rotate(0 if updown else 90)
        im.paste(rot, (0,0), rot)

    if sides[0]:
        im.paste(cable_tray_edge, (0,0), cable_tray_edge)

    if sides[1]:
        rot = cable_tray_edge.rotate(180)
        im.paste(rot, (0,0), rot)

    if sides[2]:
        rot = cable_tray_edge.rotate(90)
        im.paste(rot, (0,0), rot)

    if sides[3]:
        rot = cable_tray_edge.rotate(270)
        im.paste(rot, (0,0), rot)

    x = i % 4
    y = i // 4
    main.paste(im, (x*32, y*32), im)

main.save("cabletray.png")


### GENERATE WIRE IMAGES

for j in range(len(wire_offsets)):
    main = Image.new("RGBA", (32 * 4, 32 * 4), (255,255,255,0))
    main.putalpha(0)

    name = wire_names[j]
    off = wire_offsets[j]
    col = wire_colors[j]

    for i in range(16):
        # up, down , left, right
        sides = [i & 1 > 0, i & 2 > 0, i & 4 > 0, i & 8 > 0]
        im = Image.new("RGBA", (32, 32), (255,255,255,0))
        draw = ImageDraw.Draw(im)

        updown = sides[0] and sides[1] and not sides[2] and not sides[3]
        leftright = not sides[0] and not sides[1] and sides[2] and sides[3]
        tee = not (updown or leftright)

        if sides[0]:
            draw.rectangle((off, 0, off+1, off), col)
        if sides[1]:
            draw.rectangle((off, off+1, off+1, 31), col)
        if sides[2]:
            draw.rectangle((0, off, off, off+1), col)
        if sides[3]:
            draw.rectangle((off+1, off, 31, off+1), col)

        if tee:
            draw.rectangle((off-1, off-1, off+2, off+2), col)

        x = i % 4
        y = i // 4
        main.paste(im, (x*32, y*32), im)

    main.save("wire_{}.png".format(name))


### GENERATE TILESET RESOURCE FILES
for name in ["cabletray"] + ["wire_{}".format(name) for name in wire_names]:
    header = """[gd_resource type="TileSet" load_steps=2 format=2]

[ext_resource path="res://art/{}.png" type="Texture" id=1]

[resource]""".format(name)

    with open("{}.tres".format(name), "w") as f:
        f.write(header)
        tid = 0

        for i in range(16):
            # up, down , left, right
            sides = [i & 1 > 0, i & 2 > 0, i & 4 > 0, i & 8 > 0]
            dirs = "".join(["n", "s", "w", "e"][x] if sides[x] else "" for x in range(4))

            x = i % 4
            y = i // 4
            f.write('{}/name = "tile_{}"\n'.format(tid, dirs))
            f.write('{}/texture = ExtResource( 1 )\n'.format(tid))
            f.write('{}/tex_offset = Vector2( 0, 0 )\n'.format(tid))
            f.write('{}/modulate = Color( 1, 1, 1, 1 )\n'.format(tid))
            f.write('{}/region = Rect2( {}, {}, 32, 32 )\n'.format(tid, x*32, y*32))
            f.write('{}/tile_mode = 0\n'.format(tid))
            f.write('{}/occluder_offset = Vector2( 16, 16 )\n'.format(tid))
            f.write('{}/navigation_offset = Vector2( 16, 16 )\n'.format(tid))
            f.write('{}/shapes = [  ]\n'.format(tid))
            f.write('{}/z_index = 0\n'.format(tid))
            tid += 1
