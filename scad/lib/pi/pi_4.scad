include <./pi_sled_builder.scad>

PI_4__WIDTH = 56;
PI_4__DEPTH = 85;

PI_4__HOLES = [
    [3.5, 23.5],
    [52.5, 23.5],
    [3.5, 81.5],
    [52.5, 81.5],
];

PI_4__USB_IO_X_OFFSET_1 = 9;
PI_4__USB_IO_X_OFFSET_2 = 27;
PI_4__USB_IO_Z_OFFSET = 3;

PI_4__ETH_X_OFFSET = 45.75;

PI_4__BOARD_THICKNESS = 1.5;

// Module: pi_4_sled(sled_width, sled_depth, thickness, rad, wing_width, front_height, keystone_offset, mount_rad, motherboard_standoffs, motherboard_standoff_y_offset, has_keystone_left, has_keystone_right, has_vents)
// Description: creates a sled for a raspberry pi 4. forwards to the shared `sled_base` with the
//   pi 4 board dimensions and standoff positions, then adds usb and ethernet i/o cutouts to the
//   front panel with a filleted frame around each port.
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
//     default is `PI_4__HOLES`
//   motherboard_standoff_y_offset = additional y offset applied to all standoff positions. default
//     is 0
//   has_keystone_left = if true, adds a keystone bay to the left side of the front panel. default
//     is false
//   has_keystone_right = if true, adds a keystone bay to the right side of the front panel. default
//     is false
//   has_vents = if true, adds vent slots to the front panel. default is false
module pi_4_sled(
    sled_width = PI_SLED__BASE_X,
    sled_depth = PI_SLED__BASE_Y,
    thickness = PI_SLED__BASE_THICKNESS,
    rad = PI_SLED__FILLET_RAD,
    wing_width = PI_SLED__FRONT_WING_WIDTH,
    front_height = PI_SLED__FRONT_HEIGHT,
    keystone_offset = PI_SLED__FRONT__KEYSTONE_OFFSET,
    mount_rad = PI_SLED__MOUNT_RAD,
    motherboard_standoffs = PI_4__HOLES,
    motherboard_standoff_y_offset = 0,
    has_keystone_left = false,
    has_keystone_right = false,
    has_vents = false,
) {
    motherboard_standoff_x_offset = (sled_width - PI_4__WIDTH) / 2;

    port_x_base = motherboard_standoff_x_offset + wing_width;
    port_z_base = thickness + PI_4__USB_IO_Z_OFFSET + PI_4__BOARD_THICKNESS;
    usb_x_offsets = [PI_4__USB_IO_X_OFFSET_1, PI_4__USB_IO_X_OFFSET_2];

    difference() {
        sled_base(
            pi_width = PI_4__WIDTH,
            pi_depth = PI_4__DEPTH,
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

        for (x_offset = usb_x_offsets) {
            _pi_io_port_cutout(
                port_x_base + x_offset,
                port_z_base,
                PI_SLED__USB_CUTOUT_X_Y_Z,
                PI_SLED__PORT_BUFFER,
                1
            );
        }
        _pi_io_port_cutout(
            port_x_base + PI_4__ETH_X_OFFSET,
            port_z_base,
            PI_SLED__ETHERNET_CUTOUT_X_Y_Z,
            PI_SLED__PORT_BUFFER,
            1
        );
    }

    difference() {
        union() {
            for (x_offset = usb_x_offsets) {
                _pi_io_port_cutout(
                    port_x_base + x_offset,
                    port_z_base,
                    PI_SLED__USB_CUTOUT_X_Y_Z,
                    PI_SLED__PORT_BUFFER,
                    1
                );
            }
            _pi_io_port_cutout(
                port_x_base + PI_4__ETH_X_OFFSET,
                port_z_base,
                PI_SLED__ETHERNET_CUTOUT_X_Y_Z,
                PI_SLED__PORT_BUFFER,
                1
            );
        }

        union() {
            for (x_offset = usb_x_offsets) {
                _pi_io_port_cutout(
                    port_x_base + x_offset,
                    port_z_base + PI_SLED__PORT_BUFFER / 2,
                    PI_SLED__USB_CUTOUT_X_Y_Z,
                    0,
                    0
                );
            }
            _pi_io_port_cutout(
                port_x_base + PI_4__ETH_X_OFFSET,
                port_z_base + PI_SLED__PORT_BUFFER / 2,
                PI_SLED__ETHERNET_CUTOUT_X_Y_Z,
                0,
                0
            );
        }
    }
}

module _pi_io_port_cutout(x_pos, z_pos, cutout, buffer, rad) {
    right(x_pos) up(z_pos) {
        _pi_io_cutout(cutout[0] + buffer, cutout[1], cutout[2] + buffer, rad);
    }
}
