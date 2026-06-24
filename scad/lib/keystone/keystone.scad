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

module keystone(rows = 1, columns = 1, rad = KEYSTONE_OUTER_RAD) {
    difference() {
        keystone_negative(rows, columns, rad);

        for (i = [0 : columns - 1]) {
            for (j = [0 : rows - 1]) {
                right(i * KEYSTONE_OUTER_X) up(j * KEYSTONE_OUTER_Z) {
                    right((KEYSTONE_OUTER_X - KEYSTONE_INNER_X) / 2) {
                        up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z) / 2) {
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

    for (i = [0 : columns - 1]) {
        for (j = [0 : rows - 1]) {
            right(i * KEYSTONE_OUTER_X) up(j * KEYSTONE_OUTER_Z) {
                // bottom hook latch
                right(KEYSTONE_INNER_X + (KEYSTONE_OUTER_X - KEYSTONE_INNER_X) / 2) {
                    up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z) / 2) {
                        _keystone_latch(KEYSTONE_LATCH_DEPTH, KEYSTONE_LATCH_HEIGHT);
                    }

                }

                // top hook latch
                right(KEYSTONE_INNER_X + (KEYSTONE_OUTER_X - KEYSTONE_INNER_X) / 2) {
                    up(KEYSTONE_OUTER_Z - ((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z) / 2)) {
                        zflip() {
                            _keystone_latch(KEYSTONE_LATCH_DEPTH, KEYSTONE_LATCH_HEIGHT);
                        }
                    }
                }

                // bottom front
                back(KEYSTONE_OUTER_Y - KEYSTONE_FRONT_WALL_THICKNESS) {
                    up((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z) / 2) {
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
                            ((KEYSTONE_OUTER_Z - KEYSTONE_INNER_Z) / 2) -
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

module keystone_negative(
    rows=1,
    columns=1,
    rad = KEYSTONE_OUTER_RAD,
) {
    cuboid(
        [
            KEYSTONE_OUTER_X * columns,
            KEYSTONE_OUTER_Y,
            KEYSTONE_OUTER_Z * rows
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
