include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../lib/faceplate/faceplate.scad>
include <../../lib/fan.scad>
include <../../lib/fasteners/screws.scad>

$fn = 100;

FAN_PANEL_RACK_UNITS = 1;
FAN_PANEL_SECTIONS = 3;
FAN_PANEL_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
FAN_PANEL_SECTION_WIDTH = FAN_PANEL_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / FAN_PANEL_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / FAN_PANEL_SECTIONS;

FAN_PANEL_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

FANS_PER_SECTION = 3;

FAN_SIZE_MM = FORTY_MM_FAN_XY;
FAN_HOLE_SPACING = FORTY_MM_FAN_HOLE_SPACING;

FAN_SPACING = 2;

SKIP_HOLES = [ for (i = [1 : (HOLES_PER_UNIT * FAN_PANEL_RACK_UNITS) - 2]) i ];

difference() {
    vented_faceplate(
        rack_units = FAN_PANEL_RACK_UNITS,
        width = FAN_PANEL_SECTION_WIDTH,
        thickness = FRONT_PLATE_THICKNESS,
        rad = FACEPLATE_FILLET_RAD,
        skip_holes = SKIP_HOLES,
        holes_on_left = FAN_PANEL_SECTION == "LEFT",
        holes_on_right = FAN_PANEL_SECTION == "RIGHT",
        fillet_left = FAN_PANEL_SECTION == "LEFT",
        fillet_right = FAN_PANEL_SECTION == "RIGHT",
        join_support_left = FAN_PANEL_SECTION != "LEFT",
        join_support_right = FAN_PANEL_SECTION != "RIGHT",
        countersink_rad = 0
    );

    right((FAN_PANEL_SECTION_WIDTH - (FANS_PER_SECTION * FAN_SPACING * FAN_SIZE_MM) / 2)) {
        back(FRONT_PLATE_THICKNESS) {
            up(((RACK_UNIT * FAN_PANEL_RACK_UNITS) - FAN_SIZE_MM) / 2) {
                for (i = [0 : FANS_PER_SECTION - 1]) {
                    up(FAN_SIZE_MM / 2) {
                        xrot(90) {
                            right((i * FAN_SIZE_MM) + (i * FAN_SPACING)) {
                                fan_mounting_holes(
                                    hole_spacing = FAN_HOLE_SPACING,
                                    hole_rad = M4_SCREW_RAD * 2,
                                    hole_depth = FRONT_PLATE_THICKNESS,
                                    thread_buffer = 0,
                                    holes = [0, 1, 2, 3],
                                );
                            }
                        }
                    }
                }
            }
        }
    }
}

right((FAN_PANEL_SECTION_WIDTH - (FANS_PER_SECTION * FAN_SPACING * FAN_SIZE_MM) / 2)) {
    back(FRONT_PLATE_THICKNESS) {
        up(((RACK_UNIT * FAN_PANEL_RACK_UNITS) - FAN_SIZE_MM) / 2) {
            for (i = [0 : FANS_PER_SECTION - 1]) {
                up(FAN_SIZE_MM / 2) {
                    xrot(90) {
                        right((i * FAN_SIZE_MM) + (i * FAN_SPACING)) {
                            difference() {
                                fan_mounting_holes(
                                    hole_spacing = FAN_HOLE_SPACING,
                                    hole_rad = M4_SCREW_RAD * 2,
                                    hole_depth = FRONT_PLATE_THICKNESS,
                                    thread_buffer = 0,
                                    holes = [0, 1, 2, 3],
                                );

                                fan_mounting_holes(
                                    hole_spacing = FAN_HOLE_SPACING,
                                    hole_rad = M4_SCREW_RAD,
                                    hole_depth = FRONT_PLATE_THICKNESS,
                                    thread_buffer = 0,
                                    holes = [0, 1, 2, 3],
                                );
                            }
                        }
                    }
                }
            }
        }
    }
}
