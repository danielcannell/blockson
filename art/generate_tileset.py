header = """[gd_resource type="TileSet" load_steps=2 format=2]

[ext_resource path="res://art/tileset.png" type="Texture" id=1]

[resource]"""

with open("tileset.tres", "w") as f:
    f.write(header)

    for tid in range(64):
        x = tid % 8
        y = tid // 8
        f.write('{}/name = "tile_{}"\n'.format(tid, tid))
        f.write('{}/texture = ExtResource( 1 )\n'.format(tid))
        f.write('{}/tex_offset = Vector2( 0, 0 )\n'.format(tid))
        f.write('{}/modulate = Color( 1, 1, 1, 1 )\n'.format(tid))
        f.write('{}/region = Rect2( {}, {}, 32, 32 )\n'.format(tid, x*32, y*32))
        f.write('{}/tile_mode = 0\n'.format(tid))
        f.write('{}/occluder_offset = Vector2( 16, 16 )\n'.format(tid))
        f.write('{}/navigation_offset = Vector2( 16, 16 )\n'.format(tid))
        f.write('{}/shapes = [  ]\n'.format(tid))
        f.write('{}/z_index = 0\n'.format(tid))
