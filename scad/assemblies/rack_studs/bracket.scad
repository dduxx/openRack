include <../../lib/const/standard.scad>
include <../../lib/const/rack_units.scad>
include <../../lib/utils/unit_conversion.scad>
include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

$fn = FACET_NUMBER;

OUTER_SQUARE = RACK_UNIT_HOLE_SPACING - ( (RACK_UNIT_HOLE_SPACING - RACK_SQUARE_HOLE_XY) / 2);

up(2) {
    difference() {
        union() {
            linear_extrude(height=4) {
                square([OUTER_SQUARE, OUTER_SQUARE], center=true);
            }

            down(2) {
                linear_extrude(2) {
                    square([inches_to_mm(3 / 8), inches_to_mm(3 / 8)], center=true);
                }
            }
        }

        up(1) {
            nut_cutout(flat_to_flat=THREE_EIGHTHS_NUT_FLAT_TO_FLAT, nut_height=3);
        }

        down(2) {
            screw_cutout(countersink_rad=0);
        }
    }
}
