include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../fasteners/screws.scad>
include <hdd.scad>

// general sled dimensions
DRIVE_SLED__FLOOR = 4;
DRIVE_SLED__WALL = 2;
DRIVE_SLED__FRONT_DEPTH = 10;

DRIVE_SLED__EDGE_FILLET = 1;


// screw slots
DRIVE_SLED__HDD_SCREW_SLOT_WIDTH = SCREWS__HDD_RAD * 2;
DRIVE_SLED__HDD_SCREW_HEAD_RAD = 8 / 2;

DRIVE_SLED__THREE_POINT_FIVE_SCREW_SLOT_LENGTH = 100;
DRIVE_SLED__TWO_POINT_FIVE_SCREW_SLOT_LENGTH = 80;

// bottom cutouts for material removal
DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD = 30;
DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH = DRIVE_SLED__THREE_POINT_FIVE_SCREW_SLOT_LENGTH;
DRIVE_SLED__TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD = 15;
DRIVE_SLED__TWO_POINT_FIVE_BOTTOM_CUTOUT_LENGTH = DRIVE_SLED__TWO_POINT_FIVE_SCREW_SLOT_LENGTH;

// connector cutouts
DRIVE_SLED__CONNECTOR_CUTOUT_SCALE_FACTOR = 0.8;
DRIVE_SLED__THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH = 80;
DRIVE_SLED__THREE_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH = 10;
DRIVE_SLED__TWO_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH = 55;
DRIVE_SLED__TWO_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH = 10;

// front panel
DRIVE_SLED__THUMB_SLOT_WIDTH = 18;
DRIVE_SLED__VENT_COUNT = 13;
DRIVE_SLED__VENT_WIDTH = 2.5;
DRIVE_SLED__LABEL_WIDTH = 45;
DRIVE_SLED__LABEL_HEIGHT = 12.5;

// Module: three_point_five_inch_drive_sled()
// Description: creates a drive sled sized for a 3.5" hard drive. can optionally include screw
//   mounting slots, a bottom cutout for reduced material usage, a connector cutout at the
//   rear, front vents, and a front label plate.
// Arguments:
//   drive_sled_wall = the wall thickness of the sled. default is `DRIVE_SLED__WALL`
//   drive_sled_floor = the floor thickness of the sled. default is `DRIVE_SLED__FLOOR`
//   drive_sled_front_depth = the depth of the front panel portion. default is
//     `DRIVE_SLED__FRONT_DEPTH`
//   edge_fillet = the corner rounding radius. default is `DRIVE_SLED__EDGE_FILLET`
//   has_bottom_cutout = if true, adds a cutout on the bottom of the sled for material saving.
//     default is false.
//   has_screw_slots = if true, adds slotted screw holes for mounting the drive. default is false.
//   has_connector_cutout = if true, adds a cutout at the rear for SATA/power connectors.
//     default is false.
//   has_vents = if true, adds vertical vent slots to the front panel. default is false.
//   has_label = if true, adds a label area on the front panel. default is false.
module three_point_five_inch_drive_sled(
    drive_sled_wall = DRIVE_SLED__WALL,
    drive_sled_floor = DRIVE_SLED__FLOOR,
    drive_sled_front_depth = DRIVE_SLED__FRONT_DEPTH,
    edge_fillet = DRIVE_SLED__EDGE_FILLET,
    has_bottom_cutout = false,
    has_screw_slots = false,
    has_connector_cutout = false,
    has_vents = false,
    has_label = false
) {
    sled_x = (2 * drive_sled_wall) + HDD__THREE_POINT_FIVE_WIDTH;
    sled_y = HDD__THREE_POINT_FIVE_DEPTH;
    sled_z = drive_sled_floor + HDD__THREE_POINT_FIVE_HEIGHT;

    back(drive_sled_front_depth) {
        difference() {
            // main sled body
            cuboid(
                [sled_x, sled_y, sled_z],
                rounding = edge_fillet,
                anchor=FRONT + LEFT + BOTTOM,
                edges=[
                    RIGHT + BACK,
                    BACK + LEFT,
                    LEFT + TOP,
                    RIGHT + TOP,
                    LEFT + BOTTOM,
                    RIGHT + BOTTOM
                ]
            );


            // 3.5 inch drive negative
            right(drive_sled_wall) up(drive_sled_floor) {
                cube([
                    HDD__THREE_POINT_FIVE_WIDTH,
                    HDD__THREE_POINT_FIVE_DEPTH,
                    HDD__THREE_POINT_FIVE_HEIGHT
                ]);
            }

            // bottom cutout
            if (has_bottom_cutout) {
                right(sled_x / 2) {
                    back(
                        (
                            (sled_y - DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH) / 2
                        ) + DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD
                    ) {
                        _sled_bottom_cutout(
                            DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD,
                            DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH,
                            drive_sled_floor
                        );

                        back(drive_sled_front_depth * 2) up(drive_sled_floor / 2) {
                            cuboid(
                                [
                                    (DRIVE_SLED__THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD * 2) +
                                        (2 * drive_sled_wall),
                                    HDD__THREE_POINT_FIVE_DEPTH,
                                    drive_sled_floor / 2
                                ],
                                rounding = edge_fillet,
                                anchor = BOTTOM,
                                edges = [
                                    BOTTOM + LEFT,
                                    BOTTOM + RIGHT,
                                    BOTTOM + FRONT,
                                ]
                            );
                        }
                    }
                }
            }

            // screw slots
            if (has_screw_slots) {
                screw_mount_y_trans = (
                    HDD__THREE_POINT_FIVE_DEPTH
                ) / 2;

                // left bottom drive hole slot
                right(HDD__BOTTOM_HOLE_EDGE_OFFSET + drive_sled_wall) back(screw_mount_y_trans) {
                    _screw_mount_cutout(
                        drive_sled_floor,
                        DRIVE_SLED__THREE_POINT_FIVE_SCREW_SLOT_LENGTH
                    );
                }

                // right bottom drive hole slot
                right(HDD__THREE_POINT_FIVE_WIDTH - HDD__BOTTOM_HOLE_EDGE_OFFSET + drive_sled_wall) {
                    back(screw_mount_y_trans) {
                        _screw_mount_cutout(
                            drive_sled_floor,
                            DRIVE_SLED__THREE_POINT_FIVE_SCREW_SLOT_LENGTH
                        );
                    }
                }
            }

            // connector cutout
            if (has_connector_cutout) {
                right(
                    HDD__THREE_POINT_FIVE_WIDTH - DRIVE_SLED__THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH +
                        drive_sled_wall
                ) {
                    back(HDD__THREE_POINT_FIVE_DEPTH) {
                        _connector_cutout(
                            drive_sled_floor,
                            DRIVE_SLED__THREE_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH,
                            DRIVE_SLED__THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH,
                            DRIVE_SLED__CONNECTOR_CUTOUT_SCALE_FACTOR,
                            edge_fillet,
                        );
                    }
                }
            }
        }
    }
    _drive_sled_front(
        drive_sled_front_depth,
        drive_sled_wall,
        drive_sled_floor,
        edge_fillet,
        has_vents = has_vents,
        has_label = has_label
    );
}

// Module: three_point_five_to_two_point_five_inch_drive_sled()
// Description: creates a drive sled adapter that fits a 2.5" drive into a 3.5" sled form
//   factor. embeds a 2.5" adapter cavity into the standard 3.5" sled body. supports the same
//   options as `three_point_five_inch_drive_sled`, with bottom cutouts, screw slots, and
//   connector cutout options applied to the 2.5" adapter portion.
// Arguments:
//   drive_sled_wall = the wall thickness of the sled. default is `DRIVE_SLED__WALL`
//   drive_sled_floor = the floor thickness of the sled. default is `DRIVE_SLED__FLOOR`
//   drive_sled_front_depth = the depth of the front panel portion. default is
//     `DRIVE_SLED__FRONT_DEPTH`
//   edge_fillet = the corner rounding radius. default is `DRIVE_SLED__EDGE_FILLET`
//   has_bottom_cutout = if true, adds a cutout on the bottom of the 2.5" adapter. default is false.
//   has_screw_slots = if true, adds slotted screw holes for mounting the 2.5" drive. default is
//     false.
//   has_connector_cutout = if true, adds a cutout at the rear for SATA/power connectors on the
//     2.5" drive. default is false.
//   has_vents = if true, adds vertical vent slots to the front panel. default is false.
//   has_label = if true, adds a label area on the front panel. default is false.
module three_point_five_to_two_point_five_inch_drive_sled(
    drive_sled_wall = DRIVE_SLED__WALL,
    drive_sled_floor = DRIVE_SLED__FLOOR,
    drive_sled_front_depth = DRIVE_SLED__FRONT_DEPTH,
    edge_fillet = DRIVE_SLED__EDGE_FILLET,
    has_bottom_cutout = false,
    has_screw_slots = false,
    has_connector_cutout = false,
    has_vents = false,
    has_label = false
) {
    sled_x = (2 * drive_sled_wall) + HDD__THREE_POINT_FIVE_WIDTH;
    sled_y = HDD__THREE_POINT_FIVE_DEPTH;
    sled_z = drive_sled_floor + HDD__THREE_POINT_FIVE_HEIGHT;

    adapter_x = (2 * drive_sled_wall) + HDD__TWO_POINT_FIVE_WIDTH;
    adapter_y = drive_sled_wall + HDD__TWO_POINT_FIVE_DEPTH;
    adapter_z = drive_sled_floor + HDD__TWO_POINT_FIVE_HEIGHT;

    difference() {
        three_point_five_inch_drive_sled(
            drive_sled_wall = drive_sled_wall,
            drive_sled_floor = drive_sled_floor,
            drive_sled_front_depth = drive_sled_front_depth,
            edge_fillet = edge_fillet,
            has_vents = has_vents,
            has_label = has_label,
            // these are false because the above passed in ones refer to the 2.5 adapter cutouts
            // they get passed to the 2.5 adapter later on
            has_bottom_cutout = false,
            has_screw_slots = false,
            has_connector_cutout = false,
        );

        right(sled_x - adapter_x) {
            back(drive_sled_front_depth + sled_y - adapter_y) {
                _two_point_five_adapter_base([adapter_x, adapter_y, adapter_z], edge_fillet);
            }
        }
    }

    right(sled_x - adapter_x) {
        back(drive_sled_front_depth + sled_y - adapter_y) {
            _two_point_five_adapter(
                [adapter_x, adapter_y, adapter_z],
                edge_fillet,
                has_bottom_cutout = has_bottom_cutout,
                has_screw_slots = has_screw_slots,
                has_connector_cutout = has_connector_cutout
            );
        }
    }
}

module _drive_sled_front(
    drive_sled_front_depth,
    drive_sled_wall,
    drive_sled_floor,
    fillet,
    has_vents = false,
    has_label = false
) {
    x = (2 * drive_sled_wall) + HDD__THREE_POINT_FIVE_WIDTH;
    y = drive_sled_front_depth;
    z = drive_sled_floor + HDD__THREE_POINT_FIVE_HEIGHT;

    difference() {
        cuboid(
            [x, y, z],
            rounding = fillet,
            edges = [LEFT + TOP, TOP + RIGHT, RIGHT + BOTTOM, BOTTOM + LEFT],
            anchor = BOTTOM + LEFT + FRONT
        );

        right((DRIVE_SLED__THUMB_SLOT_WIDTH / 2) + drive_sled_wall) up(z/2) {
            cuboid(
                [
                    DRIVE_SLED__THUMB_SLOT_WIDTH,
                    drive_sled_front_depth,
                    DRIVE_SLED__THUMB_SLOT_WIDTH,
                ],
                rounding = fillet,
                edges = [
                    LEFT + TOP,
                    TOP + RIGHT,
                    RIGHT + BOTTOM,
                    BOTTOM + LEFT,
                ],
                anchor = FRONT
            );
        }

        right(x - (DRIVE_SLED__THUMB_SLOT_WIDTH / 2) - drive_sled_wall) up(z/2) {
            cuboid(
                [
                    DRIVE_SLED__THUMB_SLOT_WIDTH,
                    drive_sled_front_depth,
                    DRIVE_SLED__THUMB_SLOT_WIDTH,
                ],
                rounding = fillet,
                edges = [
                    LEFT + TOP,
                    TOP + RIGHT,
                    RIGHT + BOTTOM,
                    BOTTOM + LEFT,
                ],
                anchor = FRONT
            );
        }

        if (has_vents) {
            right(x / 2) up(drive_sled_wall) {
                _vent_slot(DRIVE_SLED__VENT_WIDTH, z - (2 * drive_sled_wall), drive_sled_front_depth);

                for (i = [1 : (DRIVE_SLED__VENT_COUNT - 1) / 2]) {
                    right((i * DRIVE_SLED__VENT_WIDTH * 2)) {
                        _vent_slot(DRIVE_SLED__VENT_WIDTH, z - (2 * drive_sled_wall), drive_sled_front_depth);
                    }
                    left((i * DRIVE_SLED__VENT_WIDTH * 2)) {
                        _vent_slot(DRIVE_SLED__VENT_WIDTH, z - (2 * drive_sled_wall), drive_sled_front_depth);
                    }
                }
            }
        }
    }

    if (has_label) {
        right(x / 2) up(z / 2) {
            cuboid([DRIVE_SLED__LABEL_WIDTH, drive_sled_wall, DRIVE_SLED__LABEL_HEIGHT], anchor=FRONT);
        }
    }


    right((DRIVE_SLED__THUMB_SLOT_WIDTH) + drive_sled_wall) up(z/2) {
        cuboid(
            [
                DRIVE_SLED__THUMB_SLOT_WIDTH / 5,
                drive_sled_front_depth / 4,
                DRIVE_SLED__THUMB_SLOT_WIDTH,
            ],
            rounding = fillet,
            edges = [
                FRONT + LEFT,
                TOP + RIGHT,
                RIGHT + BOTTOM,
            ],
            anchor = FRONT + RIGHT
        );
    }

    right(x - (DRIVE_SLED__THUMB_SLOT_WIDTH) - drive_sled_wall) up(z/2) {
        cuboid(
            [
                DRIVE_SLED__THUMB_SLOT_WIDTH / 5,
                drive_sled_front_depth / 4,
                DRIVE_SLED__THUMB_SLOT_WIDTH,
            ],
            rounding = fillet,
            edges = [
                FRONT + RIGHT,
                LEFT + TOP,
                BOTTOM + LEFT,
            ],
            anchor = FRONT + LEFT
        );
    }
}

module _vent_slot(vent_width, vent_height, vent_depth) {
    back(vent_depth) up(vent_width / 2) {
        xrot(90) {
            hull() {
                cylinder(h=vent_depth, r=vent_width/2);
                back(vent_height - vent_width) {
                    cylinder(h=vent_depth, r=vent_width/2);
                }
            }
        }
    }
}

module _sled_bottom_cutout(bottom_cutout_rad, bottom_cutout_length, thickness) {
    hull() {
        cylinder(h=thickness, r=bottom_cutout_rad);

        back(bottom_cutout_length - (2 * bottom_cutout_rad)) {
            cylinder(h=thickness, r=bottom_cutout_rad);
        }
    }
}

module _screw_mount_cutout(height, screw_mount_cutout_length) {
    zrot(90) {
        screw_slot(
            DRIVE_SLED__HDD_SCREW_SLOT_WIDTH/2,
            screw_mount_cutout_length,
            countersink_rad = DRIVE_SLED__HDD_SCREW_HEAD_RAD,
            countersink_depth = height - 1,
            total_length = height,
            thread_buffer = 0,
        );
    }
}

module _connector_cutout(
    height,
    connector_cutout_depth,
    connector_cutout_width,
    connector_cutout_scale_factor,
    edge_fillet,
) {
    yflip() {
        linear_extrude(height) {
            trapezoid(
                h = connector_cutout_depth,
                w1 = connector_cutout_width,
                w2 = connector_cutout_width * connector_cutout_scale_factor,
                anchor= BOTTOM + LEFT,
                rounding = [edge_fillet, edge_fillet, 0, 0],
            );
        }
    }
}

module _two_point_five_adapter_base(xyz, fillet) {
    cuboid(
        xyz,
        rounding = fillet,
        anchor=FRONT + LEFT + BOTTOM,
        edges=[RIGHT + BACK, BACK + LEFT, LEFT + FRONT]
    );
}

module _two_point_five_adapter(
    xyz,
    fillet,
    has_bottom_cutout = false,
    has_screw_slots = false,
    has_connector_cutout = false
) {
    x_trans = (xyz[0] - HDD__TWO_POINT_FIVE_WIDTH)  / 2;
    y_trans = xyz[1] - HDD__TWO_POINT_FIVE_DEPTH;
    z_trans = xyz[2] - HDD__TWO_POINT_FIVE_HEIGHT;

    difference() {
        _two_point_five_adapter_base(xyz, fillet);

        // drive negative
        right(x_trans) back(y_trans) up(z_trans) {
            cube([
                HDD__TWO_POINT_FIVE_WIDTH,
                HDD__TWO_POINT_FIVE_DEPTH,
                HDD__TWO_POINT_FIVE_HEIGHT
            ]);
        }

        if (has_screw_slots) {
            // left screw hole cutout
            right(x_trans + HDD__BOTTOM_HOLE_EDGE_OFFSET) {
                back(xyz[1] / 2) {
                    _screw_mount_cutout(z_trans, DRIVE_SLED__TWO_POINT_FIVE_SCREW_SLOT_LENGTH);
                }
            }

            // right screw hole cutout
            right(xyz[0] - HDD__BOTTOM_HOLE_EDGE_OFFSET - x_trans) {
                back(xyz[1] / 2) {
                    _screw_mount_cutout(z_trans, DRIVE_SLED__TWO_POINT_FIVE_SCREW_SLOT_LENGTH);
                }
            }
        }

        // connector cutout
        if (has_connector_cutout) {
            right(HDD__TWO_POINT_FIVE_WIDTH - DRIVE_SLED__TWO_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH + x_trans) {
                back(HDD__TWO_POINT_FIVE_DEPTH + y_trans) {
                    _connector_cutout(
                        z_trans,
                        DRIVE_SLED__TWO_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH,
                        DRIVE_SLED__TWO_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH,
                        DRIVE_SLED__CONNECTOR_CUTOUT_SCALE_FACTOR,
                        fillet,
                    );
                }
            }
        }


        // bottom cutout
        if (has_bottom_cutout) {
            right(xyz[0] / 2) back(y_trans + (DRIVE_SLED__TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD * 2) - 5) {
                _sled_bottom_cutout(
                    DRIVE_SLED__TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD,
                    DRIVE_SLED__TWO_POINT_FIVE_BOTTOM_CUTOUT_LENGTH,
                    xyz[2] - HDD__TWO_POINT_FIVE_HEIGHT,
                );
            }
        }
    }
}
