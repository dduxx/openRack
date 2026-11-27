include <./pi_sled_builder.scad>

PI_0__WIDTH = 30;
PI_0__DEPTH = 65;

PI_0__HOLES = [
    [3.5, 3.5],
    [26.5, 3.5],
    [3.5, 61.5],
    [26.5, 61.5],
];

// Module: pi_0_sled(sled_width, sled_depth, thickness, rad, wing_width, front_height, keystone_offset, mount_rad, motherboard_standoffs, motherboard_standoff_y_offset, has_keystone_left, has_keystone_right, has_vents)
// Description: creates a sled for a raspberry pi zero. forwards to the shared `sled_base` with the
//   pi zero board dimensions and standoff positions.
// Arguments:
//   sled_width = the width of the sled base plate. default is `PI_SLED__BASE_X`
//   sled_depth = the depth of the sled base plate. default is `PI_SLED__BASE_Y`
//   thickness = the thickness of the base plate. default is `PI_SLED__BASE_THICKNESS`
//   rad = the corner rounding radius used on the base plate and front wings. default is
//     `PI_SLED__FILLET_RAD`
//   wing_width = the width of the front wings that extends to each side of the base plate. default
//     is `PI_SLED__FRONT_WING_WIDTH`
//   front_height = the height of the front panel. default is `PI_SLED__FRONT_HEIGHT`
//   keystone_offset = the distance from the wing edge to the keystone bay. default is
//     `PI_SLED__FRONT__KEYSTONE_OFFSET`
//   mount_rad = the radius of the sled mounting boss. default is `PI_SLED__MOUNT_RAD`
//   motherboard_standoffs = a list of [x, y] coordinates for the motherboard standoff pillars.
//     default is `PI_0__HOLES`
//   motherboard_standoff_y_offset = additional y offset applied to all standoff positions. default
//     is 5, an extra buffer for the pi zero's front i/o
//   has_keystone_left = if true, adds a keystone bay to the left side of the front panel. default
//     is false
//   has_keystone_right = if true, adds a keystone bay to the right side of the front panel. default
//     is false
//   has_vents = if true, adds vent slots to the front panel. default is false
module pi_0_sled(
    sled_width = PI_SLED__BASE_X,
    sled_depth = PI_SLED__BASE_Y,
    thickness = PI_SLED__BASE_THICKNESS,
    rad = PI_SLED__FILLET_RAD,
    wing_width = PI_SLED__FRONT_WING_WIDTH,
    front_height = PI_SLED__FRONT_HEIGHT,
    keystone_offset = PI_SLED__FRONT__KEYSTONE_OFFSET,
    mount_rad = PI_SLED__MOUNT_RAD,
    motherboard_standoffs = PI_0__HOLES,
    motherboard_standoff_y_offset = 5,
    has_keystone_left = false,
    has_keystone_right = false,
    has_vents = false,
) {
    sled_base(
        pi_width = PI_0__WIDTH,
        pi_depth = PI_0__DEPTH,
        sled_width = sled_width,
        sled_depth = sled_depth,
        thickness = thickness,
        rad = rad,
        wing_width = wing_width,
        front_height = front_height,
        keystone_offset = keystone_offset,
        mount_rad = mount_rad,
        motherboard_standoffs = motherboard_standoffs,
        motherboard_standoff_y_offset = motherboard_standoff_y_offset,
        has_keystone_left = has_keystone_left,
        has_keystone_right = has_keystone_right,
        has_vents = has_vents,
    );
}
