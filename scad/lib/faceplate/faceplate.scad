include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../const/rack_units.scad>
include <../const/standard.scad>

$fn = FACET_NUMBER;

FACEPLATE_FILLET_RAD = 2;

module faceplate(
    rack_units = 1,
    width = NINETEEN_INCH_STANDARD_WIDTH,
    thickness = FRONT_PLATE_THIKCNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    holes_on_left = true,
    holes_on_right = true
) {
    difference() {
        cuboid(
            [width, thickness, RACK_UNIT * rack_units],
            rounding=rad,
            edges=[LEFT + TOP, LEFT + BOTTOM, RIGHT + TOP, RIGHT + BOTTOM],
            anchor=FRONT + LEFT + BOTTOM
        );

        for (i = [0:rack_units - 1]) {
            for (j = [0:HOLES_PER_UNIT - 1]) {
                hole_num = (i * 3) + (j);
                if (!(len(search(hole_num, skip_holes)) > 0)) {
                    if (holes_on_left) {
                        translate(v=[RACK_UNIT_HOLE_SIDE_EDGE_OFFSET, 0, RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET + (RACK_UNIT_HOLE_SPACING * j) + (RACK_UNIT * i)]) {
                            rotate([-90, 0, 0]) {
                                screw_cutout();
                            }
                        }
                    }

                    if (holes_on_right) {
                        translate(v=[-RACK_UNIT_HOLE_SIDE_EDGE_OFFSET + width, 0, RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET + (RACK_UNIT_HOLE_SPACING * j) + (RACK_UNIT * i)]) {
                            rotate([-90, 0, 0]) {
                                screw_cutout();
                            }
                        }
                    }
                }
            }
        }
    }
}

module vented_faceplate(
    rack_units = 1,
    width = NINETEEN_INCH_STANDARD_WIDTH,
    thickness = FRONT_PLATE_THIKCNESS,
    rad = FACEPLATE_FILLET_RAD,
    skip_holes = [],
    holes_on_left = true,
    holes_on_right = true,
    vent_width = 3.5,
    vent_sperator_width = 1.5
) {
    difference() {
        faceplate(
            rack_units,
            width,
            thickness,
            rad,
            skip_holes,
            holes_on_left,
            holes_on_right
        );

        vented_area_width = width - (5 * RACK_UNIT_HOLE_SIDE_EDGE_OFFSET);
        vented_area_height = RACK_UNIT - (2 * RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET);

        num_vents = floor(vented_area_width / (vent_width + vent_sperator_width));
        actual_vented_area_width = (num_vents * (vent_width + vent_sperator_width)) + vent_sperator_width;

        for (i = [0:rack_units - 1]) {
            translate([(width - vented_area_width) / 2, 0, i * (RACK_UNIT)]) {
                for (j = [0:num_vents - 1]) {
                    translate([vent_width + (j * vent_width) + (j * vent_sperator_width), thickness, (vent_width / 2) + (RACK_UNIT - vented_area_height) / 2]) {
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
