include <../../lib/const/standard.scad>
include <../../lib/const/rack_units.scad>
include <../../lib/utils/unit_conversion.scad>
include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

$fn = FACET_NUMBER;

NUT_BUFFER = 0.2;
NUT_HEIGHT = 3;

BASE_HEIGHT = 8;
BASE_RAD = inches_to_mm(1 / 2) / 2;

TEXTURE_SIZE = [3, 3];
TEXTURE_DEPTH = 1.5;

HANDLE_HEIGHT = 20;
HANDLE_RAD_TOP = 4;

WING_FILLET_RAD = 0.5;
WING_THICKNESS = 4;

difference() {
    union() {
        linear_sweep(
            circle(r=BASE_RAD),
            h=BASE_HEIGHT,
            texture="diamonds",
            tex_size=TEXTURE_SIZE,
            tex_depth=TEXTURE_DEPTH
        );

        up(8) {
            cylinder(h=HANDLE_HEIGHT, r2=HANDLE_RAD_TOP, r1=BASE_RAD - 1);

            translate([
                -BASE_RAD + WING_FILLET_RAD, 
                -(WING_THICKNESS/2) + WING_FILLET_RAD, 
                -WING_FILLET_RAD
            ]) {
                minkowski() {
                    cube([
                        (BASE_RAD * 2) - (WING_FILLET_RAD * 2), 
                        WING_THICKNESS - (WING_FILLET_RAD * 2), 
                        HANDLE_HEIGHT
                    ]);

                    sphere(WING_FILLET_RAD);
                }
            }

            translate([
                -(WING_THICKNESS/2) + WING_FILLET_RAD, 
                -BASE_RAD + WING_FILLET_RAD, 
                -WING_FILLET_RAD
            ]) {
                minkowski() {
                    cube([
                        WING_THICKNESS - (WING_FILLET_RAD * 2), 
                        (BASE_RAD * 2) - (WING_FILLET_RAD * 2), 
                        HANDLE_HEIGHT
                    ]);

                    sphere(WING_FILLET_RAD);
                }
            }
        }
    }

    nut_cutout(
        flat_to_flat=THREE_EIGHTHS_NUT_FLAT_TO_FLAT, nut_height=NUT_HEIGHT, buffer=NUT_BUFFER
    );

    screw_cutout(countersink_rad=TEN_THIRTYTWO_HOLE_RAD, total_length=BASE_HEIGHT + HANDLE_HEIGHT);
}
