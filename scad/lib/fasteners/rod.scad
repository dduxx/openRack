include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>

QUARTER_INCH_THREADED_ROD_RAD = inches_to_mm(1/4) / 2;

module threaded_rod_cutout(rod_rad, rod_length, buffer = 1) {
    cylinder(h = rod_length, r = rod_rad + (buffer / 2));
}
