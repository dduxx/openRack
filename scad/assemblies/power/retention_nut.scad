include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/fasteners/screws.scad>
include <../../lib/fasteners/nuts.scad>

$fn = 100;

HEIGHT = 5;
RAD = 6;
WING_WIDTH = (RAD * 2) + 4;
WING_THICKNESS = 2.5;
FILLET = 1;

difference() {
    union() {
        cylinder(h=HEIGHT, r=RAD);

        cuboid(
            [
                WING_WIDTH,
                WING_THICKNESS,
                HEIGHT
            ],
            rounding = FILLET,
            edges = [LEFT + FRONT, FRONT + RIGHT, RIGHT + BACK, BACK + LEFT],
            anchor = BOTTOM
        );

        cuboid(
            [
                WING_THICKNESS,
                WING_WIDTH,
                HEIGHT
            ],
            rounding = FILLET,
            edges = [LEFT + FRONT, FRONT + RIGHT, RIGHT + BACK, BACK + LEFT],
            anchor = BOTTOM
        );
    }

    up(1) {
        nut_cutout(M4_FLAT_TO_FLAT, nut_height = HEIGHT - 1, faces = 6, buffer = 0.2);
    }

    screw_cutout(
        M4_SCREW_RAD,
        total_length = HEIGHT,
        thread_buffer = 1
    );
}
