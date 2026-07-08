include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../lib/faceplate/faceplate.scad>
include <../../lib/keystone/keystone.scad>

$fn = 100;

PATCH_PANEL_SECTIONS = 3;
PATCH_PANEL_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
PATCH_PANEL_SECTION_WIDTH = PATCH_PANEL_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / PATCH_PANEL_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / PATCH_PANEL_SECTIONS;

PATCH_PANEL_SKIP_HOLES = [1];

PATCH_PANEL_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

JACKS_PER_SECTION = 6;

difference() {
    faceplate(
        rack_units = 1,
        width = PATCH_PANEL_SECTION_WIDTH,
        thickness = FRONT_PLATE_THICKNESS,
        rad = FACEPLATE_FILLET_RAD,
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
        left(calcualte_keystone_panel_width(JACKS_PER_SECTION) / 2) {
            down(calcualte_keystone_panel_height(1) / 2) {
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

right(PATCH_PANEL_SECTION_WIDTH / 2) up(RACK_UNIT / 2) {
    // centering the panel
    left(calcualte_keystone_panel_width(JACKS_PER_SECTION) / 2) {
        down(calcualte_keystone_panel_height(1) / 2) {
            keystone(
                rows = 1,
                columns = JACKS_PER_SECTION,
                rad = KEYSTONE_OUTER_RAD,
                spacing = 0
            );
        }
    }
}
