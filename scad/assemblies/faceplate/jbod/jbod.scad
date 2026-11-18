include <../../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../../lib/faceplate/faceplate.scad>
include <../../../lib/fan.scad>
include <../../../lib/fasteners/rod.scad>
include <../../../lib/hdd/sled_enclosure_builder.scad>
include <../../../lib/utils/ellipse.scad>

JBOD_RACK_TYPE = "NINETEEN_INCH"; // [NINETEEN_INCH, TEN_INCH]
JBOD_SECTION = "LEFT"; // [LEFT, MIDDLE, RIGHT]

module __Customizer_Limit__ () {}

$fn = 100;

JBOD_RACK_UNITS = 3;
JBOD_SECTIONS = JBOD_RACK_TYPE == "NINETEEN_INCH" ? 3 : 2;
JBOD_SECTION_WIDTH = JBOD_RACK_TYPE == "NINETEEN_INCH" ?
    NINETEEN_INCH_STANDARD_WIDTH / JBOD_SECTIONS :
    TEN_INCH_STANDARD_WIDTH / JBOD_SECTIONS;
JBOD_SKIPPED_HOLES = [1, 3, 4, 5, 7];

JDBO_FASTNER_BUFFER = 0.2;

DRIVES_PER_SECTION = JBOD_RACK_TYPE == "NINETEEN_INCH" ? 3 : 2;

FAN_BUFFER = 2;

difference() {
    union() {
        faceplate(
            rack_units = JBOD_RACK_UNITS,
            width = JBOD_SECTION_WIDTH,
            thickness = FACEPLATE__PLATE_THICKNESS,
            rad = FACEPLATE__FILLET_RAD,
            skip_holes = JBOD_SKIPPED_HOLES,
            holes_on_left = JBOD_SECTION == "LEFT",
            holes_on_right = JBOD_SECTION == "RIGHT",
            fillet_left = JBOD_SECTION == "LEFT",
            fillet_right = JBOD_SECTION == "RIGHT",
            join_support_left = JBOD_SECTION != "LEFT",
            join_support_right = JBOD_SECTION != "RIGHT",
            countersink_rad = 0,
        );

        right(inches_to_mm(5/8)) {
            cuboid(
                [
                    JBOD_SECTION_WIDTH - (2 * inches_to_mm(5/8)),
                    drive_enclosure_depth(),
                    ((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL)))/2
                ],
                edges = [TOP + LEFT, LEFT + BOTTOM, TOP + RIGHT, RIGHT + BOTTOM],
                rounding = DRIVE_SLED__EDGE_FILLET,
                anchor = BOTTOM + LEFT + FRONT
            );
        }
    }

    right(
        (
            JBOD_SECTION_WIDTH -
                (drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) * DRIVES_PER_SECTION)
            ) / 2
    ) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL)))/2) {
            cuboid(
                [
                    drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) * DRIVES_PER_SECTION,
                    drive_enclosure_depth(),
                    drive_enclosure_width(DRIVE_SLED__WALL)
                ],
                edges = [
                    LEFT + TOP,
                    LEFT + BOTTOM,
                    RIGHT + TOP,
                    RIGHT + BOTTOM,
                ],
                anchor = FRONT + LEFT + BOTTOM,
                rounding = DRIVE_SLED__EDGE_FILLET
            );
        }
    }


    back(ROD__QUARTER_INCH_THREADED_RAD + JDBO_FASTNER_BUFFER + FACEPLATE__PLATE_THICKNESS * 4) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL)))/4) {
            yrot(90) {
                threaded_rod_cutout(
                    ROD__QUARTER_INCH_THREADED_RAD,
                    JBOD_SECTION_WIDTH,
                    buffer = JDBO_FASTNER_BUFFER,
                );
            }
        }
    }

    back(drive_enclosure_depth() -
        ROD__QUARTER_INCH_THREADED_RAD -
        JDBO_FASTNER_BUFFER - FACEPLATE__PLATE_THICKNESS * 4
    ) {
        up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL)))/4) {
            yrot(90) {
                threaded_rod_cutout(
                    ROD__QUARTER_INCH_THREADED_RAD,
                    JBOD_SECTION_WIDTH,
                    buffer = JDBO_FASTNER_BUFFER,
                );
            }
        }
    }


    right (
        (
            (
                JBOD_SECTION_WIDTH -
                    (drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) * DRIVES_PER_SECTION)
            ) / 2
        ) + ((drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) / 2))
    ) {
        for (i = [0 : DRIVES_PER_SECTION - 1]) {
            right (i * drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL)) {
                back(drive_enclosure_depth() / 2) {
                    elliptic_cylinder([
                        (
                            drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) /
                                SLED_ENCLOSURE__MATERIAL_REMOVAL_FACTOR_X
                        ) * 2,
                        (drive_enclosure_depth() / SLED_ENCLOSURE__MATERIAL_REMOVAL_FACTOR_Y) * 2,
                        ((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL))) /
                            2
                    ]);
                }
            }
        }
    }
}

right (
    (
        (
            JBOD_SECTION_WIDTH -
                (drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL) * DRIVES_PER_SECTION)
        ) / 2
    ) + (drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL))
) {
    up (((JBOD_RACK_UNITS * RACK_UNIT) - (drive_enclosure_width(DRIVE_SLED__WALL)))/2) {
        for (i = [0 : DRIVES_PER_SECTION - 1]) {
            right(i * drive_enclosure_height(DRIVE_SLED__FLOOR, DRIVE_SLED__WALL)) {
                yrot(-90) {
                    three_point_five_inch_enclosure(
                        wall=DRIVE_SLED__WALL,
                        rad=DRIVE_SLED__EDGE_FILLET,
                        fillet_top = i == 0,
                        fillet_bottom = i == DRIVES_PER_SECTION - 1,
                        has_sata_connector = true,
                        sled_buffer = SLED_ENCLOSURE__BUFFER,
                    );
                }
            }
        }
    }
}
