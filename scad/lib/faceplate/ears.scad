include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../lib/rack_units.scad>
include <./faceplate.scad>

// Module: rack_ear()
// Description: creates a rack mounting ear with an integrated faceplate section.
// Arguments:
//   width = the total width of the ear including the faceplate portion
//   ear_depth = the depth of the ear that extends perpendicular to the faceplate
//   is_left_ear = boolean flag indicating whether to generate the left ear (true) or right ear
//     (false). default is true
//   rack_units = number of rack units the ear should occupy. default is 1
//   thickness = the thickness of the faceplate portion of the ear. default is
//     `FRONT_PLATE_THICKNESS`
//   rad = the corner radius used on the ear and faceplate. default is `FACEPLATE_FILLET_RAD`
//   skip_holes = a list of screw hole numbers to skip. holes are numbered from the bottom up
//     starting at 0. default is an empty list (all holes included)
//   has_bottom_support = boolean flag that enables or disables a triangular support under the ear.
//     default is true
//   countersink_rad = radius of an optional countersink for the mounting screws. default is 0.
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
