include <../../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../../lib/faceplate/faceplate.scad>
include <../../../lib/keystone/keystone.scad>

PATCH_PANEL_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
PATCH_PANEL_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

module __Customizer_Limit__ () {}

$fn = 100;

PATCH_PANEL_SECTIONS = PATCH_PANEL_RACK_TYPE == "NINETEEN_INCH" ? 3 : 2;

PATCH_PANEL_SECTION_WIDTH = PATCH_PANEL_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / PATCH_PANEL_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / PATCH_PANEL_SECTIONS;

PATCH_PANEL_SKIP_HOLES = [1];

JACKS_PER_SECTION = PATCH_PANEL_RACK_TYPE == "NINETEEN_INCH" ? 6 : 5;

difference() {
    faceplate(
        rack_units = 1,
        width = PATCH_PANEL_SECTION_WIDTH,
        thickness = FACEPLATE__PLATE_THICKNESS,
        rad = FACEPLATE__FILLET_RAD,
        skip_holes = PATCH_PANEL_SKIP_HOLES,
        holes_on_left = PATCH_PANEL_SECTION == "LEFT",
        holes_on_right = PATCH_PANEL_SECTION == "RIGHT",
        fillet_left = PATCH_PANEL_SECTION == "LEFT",
        fillet_right = PATCH_PANEL_SECTION == "RIGHT",
        join_support_left = PATCH_PANEL_SECTION != "LEFT",
        join_support_right = PATCH_PANEL_SECTION != "RIGHT",
        countersink_rad = 0
    );

    right(PATCH_PANEL_SECTION_WIDTH / 2) up(RACK_UNIT / 2) {
        // centering the panel
        left(calculate_keystone_panel_width(JACKS_PER_SECTION) / 2) {
            down(calculate_keystone_panel_height(1) / 2) {
                keystone_negative(
                    rows = 1,
                    columns = JACKS_PER_SECTION,
                    rad = KEYSTONE_OUTER_RAD,
                    spacing = 0
                );
            }
        }
    }
}

right(PATCH_PANEL_SECTION_WIDTH / 2) back(KEYSTONE_OUTER_Y) up(RACK_UNIT / 2) {
    yflip() {
        // centering the panel
        left(calculate_keystone_panel_width(JACKS_PER_SECTION) / 2) {
            down(calculate_keystone_panel_height(1) / 2) {
                keystone(
                    rows = 1,
                    columns = JACKS_PER_SECTION,
                    rad = KEYSTONE_OUTER_RAD,
                    spacing = 0
                );
            }
        }
    }
}
