include <../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../dependencies/dduxx:scadUnitConversionLib:v1.0.0/scad/lib/conversion.scad>

HDD_SCREW_RAD = 3.5 / 2;

TEN_THIRTY_TWO_SCREW_RAD = inches_to_mm(3/16) / 2;

M4_SCREW_RAD = 2;
M3_SCREW_RAD = 1.5;

// Module: screw_cutout()
// Description: creates a negative volume (cutout) for a screw. includes an optional countersink
//   pocket on top of the screw shaft.
// Arguments:
//   screw_rad = the radius of the screw shaft
//   countersink_rad = radius of the countersink pocket. default is 0 (disabled)
//   countersink_depth = depth of the countersink pocket. default is 0 (disabled)
//   total_length = the total depth of the cutout including the countersink. default is 3/4 inch
//   thread_buffer = additional clearance added to the screw shaft diameter. default is 1.
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

// Module: screw_slot()
// Description: creates a negative volume (cutout) shaped as an elongated slot for a screw.
//   useful for rack mounting holes that need horizontal adjustment. includes an optional
//   countersink pocket.
// Arguments:
//   screw_rad = the radius of the screw shaft
//   slot_width = the total width of the slot (must be wider than the screw diameter)
//   countersink_rad = radius of the countersink pocket. default is 0 (disabled)
//   countersink_depth = depth of the countersink pocket. default is 0 (disabled)
//   total_length = the total depth of the cutout including the countersink. default is 3/4 inch
//   thread_buffer = additional clearance added to the screw shaft diameter. default is 1.
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
