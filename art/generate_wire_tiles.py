from PIL import Image, ImageDraw

cable_tray_hub = Image.open("cable_tray_hub.png")
cable_tray_straight = Image.open("cable_tray_straight.png")
cable_tray_edge = Image.open("cable_tray_edge.png")

# data, power
wire_offsets = [11, 15, 19]
wire_colors = [(34, 0, 255, 255), (255, 216, 0, 255), (255, 0, 0, 255)]

main = Image.new("RGBA", (32 * 16, 32 * 16), (255,255,255,0))
main.putalpha(0)

for j in range(2 ** len(wire_offsets)):
    # data, power
    wires = [j & 1 > 0, j & 2 > 0, j & 4 > 0]

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

        for k in range(len(wires)):
            if wires[k]:
                off = wire_offsets[k]
                col = wire_colors[k]
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

        main.paste(im, (i*32, j*32), im)

main.save("cabletray.png")
