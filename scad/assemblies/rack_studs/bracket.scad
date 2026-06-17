include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>
include <../../lib/fasteners/nuts.scad>
include <../../lib/fasteners/screws.scad>
include <../../lib/rack_units.scad>

$fn = 100;

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
            screw_cutout(TEN_THIRTY_TWO_SCREW_RAD);
        }
    }
}
