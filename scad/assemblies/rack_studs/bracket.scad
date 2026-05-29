include <../../lib/const/standard.scad>
include <../../lib/const/rack_units.scad>
include <../../lib/utils/unit_conversion.scad>
include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

$fn = FACET_NUMBER;

NUT_RETAINER_XY = RACK_UNIT_HOLE_SPACING - ( (RACK_UNIT_HOLE_SPACING - RACK_SQUARE_HOLE_XY) / 2);
NUT_RETAINER_THICKNESS = 4;

INSERT_XY = inches_to_mm(3 / 8) - 0.4;
INSERT_THICKNESS = 2;

NUT_HEIGHT = 3;
NUT_BUFFER = 0.2;

up(2) {
    difference() {
        union() {
            linear_extrude(NUT_RETAINER_THICKNESS) {
                square([NUT_RETAINER_XY, NUT_RETAINER_XY], center=true);
            }

            down(INSERT_THICKNESS) {
                linear_extrude(INSERT_THICKNESS) {
                    square([INSERT_XY, INSERT_XY], center=true);
                }
            }
        }

        up(1) {
            nut_cutout(
                flat_to_flat=THREE_EIGHTHS_NUT_FLAT_TO_FLAT, 
                nut_height=NUT_HEIGHT, 
                buffer=NUT_BUFFER
            );
        }

        down(2) {
            screw_cutout(countersink_rad=0);
        }
    }
}
