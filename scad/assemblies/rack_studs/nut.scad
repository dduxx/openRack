include <../../lib/const/standard.scad>
include <../../lib/const/rack_units.scad>
include <../../lib/utils/unit_conversion.scad>
include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

$fn = FACET_NUMBER;

// TODO make this more parametric
difference() {
    union() {
        linear_sweep(
            circle(inches_to_mm(5 / 8) / 2),
            h=8,
            texture="diamonds",
            tex_size=[1, 1],
            tex_depth=0.5
        );

        up(8) {
            linear_sweep(
                circle(inches_to_mm(5 / 8) / 2),
                h=20,
                texture="diamonds",
                tex_size=[1, 1],
                tex_depth=0.5,
                scale=0.5
            );
        }
    }

    nut_cutout(flat_to_flat=THREE_EIGHTHS_NUT_FLAT_TO_FLAT, nut_height=3);

    screw_cutout(countersink_rad=TEN_THIRTYTWO_HOLE_RAD, total_length=50);
}
