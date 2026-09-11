include <../../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../../lib/faceplate/faceplate.scad>

$fn = 100;

BLANK_PANEL_SECTIONS = 3;
BLANK_PANEL_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
BLANK_PANEL_SECTION_WIDTH = BLANK_PANEL_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / BLANK_PANEL_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / BLANK_PANEL_SECTIONS;

BLANK_PANEL_SKIP_HOLES = [1];

BLANK_PANEL_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

BLANK_PANEL_RACK_UNITS = 1;

VENTED = false;

if (VENTED) {
    vented_faceplate(
        rack_units = BLANK_PANEL_RACK_UNITS,
        width = BLANK_PANEL_SECTION_WIDTH,
        thickness = FRONT_PLATE_THICKNESS,
        rad = FACEPLATE_FILLET_RAD,
        skip_holes = BLANK_PANEL_SKIP_HOLES,
        holes_on_left = BLANK_PANEL_SECTION == "LEFT",
        holes_on_right = BLANK_PANEL_SECTION == "RIGHT",
        fillet_left = BLANK_PANEL_SECTION == "LEFT",
        fillet_right = BLANK_PANEL_SECTION == "RIGHT",
        join_support_left = BLANK_PANEL_SECTION != "LEFT",
        join_support_right = BLANK_PANEL_SECTION != "RIGHT",
        countersink_rad = 0
    );
} else {
    faceplate(
        rack_units = BLANK_PANEL_RACK_UNITS,
        width = BLANK_PANEL_SECTION_WIDTH,
        thickness = FRONT_PLATE_THICKNESS,
        rad = FACEPLATE_FILLET_RAD,
        skip_holes = BLANK_PANEL_SKIP_HOLES,
        holes_on_left = BLANK_PANEL_SECTION == "LEFT",
        holes_on_right = BLANK_PANEL_SECTION == "RIGHT",
        fillet_left = BLANK_PANEL_SECTION == "LEFT",
        fillet_right = BLANK_PANEL_SECTION == "RIGHT",
        join_support_left = BLANK_PANEL_SECTION != "LEFT",
        join_support_right = BLANK_PANEL_SECTION != "RIGHT",
        countersink_rad = 0
    );
}
