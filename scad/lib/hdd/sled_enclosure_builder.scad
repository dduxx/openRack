include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../fasteners/screws.scad>
include <hdd.scad>
include <sled_builder.scad>

DRIVE_ENCLOSURE_SLED_BUFFER = 1;

SATA_CONNECTOR_MOUNT_X = 55;
SATA_CONNECTOR_MOUNT_Y = 15;
SATA_CONNECTOR_Z_BUFFER = 1;
SATA_CONNECTOR_RIGHT_EDGE_HOLE_OFFSET = 10;
SATA_CONNECTOR_HOLE_DISTANCE = 40;
SATA_CONNECTOR_HOLE_Y_OFFSET = 6.5;

module three_point_five_inch_enclosure(
    wall=DRIVE_SLED_WALL,
    rad=DRIVE_SLED_EDGE_FILLET,
    fillet_top = true,
    fillet_bottom = true,
    has_sata_connector = true,
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

    if (has_sata_connector) {
        right(drive_enclosure_width(DRIVE_SLED_WALL) - SATA_CONNECTOR_MOUNT_X - DRIVE_SLED_WALL) {
            back(drive_enclosure_depth()) {
                difference() {
                    union() {
                        cuboid(
                            [
                                SATA_CONNECTOR_MOUNT_X,
                                SATA_CONNECTOR_MOUNT_Y,
                                DRIVE_SLED_WALL
                            ],
                            rounding = rad,
                            edges = [LEFT + BACK, BACK + RIGHT],
                            anchor = BOTTOM + LEFT + FRONT
                        );

                        back(DRIVE_SLED_WALL) up(DRIVE_SLED_WALL) {
                            xrot(90) yrot(90) xflip() {
                                linear_extrude(SATA_CONNECTOR_MOUNT_X)
                                right_triangle(
                                    [DRIVE_SLED_WALL, DRIVE_SLED_WALL - SATA_CONNECTOR_Z_BUFFER]
                                );
                            }
                        }

                        back(DRIVE_SLED_WALL) up(DRIVE_SLED_WALL) {
                            cuboid(
                                [
                                    SATA_CONNECTOR_MOUNT_X,
                                    SATA_CONNECTOR_MOUNT_Y - DRIVE_SLED_WALL,
                                    DRIVE_SLED_WALL - SATA_CONNECTOR_Z_BUFFER
                                ],
                                rounding = rad,
                                edges = [LEFT + BACK, BACK + RIGHT],
                                anchor = BOTTOM + LEFT + FRONT
                            );
                        }

                    }

                    right(SATA_CONNECTOR_MOUNT_X - SATA_CONNECTOR_RIGHT_EDGE_HOLE_OFFSET) {
                        back(SATA_CONNECTOR_HOLE_Y_OFFSET) {
                            screw_cutout(
                                M3_SCREW_RAD,
                                total_length = 2 * DRIVE_SLED_WALL,
                                thread_buffer = 0,
                            );
                        }
                    }

                    right(SATA_CONNECTOR_MOUNT_X -
                        SATA_CONNECTOR_RIGHT_EDGE_HOLE_OFFSET -
                        SATA_CONNECTOR_HOLE_DISTANCE
                    ) {
                        back(SATA_CONNECTOR_HOLE_Y_OFFSET) {
                            screw_cutout(
                                M3_SCREW_RAD,
                                total_length = 2 * DRIVE_SLED_WALL,
                                thread_buffer = 0,
                            );
                        }
                    }
                }
            }
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
