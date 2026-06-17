include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../fasteners/screws.scad>
include <hdd.scad>
include <sled_builder.scad>

DRIVE_ENCLOSURE_SLED_BUFFER = 0.5;

module three_point_five_inch_enclosure(
    wall=DRIVE_SLED_WALL,
    rad=DRIVE_SLED_EDGE_FILLET,
    fillet_top = true,
    fillet_bottom = true,
    sled_buffer = DRIVE_ENCLOSURE_SLED_BUFFER,
) {
    difference() {
        _three_point_five_inch_enclosure_base(
            wall,
            rad,
            fillet_top,
            fillet_bottom
        );

        x_trans = (drive_enclosure_width(wall) - drive_sled_width(wall, sled_buffer)) / 2;
        z_trans = (drive_enclosure_height(wall) - drive_sled_height(wall, sled_buffer)) / 2;

        right(x_trans) up(z_trans) {
            _sled_negative(wall, rad, sled_buffer);
        }
    }
}

module _three_point_five_inch_enclosure_base(
    wall,
    rad,
    fillet_top,
    fillet_bottom
) {
    x = drive_enclosure_width(wall);
    y = drive_enclosure_depth();
    z = drive_enclosure_height(wall);

    top_edge = fillet_top ? [LEFT + TOP, RIGHT + TOP] : [];
    bot_edge = fillet_bottom ? [RIGHT + BOTTOM, LEFT + BOTTOM] : [];

    cuboid(
        [x, y, z],
        rounding = rad,
        edges = concat(top_edge, bot_edge),
        anchor = BOTTOM + FRONT + LEFT
    );
}

module _sled_negative(
    wall,
    rad,
    buffer = 0.5
) {
    x = drive_sled_width(wall, buffer);
    y = drive_enclosure_depth();
    z = drive_sled_height(wall, buffer);
    cuboid(
        [x, y, z],
        rounding = rad,
        edges = [
            BOTTOM + LEFT,
            LEFT + TOP,
            TOP + RIGHT,
            RIGHT + BOTTOM
        ],
        anchor = BOTTOM + FRONT + LEFT
    );
}

function drive_enclosure_width(wall) = (2 * wall) + drive_sled_width(wall);

function drive_enclosure_depth() = THREE_POINT_FIVE_HDD_DEPTH + DRIVE_SLED_FRONT_DEPTH;

function drive_enclosure_height(wall) = (2 * wall) + drive_sled_height(wall);

function drive_sled_width(wall, buffer = 0) = (2 * wall) + THREE_POINT_FIVE_HDD_WIDTH + buffer;

function drive_sled_height(wall, buffer = 0) = wall + THREE_POINT_FIVE_HDD_HEIGHT + buffer;
