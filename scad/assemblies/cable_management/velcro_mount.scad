include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/fasteners/screws.scad>

$fn = 100;

VELCRO_MOUNT_FILLET = 2;
VELCRO_MOUNT_COUTERSINK_RAD = 5;

VELCRO_MOUNT_Z = 10;
VELCRO_MOUNT_BASE_Z = 3;

VELCRO_MOUNT_TOP = 20;
VELCRO_MOUNT_BOTTOM = 26;

VELCRO_SLOT_WIDTH = 14;
VELCRO_SLOT_HEIGHT = 5;
VELCRO_SLOT_INNER = 15.5;

difference() {
    hull() {
        linear_extrude(VELCRO_MOUNT_BASE_Z) {
            minkowski() {
                square(VELCRO_MOUNT_BOTTOM - (2 * VELCRO_MOUNT_FILLET), center=true);

                circle(VELCRO_MOUNT_FILLET);
            }
        }

        linear_extrude(VELCRO_MOUNT_Z) {
            minkowski() {
                square(VELCRO_MOUNT_TOP - (2 * VELCRO_MOUNT_FILLET), center=true);

                circle(VELCRO_MOUNT_FILLET);
            }
        }
    }

    left(VELCRO_MOUNT_BOTTOM / 2) fwd(VELCRO_SLOT_WIDTH / 2) up(VELCRO_MOUNT_BASE_Z) {
        cube([VELCRO_MOUNT_BOTTOM, VELCRO_SLOT_WIDTH, VELCRO_SLOT_HEIGHT]);
    }

    left(VELCRO_SLOT_WIDTH / 2) fwd(VELCRO_MOUNT_BOTTOM / 2) up(VELCRO_MOUNT_BASE_Z) {
        cube([VELCRO_SLOT_WIDTH, VELCRO_MOUNT_BOTTOM, VELCRO_SLOT_HEIGHT]);
    }

    left((VELCRO_SLOT_INNER - (VELCRO_MOUNT_FILLET * 2)) / 2) {
        fwd((VELCRO_SLOT_INNER - (VELCRO_MOUNT_FILLET * 2)) / 2) {
            up(VELCRO_MOUNT_BASE_Z) {
                linear_extrude(VELCRO_MOUNT_Z - VELCRO_MOUNT_BASE_Z) {
                    minkowski() {
                        square(VELCRO_SLOT_INNER - (VELCRO_MOUNT_FILLET * 2));

                        circle(VELCRO_MOUNT_FILLET);
                    }
                }
            }
        }
    }

    up(VELCRO_MOUNT_BASE_Z) {
        zflip() {
            screw_cutout(
                screw_rad = TEN_THIRTY_TWO_SCREW_RAD,
                countersink_rad = VELCRO_MOUNT_COUTERSINK_RAD,
                countersink_depth = VELCRO_MOUNT_BASE_Z / 2,
                total_length = VELCRO_MOUNT_BASE_Z,
                thread_buffer = 0.2
            );
        }
    }
}
