include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>

// Module: ellipse()
// Description: Creates a 2d ellipse of a given width and length
// Arguments:
//   xy = a vector representing the width of the entire ellipse in the x direction and the length in
//     the y direction.
//   center = a boolean value used to center the shape on the origin. if false the ellipse will be
//     shifted right by half the x value and back by half the y value.
module ellipse(xy, center = true) {
    assert(is_list(xy) && len(xy) == 2, "xy arg expected a vector with [x, y] values");
    assert(is_bool(center), "center arg expected a boolean");

    for (n = xy) {
        assert(is_num(n), "x and y arguments must be numbers.");
    }

    x = xy[0];
    y = xy[1];

    x_scale = x < y ? 1 : x / y;
    y_scale = y < x ? 1 : y / x;

    r = x < y ? x / 2 : y / 2;

    x_trans = center ? 0 : x / 2;
    y_trans = center ? 0 : y / 2;

    right(x_trans) back(y_trans) {
        scale([x_scale, y_scale, 1]) {
            circle(r = r);
        }
    }
}

// Module: elliptic_cylinder()
// Description: Extrudes an ellipse of a given width and length to the given height
// Arguments:
//   xyz = a vector representing the width of the entire ellipse in the x direction, the length in
//     the y direction, and the height to extrude in the z direction.
//   xy_center = a boolean value used to center the shape on the origin in the x and y directions.
//     if false the ellipse will be shifted right by half the x value and back by half the y value.
//   z_center = a boolean value used to center the extrusion in the z direction. if true the shape
//     will be shifted down by half the z value.
module elliptic_cylinder(xyz, xy_center = true, z_center = false) {
    assert(is_list(xyz) && len(xyz) == 3, "xyz arg expected a vector with [x, y, z] values");
    assert(is_bool(xy_center), "center arg expected a boolean");
    assert(is_bool(z_center), "center arg expected a boolean");

    for (n = xyz) {
        assert(is_num(n), "x, y, and z arguments must be numbers.");
    }

    x = xyz[0];
    y = xyz[1];
    z = xyz[2];

    z_trans = z_center ? z / 2 : 0;

    down(z_trans) {
        linear_extrude(z) {
            ellipse([x, y], center = xy_center);
        }
    }
}
