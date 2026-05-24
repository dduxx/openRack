include <unit_conversion.scad>

RACK_UNIT = inches_to_mm(1.75);

NINETEEN_INCH_STANDARD_WIDTH = inches_to_mm(19);
TEN_INCH_STANDARD_WIDTH = inches_to_mm(10);

RACK_UNIT_HOLE_SPACING = inches_to_mm(0.625);
RACK_UNIT_HOLE_BOTTOM_EDGE_OFFSET = inches_to_mm(0.5) / 2;
RACK_UNIT_HOLE_SIDE_EDGE_OFFSET = inches_to_mm(0.625) / 2;
HOLES_PER_UNIT = 3;

function calc_rack_unit_height(rack_units) = RACK_UNIT * rack_units;
