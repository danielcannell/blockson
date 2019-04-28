from PIL import Image, ImageDraw

status_electric = Image.open("status_electric.png")
status_network = Image.open("status_network.png")
status_threephase = Image.open("status_threephase.png")

TILE_SIZE = 32

### GENERATE TILESET IMAGES
main = Image.new("RGBA", (TILE_SIZE * 8, TILE_SIZE), (255,255,255,0))
main.putalpha(0)

for i in range(2**3):
    which = [i & 1 > 0, i & 2 > 0, i & 4 > 0]

    im = Image.new("RGBA", (TILE_SIZE, TILE_SIZE), (255,255,255,0))
    draw = ImageDraw.Draw(im)

    howmany = which[0] + which[1] + which[2]
    if howmany == 1:
        pos = (4,4)
        if which[0]:
            im.paste(status_electric, pos, status_electric)
        if which[1]:
            im.paste(status_network, pos, status_network)
        if which[2]:
            im.paste(status_threephase, pos, status_threephase)
    elif howmany == 2:
        pos1 = (-3,4)
        pos2 = (12,4)
        if not which[0]:
            im.paste(status_network, pos1, status_network)
            im.paste(status_threephase, pos2, status_threephase)
        if not which[1]:
            im.paste(status_electric, pos1, status_electric)
            im.paste(status_threephase, pos2, status_threephase)
        if not which[2]:
            im.paste(status_electric, pos1, status_electric)
            im.paste(status_network, pos2, status_network)
    elif howmany == 3:
        im.paste(status_electric, (-3,-2), status_electric)
        im.paste(status_network, (12,-2), status_network)
        im.paste(status_threephase, (6,9), status_threephase)

    main.paste(im, (i*TILE_SIZE, 0), im)

main.save("status_tiles.png")