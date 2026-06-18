include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/rack_units.scad>
include <./faceplate.scad>

module rack_ear(
    width,
    ear_depth,
    rack_units = 1,
    thickness = FRONT_PLATE_THICKNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    is_left_ear = true,
    countersink_rad = 0,
) {
    faceplate(
        rack_units = rack_units,
        width = width,
        thickness = thickness,
        rad = rad,
        skip_holes = skip_holes,
        holes_on_left = is_left_ear,
        holes_on_right = !is_left_ear,
        fillet_left = is_left_ear,
        fillet_right = !is_left_ear,
        join_support_left = false,
        join_support_right = false,
        countersink_rad = countersink_rad,
    );

    x_trans = is_left_ear ? width - thickness : 0;
    right(x_trans) {
        cuboid(
            [thickness, ear_depth, RACK_UNIT * rack_units],
            edges = [TOP + BACK, BOTTOM + BACK],
            rounding = rad,
            anchor = FRONT + LEFT + BOTTOM
        );
    }
}
