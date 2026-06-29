include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>

HDD_SCREW_RAD = 3.5 / 2;

TEN_THIRTY_TWO_SCREW_RAD = inches_to_mm(3/16) / 2;

M4_SCREW_RAD = 2;

module screw_cutout(
    screw_rad,
    countersink_rad = 0,
    countersink_depth = 0,
    total_length = inches_to_mm(3 / 4),
    thread_buffer = 1,
) {
    cylinder(h=total_length, r=screw_rad + (thread_buffer / 2));

    if (countersink_depth > 0) {
        cylinder(h=countersink_depth, r=countersink_rad);
    }
}

module screw_slot(
    screw_rad,
    slot_width,
    countersink_rad = 0,
    countersink_depth = 0,
    total_length = inches_to_mm(3 / 4),
    thread_buffer = 1,
) {
    assert(
        slot_width > (screw_rad * 2) + thread_buffer,
        "the slot must be wider than the screw itself"
    );
    x_trans = (slot_width - (screw_rad * 2) - thread_buffer) / 2;

    hull() {
        left(x_trans) {
            cylinder(h=total_length, r=screw_rad + (thread_buffer / 2));
        }

        right(x_trans) {
            cylinder(h=total_length, r=screw_rad + (thread_buffer / 2));
        }
    }

    if (countersink_depth > 0) {
        hull() {
            left(x_trans) {
                cylinder(h=countersink_depth, r=countersink_rad);
            }

            right(x_trans) {
                cylinder(h=countersink_depth, r=countersink_rad);
            }
        }
    }
}
