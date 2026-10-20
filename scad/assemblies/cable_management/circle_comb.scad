include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/fasteners/screws.scad>
include <../../lib/fasteners/nuts.scad>

$fn = 200;

CIRCLE_COMB_OUTER_RAD = 20;
CIRCLE_COMB_INNER_RAD = CIRCLE_COMB_OUTER_RAD - 1;

CIRCLE_COMB_END_Z = 1.5;
CIRCLE_COMB_INNER_Z = 14;

CIRCLE_COMB_TAPER_Z = 1.5;

CIRCLE_COMB_CABLE_RAD = 3.5;
CIRCLE_COMB_SLOT_WIDTH = 5;
CIRCLE_COMB_SLOT_LENGTH = CIRCLE_COMB_OUTER_RAD;

NUM_SLOTS = 4;
CABLES_PER_ROW = 4;

SLOT_MOUNT_BLOCK_X = 12.5;
SLOT_MOUNT_BLOCK_Y = 10;
SLOT_MOUNT_OFFSET = 1;

SLOT_MOUNT_VELCRO_PASS_X = SLOT_MOUNT_BLOCK_X;
SLOT_MOUNT_VELCRO_PASS_Y = 2;
SLOT_MOUNT_HEIGHT_OFFSET = 4;
SLOT_MOUNT_NUT_HEIGHT = 3.5;
SLOT_MOUNT_NUT_BUFFER = 0.2;
SLOT_MOUNT_NUT_OFFSET = 5;
HAS_SLOT_MOUNT = false;


difference() {
    union() {
        cylinder(h = CIRCLE_COMB_END_Z, r = CIRCLE_COMB_OUTER_RAD);
        up(CIRCLE_COMB_END_Z) {
            cylinder(h = CIRCLE_COMB_TAPER_Z, r1 = CIRCLE_COMB_OUTER_RAD, r2 = CIRCLE_COMB_INNER_RAD);
        }
        up(CIRCLE_COMB_END_Z + CIRCLE_COMB_TAPER_Z) {
            cylinder(h = CIRCLE_COMB_INNER_Z, r = CIRCLE_COMB_INNER_RAD);
        }
        up(CIRCLE_COMB_END_Z + CIRCLE_COMB_TAPER_Z + CIRCLE_COMB_INNER_Z) {
            cylinder(h = CIRCLE_COMB_TAPER_Z, r1 = CIRCLE_COMB_INNER_RAD, r2 = CIRCLE_COMB_OUTER_RAD);
        }
        up(CIRCLE_COMB_END_Z + (2 * CIRCLE_COMB_TAPER_Z) + CIRCLE_COMB_INNER_Z) {
            cylinder(h = CIRCLE_COMB_END_Z, r = CIRCLE_COMB_OUTER_RAD);
        }
    }

    slot_gap = (
        (2 * CIRCLE_COMB_OUTER_RAD) - ((NUM_SLOTS - 1) * 2 * CIRCLE_COMB_CABLE_RAD)
    ) / NUM_SLOTS;

    slot_trans = (((NUM_SLOTS - 1) * slot_gap) + ((NUM_SLOTS - 1) * CIRCLE_COMB_CABLE_RAD)) / 2;

    fwd(slot_trans) {
        for (i = [0 : NUM_SLOTS - 1]) {
            right(CIRCLE_COMB_SLOT_WIDTH) back((i * CIRCLE_COMB_CABLE_RAD) + (i * slot_gap)) {
                _cable_slot(
                    CIRCLE_COMB_SLOT_WIDTH / 2,
                    CIRCLE_COMB_CABLE_RAD,
                    CIRCLE_COMB_SLOT_LENGTH,
                    CABLES_PER_ROW,
                    (CIRCLE_COMB_END_Z * 2) + (2 * CIRCLE_COMB_TAPER_Z) + CIRCLE_COMB_INNER_Z
                );
            }

            xflip() {
                right(CIRCLE_COMB_SLOT_WIDTH) back((i * CIRCLE_COMB_CABLE_RAD) + (i * slot_gap)) {
                    _cable_slot(
                        CIRCLE_COMB_SLOT_WIDTH / 2,
                        CIRCLE_COMB_CABLE_RAD,
                        CIRCLE_COMB_SLOT_LENGTH,
                        CABLES_PER_ROW,
                        (CIRCLE_COMB_END_Z * 2) + (2 * CIRCLE_COMB_TAPER_Z) + CIRCLE_COMB_INNER_Z
                    );
                }
            }
        }
    }

    left(CIRCLE_COMB_OUTER_RAD) back(CIRCLE_COMB_INNER_RAD) {
        cube([
            CIRCLE_COMB_OUTER_RAD * 2,
            CIRCLE_COMB_OUTER_RAD * 2,
            (CIRCLE_COMB_END_Z * 2) + (2 * CIRCLE_COMB_TAPER_Z) + CIRCLE_COMB_INNER_Z
        ]);
    }

    left(CIRCLE_COMB_OUTER_RAD) fwd((CIRCLE_COMB_OUTER_RAD * 2) + (CIRCLE_COMB_INNER_RAD)) {
        cube([
            CIRCLE_COMB_OUTER_RAD * 2,
            CIRCLE_COMB_OUTER_RAD * 2,
            (CIRCLE_COMB_END_Z * 2) + (2 * CIRCLE_COMB_TAPER_Z) + CIRCLE_COMB_INNER_Z
        ]);
    }
}

if (HAS_SLOT_MOUNT) {
    fwd(CIRCLE_COMB_INNER_RAD - SLOT_MOUNT_OFFSET) {
        difference() {
            cuboid(
                [
                    SLOT_MOUNT_BLOCK_X,
                    SLOT_MOUNT_BLOCK_Y,
                    (CIRCLE_COMB_END_Z * 2) +
                        (2 * CIRCLE_COMB_TAPER_Z) +
                        CIRCLE_COMB_INNER_Z
                ],
                rounding = CIRCLE_COMB_TAPER_Z,
                edges = [LEFT + FRONT, RIGHT + FRONT],
                anchor = BACK + BOTTOM,
            );

            fwd(SLOT_MOUNT_OFFSET) up(SLOT_MOUNT_HEIGHT_OFFSET / 2) {
                cuboid(
                    [
                        SLOT_MOUNT_VELCRO_PASS_X,
                        SLOT_MOUNT_VELCRO_PASS_Y,
                        (CIRCLE_COMB_END_Z * 2) +
                            (2 * CIRCLE_COMB_TAPER_Z) +
                            CIRCLE_COMB_INNER_Z -
                            SLOT_MOUNT_HEIGHT_OFFSET
                    ],
                    anchor = BACK + BOTTOM,
                );
            }

            fwd(SLOT_MOUNT_BLOCK_Y - SLOT_MOUNT_NUT_HEIGHT - 2) {
                up (
                    ((CIRCLE_COMB_END_Z * 2) +
                        (2 * CIRCLE_COMB_TAPER_Z) +
                        CIRCLE_COMB_INNER_Z) / 2
               ) {
                    xrot(90) {
                        nut_cutout(
                            M4_FLAT_TO_FLAT,
                            buffer = SLOT_MOUNT_NUT_BUFFER,
                            nut_height = SLOT_MOUNT_NUT_HEIGHT,
                        );
                    }
                }
            }

            fwd(SLOT_MOUNT_BLOCK_Y - SLOT_MOUNT_NUT_HEIGHT - 2) {
                up (
                    ((CIRCLE_COMB_END_Z * 2) +
                        (2 * CIRCLE_COMB_TAPER_Z) +
                        CIRCLE_COMB_INNER_Z) / 2
                ) {
                    cuboid(
                        [
                            SLOT_MOUNT_BLOCK_X / 2,
                            SLOT_MOUNT_NUT_HEIGHT,
                            M4_FLAT_TO_FLAT + SLOT_MOUNT_NUT_BUFFER
                        ],
                        anchor = RIGHT + BACK

                  );
                }
            }

            fwd(SLOT_MOUNT_OFFSET) {
                up(
                    ((CIRCLE_COMB_END_Z * 2) +
                        (2 * CIRCLE_COMB_TAPER_Z) +
                        CIRCLE_COMB_INNER_Z) / 2
                ) {
                    xrot(90) {
                        screw_cutout(
                            M4_SCREW_RAD,
                            total_length = SLOT_MOUNT_BLOCK_Y - SLOT_MOUNT_OFFSET,
                        );
                    }
                }
            }
        }
    }
}

module _cable_slot(slot_rad, cable_rad, slot_len, num_cables, height) {
    hull() {
        cylinder(
            h = height,
            r = slot_rad
        );

        right(slot_len - (2 * slot_rad)) {
            cylinder(
                h = height,
                r = slot_rad,
            );
        }
    }

    for (i = [0 : num_cables - 1]) {
        right((i * cable_rad * 2) + (i * 0.5)) {
            cylinder(
                h = height,
                r = cable_rad,
            );
        }
    }
}
