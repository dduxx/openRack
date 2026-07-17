include <../../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../../lib/faceplate/faceplate.scad>
include <../../../lib/fasteners/screws.scad>
include <../../../lib/rack_units.scad>

$fn = 100;

SLOT_MOUNT_SECTIONS = 3;
SLOT_MOUNT_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
SECTION_WIDTH = SLOT_MOUNT_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / SLOT_MOUNT_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / SLOT_MOUNT_SECTIONS;
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

    right(SECTION_WIDTH / 2) up(RACK_UNIT / 2){
        xrot(90) {
            down(FRONT_PLATE_THICKNESS) {
                screw_slot(
                    SLOT_RAD,
                    SECTION_WIDTH - (2 * inches_to_mm(5/8)),
                    total_length = FRONT_PLATE_THICKNESS,
                    thread_buffer = 0.5,
                );
            }
        }
    }
}
