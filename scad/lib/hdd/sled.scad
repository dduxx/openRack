include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../const/hdd.scad>
include <../const/standard.scad>

$fn = FACET_NUMBER;

// general sled dimensions
DRIVE_SLED_WALL = 1.5;
DRIVE_SLED_LATCH_DEPTH = 20;
DRIVE_SLED_LATCH_EDGE_OFFSET = 8;
DRIVE_SLED_LATCH_HOOK = 4;
DRIVE_SLED_LATCH_HEIGHT = (DRIVE_SLED_WALL + THREE_POINT_FIVE_HDD_HEIGHT) - (2 * DRIVE_SLED_WALL);

// screw slots
HDD_SCREW_SLOT_WIDTH = HDD_SCREW_RAD * 2;
THREE_POINT_FIVE_SCREW_SLOT_LENGTH = 100;
TWO_POINT_FIVE_SCREW_SLOT_LENGTH = 75;

// bottom cutouts for material removal
THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD = 30;
THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH = THREE_POINT_FIVE_SCREW_SLOT_LENGTH;
TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD = 15;
TWO_POINT_FIVE_BOTTOM_CUTOUT_LENGTH = TWO_POINT_FIVE_SCREW_SLOT_LENGTH;

// connector cutouts
CONNECTOR_COUTOUT_SCALE_FACTOR = 0.8;
THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH = 80;
THREE_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH = 10;
TWO_POINT_FIVE_CONNECTOR_COUTOUT_WIDTH = 55;
TWO_POINT_FIVE_CONNECTOR_COUTOUT_DEPTH = 10;

module three_point_five_inch_drive_sled(
    two_point_five_adapter = false,
    edge_fillet = 1,
) {
    x = (2 * DRIVE_SLED_WALL) + THREE_POINT_FIVE_HDD_WIDTH;
    y = THREE_POINT_FIVE_HDD_DEPTH;
    z = DRIVE_SLED_WALL + THREE_POINT_FIVE_HDD_HEIGHT;


    adapter_x = (2 * DRIVE_SLED_WALL) + TWO_POINT_FIVE_HDD_WIDTH;
    adapter_y = DRIVE_SLED_WALL + TWO_POINT_FIVE_HDD_DEPTH;
    adapter_z = DRIVE_SLED_WALL + TWO_POINT_FIVE_HDD_HEIGHT;

    back(DRIVE_SLED_LATCH_DEPTH + DRIVE_SLED_WALL) {
        difference() {
            union() {
                // main sled body
                cuboid(
                    [x, y, z],
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

                // left side latch
                fwd(DRIVE_SLED_LATCH_DEPTH + DRIVE_SLED_WALL) up(DRIVE_SLED_WALL) {
                    _sled_latch(
                        DRIVE_SLED_LATCH_HEIGHT, 
                        edge_fillet
                    );
                }

                // right side latch
                right(x) {
                    xflip(){
                        fwd(DRIVE_SLED_LATCH_DEPTH + DRIVE_SLED_WALL) up(DRIVE_SLED_WALL) {
                            _sled_latch(
                                DRIVE_SLED_LATCH_HEIGHT, 
                                edge_fillet
                            );
                        }
                    }
                }
            }

            // 3.5 inch drive negative
            right(DRIVE_SLED_WALL) up (DRIVE_SLED_WALL) {
                cube([
                    THREE_POINT_FIVE_HDD_WIDTH,
                    THREE_POINT_FIVE_HDD_DEPTH,
                    THREE_POINT_FIVE_HDD_HEIGHT
                ]);
            }

            if (two_point_five_adapter) {
                right(x - adapter_x) back(y - adapter_y) {
                    _two_point_five_adapter_base([adapter_x, adapter_y, adapter_z], edge_fillet);
                }
            } else {
                // bottom cutout
                right(x/2) {
                    back(
                        (
                            (y - THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH) / 2
                        ) + THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD
                    ) {
                        _sled_bottom_cutout(
                            THREE_POINT_FIVE_BOTTOM_CUTOUT_RAD, 
                            THREE_POINT_FIVE_BOTTOM_CUTOUT_LENGTH
                        );
                    }
                } 

                screw_mount_y_trans = (
                    THREE_POINT_FIVE_HDD_DEPTH - THREE_POINT_FIVE_SCREW_SLOT_LENGTH
                ) / 2;

                // left bottom drive hole slot
                right(HDD_BOTTOM_HOLE_EDGE_OFFSET + DRIVE_SLED_WALL) back(screw_mount_y_trans) {
                    _screw_mount_cutout(
                        DRIVE_SLED_WALL, 
                        THREE_POINT_FIVE_SCREW_SLOT_LENGTH
                    );
                }

                // right bottom drive hole slot
                right(THREE_POINT_FIVE_HDD_WIDTH - HDD_BOTTOM_HOLE_EDGE_OFFSET + DRIVE_SLED_WALL) {
                    back(screw_mount_y_trans) {
                        _screw_mount_cutout(
                            DRIVE_SLED_WALL, 
                            THREE_POINT_FIVE_SCREW_SLOT_LENGTH
                        );
                    }
                }

                // connector cutout
                right(
                    THREE_POINT_FIVE_HDD_WIDTH - THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH + 
                        DRIVE_SLED_WALL
                ) {
                    back(THREE_POINT_FIVE_HDD_DEPTH) {
                        _connector_cutout(
                            DRIVE_SLED_WALL, 
                            THREE_POINT_FIVE_CONNECTOR_CUTOUT_DEPTH, 
                            THREE_POINT_FIVE_CONNECTOR_CUTOUT_WIDTH, 
                            CONNECTOR_COUTOUT_SCALE_FACTOR,
                            edge_fillet,
                        );
                    }
                }
            }
        }

        if (two_point_five_adapter) {
            right(x - adapter_x) back(y - adapter_y) {
                _two_point_five_adapter([adapter_x, adapter_y, adapter_z], edge_fillet);
            }
        }
    }
}

module _sled_latch(
    height, 
    edge_fillet
) {
    right(DRIVE_SLED_LATCH_EDGE_OFFSET){
        cuboid(
            [DRIVE_SLED_LATCH_HOOK, DRIVE_SLED_LATCH_HOOK, height],
            anchor=FRONT + LEFT + BOTTOM,
            edges=[RIGHT + BACK, RIGHT + FRONT],
            rounding = edge_fillet
        );
    }
    right(DRIVE_SLED_LATCH_EDGE_OFFSET - DRIVE_SLED_WALL) {
        cuboid(
            [DRIVE_SLED_WALL, DRIVE_SLED_LATCH_DEPTH, height],
            anchor=FRONT + LEFT + BOTTOM,
            edges=[FRONT + LEFT],
            rounding = edge_fillet
        );
    }
    back(DRIVE_SLED_LATCH_DEPTH) {
        cuboid(
            [DRIVE_SLED_LATCH_EDGE_OFFSET, DRIVE_SLED_WALL, height],
            anchor=FRONT + LEFT + BOTTOM,
            edges=[LEFT + FRONT, RIGHT + BACK],
            rounding = edge_fillet
        );
    }
}

module _sled_bottom_cutout(bottom_cutout_rad, bottom_cutout_length) {
    hull() {
        cylinder(h=DRIVE_SLED_WALL, r=bottom_cutout_rad);

        back(bottom_cutout_length - (2 * bottom_cutout_rad)) {
            cylinder(h=DRIVE_SLED_WALL, r=bottom_cutout_rad);
        }
    }
}

module _screw_mount_cutout(height, screw_mount_cutout_length) {
    hull() {
        cylinder(h=height, r=HDD_SCREW_SLOT_WIDTH/2);
        back(screw_mount_cutout_length) {
            cylinder(h=height, r=HDD_SCREW_SLOT_WIDTH/2);
        }
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

module _two_point_five_adapter(xyz, fillet) {
    x_trans = (xyz[0] - TWO_POINT_FIVE_HDD_WIDTH)  / 2;
    y_trans = xyz[1] - TWO_POINT_FIVE_HDD_DEPTH;
    z_trans = xyz[2] - TWO_POINT_FIVE_HDD_HEIGHT;

    difference() {
        _two_point_five_adapter_base(xyz, fillet);

        // drive negative
        right(x_trans) back(y_trans) up(z_trans) {
            cube([
                TWO_POINT_FIVE_HDD_WIDTH, 
                TWO_POINT_FIVE_HDD_DEPTH, 
                TWO_POINT_FIVE_HDD_HEIGHT
            ]);
        }

        // left screw hole cutout
        right(x_trans + HDD_BOTTOM_HOLE_EDGE_OFFSET) {
            back((xyz[1] - TWO_POINT_FIVE_SCREW_SLOT_LENGTH)/2) {
                _screw_mount_cutout(z_trans, TWO_POINT_FIVE_SCREW_SLOT_LENGTH);
            }
        }

        // right screw hole cutout
        right(xyz[0] - HDD_BOTTOM_HOLE_EDGE_OFFSET - x_trans) {
            back((xyz[1] - TWO_POINT_FIVE_SCREW_SLOT_LENGTH)/2) {
                _screw_mount_cutout(z_trans, TWO_POINT_FIVE_SCREW_SLOT_LENGTH);
            }
        }

        // connector cutout
        right(TWO_POINT_FIVE_HDD_WIDTH - TWO_POINT_FIVE_CONNECTOR_COUTOUT_WIDTH + x_trans) {
            back(TWO_POINT_FIVE_HDD_DEPTH + y_trans) {
                _connector_cutout(
                    z_trans, 
                    TWO_POINT_FIVE_CONNECTOR_COUTOUT_DEPTH, 
                    TWO_POINT_FIVE_CONNECTOR_COUTOUT_WIDTH, 
                    CONNECTOR_COUTOUT_SCALE_FACTOR,
                    fillet,
                );
            }
        }

        // bottom cutout
        right(xyz[0]/2) back(y_trans + (TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD * 2)) {
            #_sled_bottom_cutout(
                TWO_POINT_FIVE_BOTTOM_CUTOUT_RAD, 
                TWO_POINT_FIVE_BOTTOM_CUTOUT_LENGTH
            );
        }
    }
}
