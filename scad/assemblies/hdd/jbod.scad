include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../lib/faceplate/faceplate.scad>
include <../../lib/fasteners/rod.scad>
include <../../lib/hdd/sled_enclosure_builder.scad>

$fn = 100;

JBOD_RACK_UNITS = 3;
JBOD_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
JBOD_SECTIONS = 3;
JBOD_SECTION_WIDTH = JBOD_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / JBOD_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / JBOD_SECTIONS;
JBOD_SKIPPED_HOLES = [1, 3, 4, 5, 7];

JBOD_ROD_BUFFER = 0.2;

SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

DRIVES_PER_SECTION = 3;

difference() {
    union() {
        faceplate(
            rack_units = JBOD_RACK_UNITS,
            width = JBOD_SECTION_WIDTH,
            thickness = FRONT_PLATE_THICKNESS,
            rad = FACEPLATE_FILLET_RAD,
            skip_holes = JBOD_SKIPPED_HOLES,
            holes_on_left = SECTION == "LEFT",
            holes_on_right = SECTION == "RIGHT",
            fillet_left = SECTION == "LEFT",
            fillet_right = SECTION == "RIGHT",
            join_support_left = SECTION != "LEFT",
            join_support_right = SECTION != "RIGHT",
            countersink_rad = 0,
        );

        right(inches_to_mm(5/8)) {
            cuboid(
                [
                    JBOD_SECTION_WIDTH - (2 * inches_to_mm(5/8)),
                    drive_enclosure_depth(),
                    ((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED_WALL)))/2
                ],
                edges = [TOP + LEFT, LEFT + BOTTOM, TOP + RIGHT, RIGHT + BOTTOM],
                rounding = DRIVE_SLED_EDGE_FILLET,
                anchor = BOTTOM + LEFT + FRONT
            );
        }
    }

    right((JBOD_SECTION_WIDTH - (drive_enclosure_height(DRIVE_SLED_WALL) * DRIVES_PER_SECTION))/2) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED_WALL)))/2) {
            cuboid(
                [
                    drive_enclosure_height(DRIVE_SLED_WALL) * DRIVES_PER_SECTION,
                    drive_enclosure_depth(),
                    drive_enclosure_width(DRIVE_SLED_WALL)
                ],
                edges = [
                    LEFT + TOP,
                    LEFT + BOTTOM,
                    RIGHT + TOP,
                    RIGHT + BOTTOM,
                ],
                anchor = FRONT + LEFT + BOTTOM,
                rounding = DRIVE_SLED_EDGE_FILLET
            );
        }
    }


    back(QUARTER_INCH_THREADED_ROD_RAD + JBOD_ROD_BUFFER + FRONT_PLATE_THICKNESS) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED_WALL)))/4) {
            yrot(90) {
                threaded_rod_cutout(
                    QUARTER_INCH_THREADED_ROD_RAD,
                    JBOD_SECTION_WIDTH,
                    buffer = JBOD_ROD_BUFFER,
                );
            }
        }
    }

    back(drive_enclosure_depth() -
        QUARTER_INCH_THREADED_ROD_RAD -
        JBOD_ROD_BUFFER - FRONT_PLATE_THICKNESS
    ) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED_WALL)))/4) {
            yrot(90) {
                threaded_rod_cutout(
                    QUARTER_INCH_THREADED_ROD_RAD,
                    JBOD_SECTION_WIDTH,
                    buffer = JBOD_ROD_BUFFER,
                );
            }
        }
    }
}

right (
    ((JBOD_SECTION_WIDTH - (drive_enclosure_height(DRIVE_SLED_WALL) * DRIVES_PER_SECTION))/2) +
        (drive_enclosure_height(DRIVE_SLED_WALL))
) {
    up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED_WALL)))/2) {
        for (i = [0 : DRIVES_PER_SECTION - 1]) {
            right(i * drive_enclosure_height(DRIVE_SLED_WALL)) {
                yrot(-90) {
                    three_point_five_inch_enclosure(
                        wall=DRIVE_SLED_WALL,
                        rad=DRIVE_SLED_EDGE_FILLET,
                        fillet_top = i == 0,
                        fillet_bottom = i == DRIVES_PER_SECTION - 1,
                        has_sata_connector = true,
                        sled_buffer = DRIVE_ENCLOSURE_SLED_BUFFER,
                    );
                }
            }
        }
    }
}
