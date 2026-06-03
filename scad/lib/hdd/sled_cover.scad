include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../const/hdd.scad>
include <sled.scad>

SLED_COVER_WIDTH = (DRIVE_SLED_WALL * 2) + THREE_POINT_FIVE_HDD_WIDTH;
SLED_COVER_DEPTH = DRIVE_SLED_LATCH_DEPTH;
SLED_COVER_HEIGHT = DRIVE_SLED_WALL + THREE_POINT_FIVE_HDD_HEIGHT;

THUMB_SLOT_WIDTH = 10;

BUFFER = 1;

VENT_COUNT = 11;
VENT_WIDTH = 2.5;
VENT_LENGTH = SLED_COVER_HEIGHT - (2 * DRIVE_SLED_WALL);

LABEL_HEIGHT = 15;
LABEL_WIDTH = 47;

module sled_cover(fillet=1) {
    difference() {
        cuboid(
            [SLED_COVER_WIDTH, SLED_COVER_DEPTH, SLED_COVER_HEIGHT],
            rounding=fillet,
            anchor=FRONT + LEFT + BOTTOM,
            edges=[LEFT + TOP, TOP + RIGHT, RIGHT + BOTTOM, BOTTOM + LEFT]
        );

        // left hook slot
        right(DRIVE_SLED_LATCH_EDGE_OFFSET + DRIVE_SLED_LATCH_HOOK) {
            up(DRIVE_SLED_WALL - (BUFFER/2)) {
                _latch_L_slot(fillet);
            }
        }

        // right hook slot 
        right(SLED_COVER_WIDTH - DRIVE_SLED_LATCH_EDGE_OFFSET -DRIVE_SLED_LATCH_HOOK) {
            up(DRIVE_SLED_WALL - (BUFFER/2)) {
                xflip() {
                    _latch_L_slot(fillet);
                }
            }
        }


        // left thumb slot
        right(DRIVE_SLED_LATCH_EDGE_OFFSET + DRIVE_SLED_LATCH_HOOK) {
            up(DRIVE_SLED_WALL - (BUFFER / 2)) {
                _thumb_slot(fillet);
            }
        }

        // right thumb slot
        right(SLED_COVER_WIDTH - DRIVE_SLED_LATCH_EDGE_OFFSET - DRIVE_SLED_LATCH_HOOK) {
            up(DRIVE_SLED_WALL - (BUFFER / 2)) {
                xflip() {
                    _thumb_slot(fillet);
                }
            }
        }

        right(SLED_COVER_WIDTH/2) up (DRIVE_SLED_WALL) {
            _vent_hole();

            for (i = [1 : (VENT_COUNT - 1) / 2]) {
                left(i * 2 * VENT_WIDTH) {
                    _vent_hole();
                }

                right(i * 2 * VENT_WIDTH) {
                    _vent_hole();
                }
            }
        }
    }

    right(SLED_COVER_WIDTH/2) up(SLED_COVER_HEIGHT/2) {
        cuboid(
            [LABEL_WIDTH, DRIVE_SLED_WALL, LABEL_HEIGHT],
            rounding=fillet,
            edges = [],
            anchor = FRONT + CENTER
        );
    }
}

module _thumb_slot(fillet) {
    cuboid(
        [THUMB_SLOT_WIDTH, SLED_COVER_DEPTH, DRIVE_SLED_LATCH_HEIGHT + BUFFER],
        anchor=BOTTOM + LEFT + FRONT,
        edges=[TOP + RIGHT, RIGHT + BOTTOM],
        rounding=fillet
    );
}

module _latch_L_slot(fillet) {
    front_x = (2 * DRIVE_SLED_LATCH_HOOK) + BUFFER;
    front_y = DRIVE_SLED_LATCH_HOOK + BUFFER;
    front_z = DRIVE_SLED_LATCH_HEIGHT + BUFFER;

    cuboid(
        [front_x, front_y, front_z],
        rounding=fillet,
        edges=[LEFT + TOP, BOTTOM + LEFT],
        anchor=BOTTOM + RIGHT + FRONT
    );

    back_x = DRIVE_SLED_WALL + DRIVE_SLED_LATCH_HOOK + BUFFER;
    back_y = DRIVE_SLED_LATCH_DEPTH;
    back_z = DRIVE_SLED_LATCH_HEIGHT + BUFFER;
    left(DRIVE_SLED_WALL + BUFFER) {
        cuboid(
            [back_x, back_y, back_z],
            rounding=fillet,
            edges=[LEFT + TOP, BOTTOM + LEFT],
            anchor=BOTTOM + RIGHT + FRONT
        );
    }
}

module _vent_hole() {
    back(SLED_COVER_DEPTH) up(VENT_WIDTH/2) {
        xrot(90) {
            hull() {
                cylinder(r=VENT_WIDTH/2, h=SLED_COVER_DEPTH);

                back(VENT_LENGTH - VENT_WIDTH) {
                    cylinder(r=VENT_WIDTH/2, h=SLED_COVER_DEPTH);
                }
            }
        }
    }
}
