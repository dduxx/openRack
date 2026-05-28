include <../utils/unit_conversion.scad>

STANDARD_FILLET_RAD = 2;
FRONT_PLATE_THIKCNESS = 4;
FACET_NUMBER = 100;

TEN_THIRTYTWO_HOLE_RAD = inches_to_mm(3 / 16) / 2;
THREE_EIGHTHS_NUT_FLAT_TO_FLAT = inches_to_mm(3 / 8);

module screw_cutout(
    screw_rad = TEN_THIRTYTWO_HOLE_RAD,
    countersink_rad = 6,
    countersink_depth = FRONT_PLATE_THIKCNESS / 2,
    total_length = inches_to_mm(3 / 4),
    thread_buffer = 1
) {
    cylinder(h=total_length, r=screw_rad + (thread_buffer / 2));
    cylinder(h=countersink_depth, r=countersink_rad);
}

module nut_cutout(flat_to_flat = THREE_EIGHTHS_NUT_FLAT_TO_FLAT, nut_height = 3, faces = 6, buffer = 0) {
    cylinder(h=nut_height, r=(flat_to_flat / 2 / cos(30)) + (buffer / 2), $fn=faces);
}
