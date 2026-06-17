include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../rack_units.scad>
include <../fasteners/screws.scad>

FRONT_PLATE_THICKNESS = 4;
FACEPLATE_FILLET_RAD = 2;
FACEPLATE_JOIN_SUPPORT_X = 0;
FACEPLATE_JOIN_SUPPORT_Y = 0;
FACEPLATE_JOIN_SUPPORT_Z = 0;

module faceplate(
    rack_units = 1,
    width = NINETEEN_INCH_STANDARD_WIDTH,
    thickness = FRONT_PLATE_THICKNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    holes_on_left = true,
    holes_on_right = true,
    fillet_left = true,
    fillet_right = true,
    join_support_left = false,
    join_support_right = false,
    countersink_rad = 0,
) {
    left_edge = fillet_left ? [LEFT + BOTTOM, LEFT + TOP] : [];
    right_edge = fillet_right ? [RIGHT + BOTTOM, RIGHT + TOP] : [];

    // main faceplate
    difference() {
        cuboid(
            [width, thickness, RACK_UNIT * rack_units],
            rounding=rad,
            edges=concat(left_edge, right_edge),
            anchor=FRONT + LEFT + BOTTOM
        );

        // mounting holes
        for (i = [0:rack_units - 1]) {
            for (j = [0:HOLES_PER_UNIT - 1]) {
                hole_num = (i * 3) + (j);
                if (!(len(search(hole_num, skip_holes)) > 0)) {
                    if (holes_on_left) {
                        right(RACK_UNIT_HOLE_SIDE_EDGE_OFFSET) {
                            up(
                                RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET +
                                    (RACK_UNIT_HOLE_SPACING * j) +
                                    (RACK_UNIT * i)
                            ) {
                                rotate([-90, 0, 0]) {
                                    screw_cutout(
                                        TEN_THIRTY_TWO_SCREW_RAD,
                                        countersink_rad = countersink_rad,
                                        countersink_depth = FRONT_PLATE_THICKNESS / 2
                                    );
                                }
                            }
                        }
                    }

                    if (holes_on_right) {
                        right(width - RACK_UNIT_HOLE_SIDE_EDGE_OFFSET) {
                            up(
                                RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET +
                                (RACK_UNIT_HOLE_SPACING * j) +
                                (RACK_UNIT * i)
                            ) {
                                rotate([-90, 0, 0]) {
                                    screw_cutout(
                                        TEN_THIRTY_TWO_SCREW_RAD,
                                        countersink_rad = countersink_rad,
                                        countersink_depth = FRONT_PLATE_THICKNESS / 2
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // left join support
    if (join_support_left) {
        back(thickness) {
            xflip() {
                _join_support(rack_units, thickness, rad);
            }
        }
    }

    // right join support
    if (join_support_right) {
        right(width) back(thickness) {
            _join_support(rack_units, thickness, rad);
        }
    }
}

module vented_faceplate(
    rack_units = 1,
    width = NINETEEN_INCH_STANDARD_WIDTH,
    thickness = FRONT_PLATE_THICKNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    holes_on_left = true,
    holes_on_right = true,
    fillet_left = true,
    fillet_right = true,
    join_support_left = false,
    join_support_right = false,
    countersink_rad = 0,
    vent_width = 3.5,
    vent_sperator_width = 1.5
) {
    difference() {
        faceplate(
            rack_units = rack_units,
            width = width,
            thickness = thickness,
            rad = rad,
            skip_holes = skip_holes,
            holes_on_left = holes_on_left,
            holes_on_right = holes_on_right,
            fillet_left = fillet_left,
            fillet_right = fillet_right,
            join_support_left = join_support_left,
            join_support_right = join_support_right,
            countersink_rad = countersink_rad,
        );

        vented_area_width = width - (5 * RACK_UNIT_HOLE_SIDE_EDGE_OFFSET);
        vented_area_height = RACK_UNIT - (2 * RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET);

        num_vents = floor(vented_area_width / (vent_width + vent_sperator_width));
        actual_vented_area_width = (num_vents * (vent_width + vent_sperator_width)) +
            vent_sperator_width;

        for (i = [0:rack_units - 1]) {
            translate([(width - vented_area_width) / 2, 0, i * (RACK_UNIT)]) {
                for (j = [0:num_vents - 1]) {
                    right(vent_width + (j * vent_width) + (j * vent_sperator_width)) {
                        back(thickness) {
                            up((vent_width / 2) + (RACK_UNIT - vented_area_height) / 2) {
                                rotate([90, 0, 0]) {
                                    hull() {
                                        cylinder(h=thickness, r=vent_width / 2);

                                        translate([0, vented_area_height - (vent_width), 0]) {
                                            cylinder(h=thickness, r=vent_width / 2);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

module _join_support(rack_units, thickness, fillet) {
    difference() {
        cuboid(
            [thickness, 3 * thickness, RACK_UNIT * rack_units],
            edges = [TOP + BACK, BACK + BOTTOM],
            rounding = fillet,
            anchor = RIGHT + FRONT + BOTTOM
        );

        left(thickness) {
            back((3 * thickness) / 2) {
                up((RACK_UNIT * rack_units) - (RACK_UNIT * rack_units / 5)) {
                    yrot(90) {
                        screw_cutout(
                            screw_rad = M4_SCREW_RAD,
                            countersink_rad = 2 * M4_SCREW_RAD,
                            countersink_depth = thickness / 2,
                            total_length = thickness,
                            thread_buffer = 0.2
                        );
                    }
                }
            }
        }

        left(thickness) {
            back((3 * thickness) / 2) {
                up((RACK_UNIT * rack_units / 5)) {
                    yrot(90) {
                        screw_cutout(
                            screw_rad = M4_SCREW_RAD,
                            countersink_rad = 2 * M4_SCREW_RAD,
                            countersink_depth = thickness / 2,
                            total_length = thickness,
                            thread_buffer = 0.2
                        );
                    }
                }
            }
        }
    }
}
