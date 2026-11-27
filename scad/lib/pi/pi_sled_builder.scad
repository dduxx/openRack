include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../fasteners/screws.scad>
include <../fasteners/nuts.scad>
include <../keystone/keystone.scad>
include <../rack_units.scad>

PI_SLED__BASE_X = 60;
PI_SLED__BASE_Y = 90;
PI_SLED__BASE_THICKNESS = 2.5;
PI_SLED__FILLET_RAD = 2;

PI_SLED__FRONT_HEIGHT = 33;
PI_SLED__FRONT_WING_WIDTH = 20;
PI_SLED__FRONT__KEYSTONE_OFFSET = 3;

PI_SLED__VENT_WIDTH = 3.5;
PI_SLED__VENT_SEPERATOR = 1.5;
PI_SLED__VENT_HEIGHT = PI_SLED__FRONT_HEIGHT - (3 * PI_SLED__BASE_THICKNESS);

PI_SLED__MOUNT_RAD = 6;

PI_SLED__STANDOFF_RAD_1 = 4;
PI_SLED__STANDOFF_RAD_2 = 2;
PI_SLED__STANDOFF_HEIGHT = 5;

PI_SLED__USB_CUTOUT_X_Y_Z = [16, PI_SLED__BASE_THICKNESS, 18];
PI_SLED__ETHERNET_CUTOUT_X_Y_Z = [18, PI_SLED__BASE_THICKNESS, 15];
PI_SLED__PORT_BUFFER = 2;

PI_SLED__MOUNT_CUTOUT_BUFFER = 1.5;

// Module: sled_base(pi_width, pi_depth, sled_width, sled_depth, thickness, rad, wing_width, front_height, keystone_offset, mount_rad, motherboard_standoffs, motherboard_standoff_y_offset, has_keystone_left, has_keystone_right, has_vents)
// Description: creates the base plate and front panel of a pi sled. includes an integrated mounting
//   boss, optional keystone bays, optional vents, and optional motherboard standoffs.
// Arguments:
//   pi_width = the width of the motherboard that will be mounted on the sled. required.
//   pi_depth = the depth of the motherboard. required.
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
//     default is `undef` (no standoffs)
//   motherboard_standoff_y_offset = additional y offset applied to all standoff positions. default
//     is 0
//   has_keystone_left = if true, adds a keystone bay to the left side of the front panel. default
//     is false
//   has_keystone_right = if true, adds a keystone bay to the right side of the front panel. default
//     is false
//   has_vents = if true, adds vent slots to the front panel. default is false
module sled_base(
    pi_width,
    pi_depth,
    sled_width = PI_SLED__BASE_X,
    sled_depth = PI_SLED__BASE_Y,
    thickness = PI_SLED__BASE_THICKNESS,
    rad = PI_SLED__FILLET_RAD,
    wing_width = PI_SLED__FRONT_WING_WIDTH,
    front_height = PI_SLED__FRONT_HEIGHT,
    keystone_offset = PI_SLED__FRONT__KEYSTONE_OFFSET,
    mount_rad = PI_SLED__MOUNT_RAD,
    motherboard_standoffs = undef,
    motherboard_standoff_y_offset = 0,
    has_keystone_left = false,
    has_keystone_right = false,
    has_vents = false,
) {
    motherboard_standoff_x_offset = (sled_width - pi_width) / 2;

    right(wing_width) {
        union() {
            difference() {
                union() {
                    cuboid(
                        [sled_width, sled_depth, thickness],
                        rounding = rad,
                        edges = [
                            LEFT + BACK,
                            BACK + RIGHT,
                        ],
                        anchor = FRONT + LEFT + BOTTOM
                    );

                    left(wing_width) {
                        cuboid(
                            [
                                (wing_width * 2) + sled_width,
                                thickness,
                                front_height,
                            ],
                            rounding = rad,
                            anchor = FRONT + LEFT + BOTTOM,
                            edges = [
                                BOTTOM + LEFT,
                                LEFT + TOP,
                                TOP + RIGHT,
                                RIGHT + BOTTOM
                            ]
                        );
                    }
                    right(sled_width / 2) up(front_height) {
                        _pi_sled_mount(thickness = thickness);
                    }

                    if (motherboard_standoffs != undef) {
                        assert(
                            is_list(motherboard_standoffs),
                            "motherboard standoffs should be a list of standoff point positions"
                        );

                        right(motherboard_standoff_x_offset) {
                            back(motherboard_standoff_y_offset) {
                                up(thickness) {
                                    for (i = [0 : len(motherboard_standoffs) - 1]) {
                                        point_xy = motherboard_standoffs[i];

                                        assert(
                                            is_list(point_xy) && len(point_xy) == 2,
                                            "motherboard standoff point should be a x, y vector"
                                        );

                                        right(point_xy[0]) back(point_xy[1] + thickness) {
                                            _pi_board_stand();
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                if (has_keystone_left) {
                    left(wing_width - keystone_offset) {
                        up((front_height - KEYSTONE__OUTER_Z) / 2) {
                            keystone_negative();
                        }
                    }
                }

                if (has_keystone_right) {
                    right(
                        sled_width + wing_width -
                            keystone_offset - KEYSTONE__OUTER_X
                    ) {
                        up((front_height - KEYSTONE__OUTER_Z) / 2) {
                            keystone_negative();
                        }
                    }
                }

                if (has_vents) {
                    right(sled_width / 2) up((front_height - PI_SLED__VENT_HEIGHT) / 2) {
                        _pi_sled_vents();
                    }
                }

                right(sled_width / 2) back(thickness) up(front_height + mount_rad / 2) {
                    xrot(90) {
                        cylinder(r = SCREWS__M4_RAD, h = thickness);
                    }
                }


                if (motherboard_standoffs != undef) {
                    right(motherboard_standoff_x_offset) {
                        back(motherboard_standoff_y_offset) {
                            for (i = [0 : len(motherboard_standoffs) - 1]) {
                                point_xy = motherboard_standoffs[i];

                                right(point_xy[0]) back(point_xy[1] + thickness) {
                                    _pi_board_stand_screw_cutout();
                                }
                            }
                        }
                    }
                }
            }

            if (has_keystone_left) {
                left(wing_width - keystone_offset) {
                    back(KEYSTONE__OUTER_Y) {
                        up((front_height - KEYSTONE__OUTER_Z) / 2) {
                            yflip() {
                                keystone();
                            }
                        }
                    }
                }
            }

            if (has_keystone_right) {
                right(
                    sled_width + wing_width -
                        keystone_offset - KEYSTONE__OUTER_X
                ) {
                    back(KEYSTONE__OUTER_Y) {
                        up((front_height - KEYSTONE__OUTER_Z) / 2) {
                            yflip() {
                                keystone();
                            }
                        }
                    }
                }
            }

        }
    }
}

// Module: pi_sled_mount_negative(width, depth, height, rad, mount_hole_rad, mount_rad)
// Description: creates a negative volume (cutout) for the sled mount and its screw hole, used to
//   carve a socket in a faceplate that accepts the front of a pi sled.
// Arguments:
//   width = the total width of the mount cutout. default is the sled front width minus a buffer
//   depth = the depth of the mount cutout. default is `PI_SLED__BASE_THICKNESS`
//   height = the height of the mount cutout. default is `PI_SLED__FRONT_HEIGHT`
//   rad = the corner rounding radius of the cutout. default is `PI_SLED__FILLET_RAD`
//   mount_hole_rad = the radius of the mount screw hole. default is `SCREWS__M4_RAD`
//   mount_rad = the radius of the mount boss. default is `PI_SLED__MOUNT_RAD`
module pi_sled_mount_negative(
    width = (PI_SLED__FRONT_WING_WIDTH * 2) +
        PI_SLED__BASE_X -
        (2 * PI_SLED__MOUNT_CUTOUT_BUFFER),
    depth = PI_SLED__BASE_THICKNESS,
    height = PI_SLED__FRONT_HEIGHT,
    rad = PI_SLED__FILLET_RAD,
    mount_hole_rad = SCREWS__M4_RAD,
    mount_rad = PI_SLED__MOUNT_RAD,
) {
    cuboid(
        [width, depth, height],
        rounding = rad,
        edges = [
            BOTTOM + LEFT,
            LEFT + TOP,
            TOP + RIGHT,
            RIGHT + BOTTOM,
        ],
        anchor = FRONT
    );

    back(depth) up((height / 2) + (mount_rad / 2)) {
        xrot(90) {
            cylinder(r = mount_hole_rad, h = depth);
        }
    }
}

// Module: pi_sled_mount_retaining_nut_negative(sled_width, sled_height, mount_rad, nut_flat_to_flat, nut_point_to_point, nut_height)
// Description: creates a negative volume (cutout) for capturing a nut that retains a pi sled mount,
//   including a clearance channel for sliding the nut into place.
// Arguments:
//   sled_width = the total width of the sled front. default is the sled front width minus a buffer
//   sled_height = the height of the sled front. default is `PI_SLED__FRONT_HEIGHT`
//   mount_rad = the radius of the mount boss. default is `PI_SLED__MOUNT_RAD`
//   nut_flat_to_flat = the flat-to-flat width of the retaining nut. default is `NUTS__M4_FLAT_TO_FLAT`
//   nut_point_to_point = the point-to-point width of the retaining nut. default is `NUTS__M4_POINT_TO_POINT`
//   nut_height = the height of the retaining nut. default is 4
module pi_sled_mount_retaining_nut_negative(
    sled_width = (PI_SLED__FRONT_WING_WIDTH * 2) +
        PI_SLED__BASE_X -
        (2 * PI_SLED__MOUNT_CUTOUT_BUFFER),
    sled_height = PI_SLED__FRONT_HEIGHT,
    mount_rad = PI_SLED__MOUNT_RAD,
    nut_flat_to_flat = NUTS__M4_FLAT_TO_FLAT,
    nut_point_to_point = NUTS__M4_POINT_TO_POINT,
    nut_height = 4,
) {
    up((sled_height / 2) + (mount_rad / 2)) {
        back(nut_height) {
            xrot(90) {
                nut_cutout(flat_to_flat = nut_flat_to_flat, nut_height = nut_height, buffer = 0.2);
            }
        }
        left(nut_point_to_point / 2) {
            cube([nut_point_to_point, nut_height, 10]);
        }
    }
}

module _pi_board_stand(
    r1 = PI_SLED__STANDOFF_RAD_1,
    r2 = PI_SLED__STANDOFF_RAD_2,
    h = PI_SLED__STANDOFF_HEIGHT
) {
    cylinder(h = h, r1 = r1, r2 = r2);
}

module _pi_board_stand_screw_cutout(
    screw_rad = SCREWS__M3_RAD,
    screw_length = 10,
    nut_flat_to_flat = NUTS__M3_FLAT_TO_FLAT,
    nut_thickness = 2.5,
) {
    screw_cutout(
        screw_rad = screw_rad,
        total_length = screw_length,
        thread_buffer = 0.5
    );
    nut_cutout(
        flat_to_flat = nut_flat_to_flat,
        nut_height = nut_thickness,
        faces = 6,
        buffer = 0.2
    );
}

module _pi_sled_vents(
    vent_width = PI_SLED__VENT_WIDTH,
    vent_seperator = PI_SLED__VENT_SEPERATOR,
    vent_height = PI_SLED__VENT_HEIGHT,
    thickness = PI_SLED__BASE_THICKNESS,
    num_vents = 11,
) {
    area_width = (vent_width * num_vents) + ((num_vents + 1) * vent_seperator);
    rad = vent_width / 2;

    left(area_width / 2 - vent_seperator) back(thickness) {
        xrot(90) {
            for (i = [0 : num_vents - 1]) {
                right(i * (vent_width + vent_seperator)) {
                    right(rad) back(rad) {
                        cylinder(r = rad, h = thickness);
                    }
                    back(rad) {
                        cube([vent_width, vent_height - vent_width, thickness]);
                    }
                    right(rad) back(vent_height - rad) {
                        cylinder(r = rad, h = thickness);
                    }
                }
            }
        }
    }
}

module _pi_sled_mount(mount_rad = PI_SLED__MOUNT_RAD, thickness = PI_SLED__BASE_THICKNESS) {
    back(thickness) {
        xrot(90) {
            difference() {
                cylinder(h = thickness, r = mount_rad);
                left(mount_rad) fwd(mount_rad * 2) {
                    cube([mount_rad * 2, mount_rad * 2, thickness]);
                }
            }
        }
    }
}

module _pi_io_cutout(x, y, z, rad = 0) {
    cuboid(
        [x, y, z],
        anchor = FRONT + BOTTOM,
        rounding = rad,
        edges = [
            LEFT + TOP,
            TOP + RIGHT,
            RIGHT + BOTTOM,
            BOTTOM + LEFT,
        ]
    );
}
