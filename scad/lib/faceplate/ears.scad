include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/rack_units.scad>
include <./faceplate.scad>

module rack_ear(
    width,
    ear_depth,
    is_left_ear = true,
    rack_units = 1,
    thickness = FRONT_PLATE_THICKNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    has_bottom_support = true,
    countersink_rad = 0,
) {
    if (is_left_ear) {
        _ear(
            width,
            ear_depth,
            rack_units,
            thickness,
            rad,
            skip_holes,
            has_bottom_support,
            countersink_rad,
        );
    } else {
        right(width) {
            xflip() {
                _ear(
                    width,
                    ear_depth,
                    rack_units,
                    thickness,
                    rad,
                    skip_holes,
                    has_bottom_support,
                    countersink_rad,
                );
            }
        }
    }
}

module _ear(
    width,
    ear_depth,
    rack_units,
    thickness,
    rad,
    skip_holes,
    has_bottom_support,
    countersink_rad,
) {
    faceplate(
        rack_units = rack_units,
        width = width,
        thickness = thickness,
        rad = rad,
        skip_holes = skip_holes,
        holes_on_left = true,
        holes_on_right = false,
        fillet_left = true,
        fillet_right = false,
        join_support_left = false,
        join_support_right = false,
        countersink_rad = countersink_rad,
    );

    ear_trans = width - thickness;
    bottom_fillet = has_bottom_support ? [] : [BOTTOM + BACK];
    right(ear_trans) {
        cuboid(
            [thickness, ear_depth, RACK_UNIT * rack_units],
            edges = concat([TOP + BACK], bottom_fillet),
            rounding = rad,
            anchor = FRONT + LEFT + BOTTOM
        );
    }

    if (has_bottom_support) {
        right(width - thickness) back(thickness) {
            xflip() {
                linear_extrude(thickness){
                    right_triangle(
                        size = [width - inches_to_mm(5/8) - thickness, ear_depth - thickness],
                        center = false,
                        anchor = LEFT + FRONT
                    );
                }
            }
        }
    }
}
