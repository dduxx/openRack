THREE_EIGHTHS_NUT_FLAT_TO_FLAT = inches_to_mm(3 / 8);

M4_FLAT_TO_FLAT = 7;

// Module: nut_cutout()
// Description: creates a negative volume (cutout) for a nut.
// Arguments:
//   flat_to_flat = flat-to-flat width of the nut
//   nut_height = height of the nut. default is 3
//   faces = number of faces used for the approximating cylinder. default is 6 (hexagonal nut)
//   buffer = additional clearance to add to the cutout diameter. default is 0.
module nut_cutout(flat_to_flat, nut_height = 3, faces = 6, buffer = 0) {
    cylinder(h=nut_height, r=(flat_to_flat / 2 / cos(30)) + (buffer / 2), $fn=faces);
}
