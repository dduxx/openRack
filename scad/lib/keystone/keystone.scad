include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

KEYSTONE_OUTER_X = 18;
KEYSTONE_OUTER_Y = 10;
KEYSTONE_OUTER_Z = 25;

KEYSTONE_OUTER_TOP_OFFSET = 4;

KEYSTONE_OUTER_RAD = 1.5;

KEYSTONE_INNER_X = 15;
KEYSTONE_INNER_Y = KEYSTONE_OUTER_Y;
KEYSTONE_INNER_Z = 22;

KEYSTONE_LATCH_DEPTH = 1.5;
KEYSTONE_LATCH_HEIGHT = 1.3;

KEYSTONE_FRONT_WALL_THICKNESS = 1;
KEYSTONE_FRONT_WALL_TOP_HEIGHT = 3.7;
KEYSTONE_FRONT_WALL_BOTTOM_HEIGHT = KEYSTONE_LATCH_HEIGHT;

// Module: keystone()
// Description: creates a keystone jack panel with a grid of keystone bays. each bay includes
//   latch hooks and front wall retainers to secure standard keystone insert modules.
// Arguments:
//   rows = number of rows of keystone bays. default is 1.
//   columns = number of columns of keystone bays. default is 1.
//   rad = corner rounding radius for the panel. default is `KEYSTONE_OUTER_RAD`
//   spacing = additional gap between adjacent keystone bays. default is 0.
module keystone(rows = 1, columns = 1, rad = KEYSTONE_OUTER_RAD, spacing = 0) {
    difference() {
        keystone_negative(rows, columns, rad, spacing);

        for (i = [0 : columns - 1]) {
            for (j = [0 : rows - 1]) {
                right((i * KEYSTONE_OUTER_X) + (i * spacing)) {
                    up((j * KEYSTONE_OUTER_Z) + (j * spacing)) {
                        right((KEYSTONE_OUTER_X - KEYSTONE_INNER_X + spacing) / 2) {
                            up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z + spacing) / 2) {
                                cube(
                                    [
                                        KEYSTONE_INNER_X,
                                        KEYSTONE_INNER_Y,
                                        KEYSTONE_INNER_Z,
                                    ]
                                );
                            }
                        }
                    }
                }
            }
        }
    }

    for (i = [0 : columns - 1]) {
        for (j = [0 : rows - 1]) {
            right((i * KEYSTONE_OUTER_X) + (i * spacing)) {
                up((j * KEYSTONE_OUTER_Z) + (j * spacing)) {
                    // bottom hook latch
                    right(KEYSTONE_INNER_X + (KEYSTONE_OUTER_X - KEYSTONE_INNER_X + spacing) / 2) {
                        up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z + spacing) / 2) {
                            _keystone_latch(KEYSTONE_LATCH_DEPTH, KEYSTONE_LATCH_HEIGHT);
                        }

                    }

                    // top hook latch
                    right(KEYSTONE_INNER_X + (KEYSTONE_OUTER_X - KEYSTONE_INNER_X + spacing) / 2) {
                        up(
                            KEYSTONE_OUTER_Z -
                                ((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z - spacing) / 2)
                        ) {
                            zflip() {
                                _keystone_latch(KEYSTONE_LATCH_DEPTH, KEYSTONE_LATCH_HEIGHT);
                            }
                        }
                    }

                    // bottom front
                    back(KEYSTONE_OUTER_Y - KEYSTONE_FRONT_WALL_THICKNESS) {
                        up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z + spacing) / 2) {
                            cube([
                                KEYSTONE_OUTER_X,
                                KEYSTONE_FRONT_WALL_THICKNESS,
                                KEYSTONE_FRONT_WALL_BOTTOM_HEIGHT
                            ]);
                        }
                    }

                    // top front
                    back(KEYSTONE_OUTER_Y - KEYSTONE_FRONT_WALL_THICKNESS) {
                        up(
                            KEYSTONE_OUTER_Z -
                                ((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z - spacing) / 2) -
                                KEYSTONE_FRONT_WALL_TOP_HEIGHT
                        ) {
                            cube([
                                KEYSTONE_OUTER_X,
                                KEYSTONE_FRONT_WALL_THICKNESS,
                                KEYSTONE_FRONT_WALL_TOP_HEIGHT
                            ]);
                        }
                    }
                }
            }
        }
    }
}

// Module: keystone_negative()
// Description: creates a negative volume (cutout) for a keystone panel. can be used with
//   `difference()` to carve keystone bays into another object.
// Arguments:
//   rows = number of rows of keystone bays. default is 1.
//   columns = number of columns of keystone bays. default is 1.
//   rad = corner rounding radius for the panel cutout. default is `KEYSTONE_OUTER_RAD`
//   spacing = additional gap between adjacent keystone bays. default is 0.
module keystone_negative(
    rows=1,
    columns=1,
    rad = KEYSTONE_OUTER_RAD,
    spacing = 0
) {
    cuboid(
        [
            calcualte_keystone_panel_width(columns, spacing),
            KEYSTONE_OUTER_Y,
            calcualte_keystone_panel_height(rows, spacing)
        ],
        rounding = rad,
        anchor = BOTTOM + LEFT + FRONT,
        edges = [
            LEFT + TOP,
            LEFT + BOTTOM,
            RIGHT + TOP,
            RIGHT + BOTTOM,
        ]
    );
}

// Function: calcualte_keystone_panel_width()
// Description: calculates the total width of a keystone panel given the number of columns and
//   the spacing between them.
// Arguments:
//   columns = number of keystone columns. default is 1.
//   spacing = additional gap between adjacent keystone bays. default is 0.
function calcualte_keystone_panel_width(
    columns = 1, spacing = 0
) = (KEYSTONE_OUTER_X * columns) + (spacing * columns);

// Function: calcualte_keystone_panel_height()
// Description: calculates the total height of a keystone panel given the number of rows and the
//   spacing between them.
// Arguments:
//   rows = number of keystone rows. default is 1.
//   spacing = additional gap between adjacent keystone bays. default is 0.
function calcualte_keystone_panel_height(
    rows = 1, spacing = 0
) = (KEYSTONE_OUTER_Z * rows) + (spacing * rows);

module _keystone_latch(depth, height) {
    back(depth) {
        yflip(){
            yrot(-90) {
                linear_extrude(KEYSTONE_INNER_X) {
                    right_triangle([height, depth]);
                }
            }
        }
    }
}

