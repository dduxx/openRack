include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>

QUARTER_INCH_THREADED_ROD_RAD = inches_to_mm(1/4) / 2;

// Module: threaded_rod_cutout()
// Description: creates a negative volume (cutout) for a threaded rod.
// Arguments:
//   rod_rad = the radius of the threaded rod
//   rod_length = the length of the threaded rod
//   buffer = additional clearance to add to the cutout diameter. default is 1.
module threaded_rod_cutout(rod_rad, rod_length, buffer = 1) {
    cylinder(h = rod_length, r = rod_rad + (buffer / 2));
}
