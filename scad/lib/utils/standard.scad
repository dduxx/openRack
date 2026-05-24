include <unit_conversion.scad>

STANDARD_FILLET_RAD = 2;
FRONT_PLATE_THIKCNESS = 4;
FACET_NUMBER = 100;

TEN_THIRTYTWO_HOLE_RAD = inches_to_mm(3 / 16) / 2;

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
