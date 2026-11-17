include <../../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../../lib/faceplate/faceplate.scad>
include <../../../lib/fasteners/screws.scad>
include <../../../lib/rack_units.scad>

SLOT_MOUNT_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
SLOT_MOUNT_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

module __Customizer_Limit__ () {}

$fn = 100;

SLOT_MOUNT_SECTIONS = SLOT_MOUNT_RACK_TYPE == "NINETEEN_INCH" ? 3 : 2;
SECTION_WIDTH = SLOT_MOUNT_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / SLOT_MOUNT_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / SLOT_MOUNT_SECTIONS;

SLOT_RAD = SCREWS__M4_RAD + 0.5;

difference() {
    faceplate(
        width = SECTION_WIDTH,
        skip_holes = [1],
        holes_on_left = SLOT_MOUNT_SECTION == "LEFT",
        holes_on_right = SLOT_MOUNT_SECTION == "RIGHT",
        join_support_left = SLOT_MOUNT_SECTION != "LEFT",
        join_support_right = SLOT_MOUNT_SECTION != "RIGHT",
        fillet_left = SLOT_MOUNT_SECTION == "LEFT",
        fillet_right = SLOT_MOUNT_SECTION == "RIGHT"
    );

    right(SECTION_WIDTH / 2) up(RACK_UNIT / 2){
        xrot(90) {
            down(FACEPLATE__PLATE_THICKNESS) {
                screw_slot(
                    SLOT_RAD,
                    SECTION_WIDTH - (2 * inches_to_mm(5/8)),
                    total_length = FACEPLATE__PLATE_THICKNESS,
                    thread_buffer = 0.5,
                );
            }
        }
    }
}
