include <../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../lib/fasteners/screws.scad>
include <../lib/utils/list.scad>

FORTY_MM_FAN_XY = 40;
FORTY_MM_FAN_HOLE_SPACING = 32;

ONE_TWENTY_MM_FAN_XY = 120;
ONE_TWENTY_MM_FAN_HOLE_SPACING = 105;

// Module: fan_negative()
// Description: creates a negative volume (cutout) for a square fan. can be centered on any axis
//   and includes a configurable buffer for clearance.
// Arguments:
//   xy_val = the width and height of the fan (square). must be a number representing the fan's
//     x and y dimensions
//   z = the depth/thickness of the fan cutout
//   buffer = additional clearance added in all directions. default is 1.
//   fillet = corner rounding radius for the cutout edges. default is 0.
//   x_center = if true, centers the cutout along the x axis. default is false.
//   y_center = if true, centers the cutout along the y axis. default is false.
//   z_center = if true, centers the cutout along the z axis. default is false.
module fan_negative(
    xy_val, z, buffer = 1, fillet = 0, x_center = false, y_center = false, z_center = false,
) {
    assert(is_num(xy_val), "xy_val should be a number for the x and y dimensions of the fan.");
    assert(is_num(z), "z should be a number for the fan thickness");

    assert(is_num(buffer), "buffer should be a number which will add slop in all directions");
    assert(
        is_num(fillet),
        "fillet should be a number that will add a filleted corner to the fan negative"
    );
    assert(is_bool(x_center), "x_center arg should be a boolean");
    assert(is_bool(y_center), "y_center arg should be a boolean");
    assert(is_bool(z_center), "z_center arg should be a boolean");

    x = xy_val + buffer;
    y = xy_val + buffer;
    z = z + buffer;

    x_trans = x_center ? x / 2 : 0;
    y_trans = y_center ? y / 2 : 0;
    z_trans = z_center ? z / 2 : 0;

    left(x_trans) fwd(y_trans) down(z_trans) {
        cuboid(
            [x, y, z],
            rounding = fillet,
            anchor = FRONT + LEFT + BOTTOM,
            edges = [LEFT + BACK, BACK + RIGHT, RIGHT + FRONT, FRONT + LEFT]
        );
    }
}

// Module: fan_mounting_holes()
// Description: creates negative volumes (screw cutouts) for fan mounting holes arranged in a
//   square pattern. each hole can be individually toggled via the `holes` parameter.
//   hole 0 = front-left, hole 1 = front-right, hole 2 = back-right, hole 3 = back-left.
// Arguments:
//   hole_spacing = the center-to-center spacing between opposite screw holes (width of the
//     square pattern)
//   hole_rad = the radius of each mounting screw hole
//   hole_depth = the depth of each mounting screw hole
//   thread_buffer = additional clearance added to the screw shaft radius. default is 0.
//   holes = list of hole indices to include. default is [0, 1, 2, 3] (all four holes)
module fan_mounting_holes(
    hole_spacing, hole_rad, hole_depth, thread_buffer = 0, holes = [0, 1, 2, 3],
) {
    if (contains(0, holes)) {
        left(hole_spacing / 2) fwd(hole_spacing / 2) {
            screw_cutout(
                screw_rad = hole_rad,
                countersink_rad = 0,
                countersink_depth = 0,
                total_length = hole_depth,
                thread_buffer = thread_buffer
            );
        }
    }

    if (contains(1, holes)) {
        right(hole_spacing / 2) fwd(hole_spacing / 2) {
            screw_cutout(
                screw_rad = hole_rad,
                countersink_rad = 0,
                countersink_depth = 0,
                total_length = hole_depth,
                thread_buffer = thread_buffer
            );
        }
    }

    if (contains(2, holes)) {
        right(hole_spacing / 2) back(hole_spacing / 2) {
            screw_cutout(
                screw_rad = hole_rad,
                countersink_rad = 0,
                countersink_depth = 0,
                total_length = hole_depth,
                thread_buffer = thread_buffer
            );
        }
    }

    if (contains(3, holes)) {
        left(hole_spacing / 2) back(hole_spacing / 2) {
            screw_cutout(
                screw_rad = hole_rad,
                countersink_rad = 0,
                countersink_depth = 0,
                total_length = hole_depth,
                thread_buffer = thread_buffer
            );
        }
    }
}
