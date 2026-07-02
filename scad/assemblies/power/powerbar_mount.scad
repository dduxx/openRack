include <../../lib/faceplate/faceplate.scad>
include <../../lib/rack_units.scad>
include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../lib/fasteners/screws.scad>

$fn = 100;

SECTION_WIDTH = NINETEEN_INCH_STANDARD_WIDTH / 3;
SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

SLOT_RAD = M4_SCREW_RAD + 0.5;

difference() {
    faceplate(
        width = SECTION_WIDTH,
        skip_holes = [1],
        holes_on_left = SECTION == "LEFT",
        holes_on_right = SECTION == "RIGHT",
        join_support_left = SECTION != "LEFT",
        join_support_right = SECTION != "RIGHT",
        fillet_left = SECTION == "LEFT",
        fillet_right = SECTION == "RIGHT"
    );

    up((RACK_UNIT * 1) / 2) {
        xrot(90) {
            right(inches_to_mm(5/8)) down(FRONT_PLATE_THICKNESS) {
                hull() {
                    cylinder(h = FRONT_PLATE_THICKNESS, r = SLOT_RAD);

                    right(SECTION_WIDTH - (2 * inches_to_mm(5/8))) {
                        cylinder(h = FRONT_PLATE_THICKNESS, r = SLOT_RAD);
                    }
                }
            }
        }
    }
}
