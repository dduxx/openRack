include <../../lib/hdd/sled_builder.scad>

SLED_TYPE = "default"; // [default, 2_5_adapter]
HAS_LABEL = true;

module __Customizer_Limit__ () {}

$fn = 100;

// cutouts
HAS_BOTTOM_CUTOUT = true;
HAS_SCREW_SLOTS = true;
HAS_CONNECTOR_CUTOUT = true;

// front panel
HAS_VENTS = true;

if (SLED_TYPE == "default") {
    three_point_five_inch_drive_sled(
        drive_sled_wall = DRIVE_SLED__WALL,
        drive_sled_floor = DRIVE_SLED__FLOOR,
        drive_sled_front_depth = DRIVE_SLED__FRONT_DEPTH,
        edge_fillet = DRIVE_SLED__EDGE_FILLET,
        has_bottom_cutout = HAS_BOTTOM_CUTOUT,
        has_screw_slots = HAS_SCREW_SLOTS,
        has_connector_cutout = HAS_CONNECTOR_CUTOUT,
        has_label = HAS_LABEL,
        has_vents = HAS_VENTS,
    );
} else if (SLED_TYPE == "2_5_adapter") {
    three_point_five_to_two_point_five_inch_drive_sled(
        drive_sled_wall = DRIVE_SLED__WALL,
        drive_sled_floor = DRIVE_SLED__FLOOR,
        drive_sled_front_depth = DRIVE_SLED__FRONT_DEPTH,
        edge_fillet = DRIVE_SLED__EDGE_FILLET,
        has_bottom_cutout = HAS_BOTTOM_CUTOUT,
        has_screw_slots = HAS_SCREW_SLOTS,
        has_connector_cutout = HAS_CONNECTOR_CUTOUT,
        has_label = HAS_LABEL,
        has_vents = HAS_VENTS,
    );
} else {
    assert(false, "Unsupported sled type");
}
