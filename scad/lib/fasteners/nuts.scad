THREE_EIGHTHS_NUT_FLAT_TO_FLAT = inches_to_mm(3 / 8);

module nut_cutout(flat_to_flat, nut_height = 3, faces = 6, buffer = 0) {
    cylinder(h=nut_height, r=(flat_to_flat / 2 / cos(30)) + (buffer / 2), $fn=faces);
}
