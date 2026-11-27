include <../../../lib/pi/pi_sled_builder.scad>
include <../../../lib/faceplate/faceplate.scad>
include <../../../lib/rack_units.scad>
include <../../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

PI_PANEL_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
PI_PANEL_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

module __Customizer_Limit__ () {}

PI_PANEL_SECTIONS = PI_PANEL_RACK_TYPE == "NINETEEN_INCH" ? 3 : 2;

PI_PANEL_SECTION_WIDTH = PI_PANEL_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / PI_PANEL_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / PI_PANEL_SECTIONS;

PI_PANEL_SKIP_HOLES = [1];

PI_RACK_Z_OFFSET = 3;

PI_RACK_SUPPORT_WIDTH = 45;
PI_RACK_SUPPORT_DEPTH = 20;

PI_RACK_RETENTION_NUT_WIDTH = 10;
PI_RACK_RETENTION_NUT_DEPTH = 6;
PI_RACK_RETENTION_NUT_HEIGHT = RACK_UNIT - PI_SLED__FRONT_HEIGHT - PI_RACK_Z_OFFSET;

$fn = 100;

difference() {
    union() {
        faceplate(
            rack_units = 1,
            width = PI_PANEL_SECTION_WIDTH,
            thickness = FACEPLATE__PLATE_THICKNESS,
            rad = FACEPLATE__FILLET_RAD,
            skip_holes = PI_PANEL_SKIP_HOLES,
            holes_on_left = PI_PANEL_SECTION == "LEFT",
            holes_on_right = PI_PANEL_SECTION == "RIGHT",
            fillet_left = PI_PANEL_SECTION == "LEFT",
            fillet_right = PI_PANEL_SECTION == "RIGHT",
            join_support_left = PI_PANEL_SECTION != "LEFT",
            join_support_right = PI_PANEL_SECTION != "RIGHT",
            countersink_rad = 0
        );

        right(PI_PANEL_SECTION_WIDTH / 2) back(FACEPLATE__PLATE_THICKNESS) up(RACK_UNIT) {
            cuboid(
                [
                    PI_RACK_RETENTION_NUT_WIDTH,
                    PI_RACK_RETENTION_NUT_DEPTH,
                    PI_RACK_RETENTION_NUT_HEIGHT,
                ],
                edges = [
                    LEFT + BACK,
                    BACK + RIGHT,
                    TOP + BACK,
                    BOTTOM + BACK,
                ],
                rounding = 1.5,
                anchor = TOP + FRONT,
            );
        }

        right(PI_PANEL_SECTION_WIDTH / 2) back(FACEPLATE__PLATE_THICKNESS) {
            cuboid(
                [
                    PI_RACK_SUPPORT_WIDTH,
                    PI_RACK_SUPPORT_DEPTH,
                    PI_RACK_Z_OFFSET,
                ],
                rounding = FACEPLATE__FILLET_RAD,
                edges = [
                    LEFT + BACK,
                    BACK + RIGHT,
                ],
                anchor = BOTTOM + FRONT,
            );
        }
    }

    right(PI_PANEL_SECTION_WIDTH / 2) up((PI_SLED__FRONT_HEIGHT / 2) + PI_RACK_Z_OFFSET) {
        pi_sled_mount_negative(depth = FACEPLATE__PLATE_THICKNESS);
        back(FACEPLATE__PLATE_THICKNESS) {
            pi_sled_mount_retaining_nut_negative();
        }
    }
}
