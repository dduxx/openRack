include <../../lib/hdd/sled.scad>

// general sled dimensions
DRIVE_SLED_WALL = 1.5;
DRIVE_SLED_FRONT_DEPTH = 10;
DRIVE_SLED_LATCH_EDGE_OFFSET = 15;
DRIVE_SLED_LATCH_HOOK = 4;
DRIVE_SLED_LATCH_HEIGHT = (DRIVE_SLED_WALL + THREE_POINT_FIVE_HDD_HEIGHT) - (2 * DRIVE_SLED_WALL);

DRIVE_SLED_EDGE_FILLET = 1;

// cutouts
HAS_BOTTOM_CUTOUT = true;
HAS_SCREW_SLOTS = true;
HAS_CONNECTOR_CUTOUT = true;

// front panel
HAS_VENTS = true;
HAS_LABEL = true;

SLED_TYPES = [
    "default",
    "2_5_adapter"
];

SLED_TYPE = "default";

if (SLED_TYPE == "default") {
    three_point_five_inch_drive_sled(
        drive_sled_wall = DRIVE_SLED_WALL,
        drive_sled_front_depth = DRIVE_SLED_FRONT_DEPTH,
        edge_fillet = 1,
        has_bottom_cutout = HAS_BOTTOM_CUTOUT,
        has_screw_slots = HAS_SCREW_SLOTS,
        has_connector_cutout = HAS_CONNECTOR_CUTOUT,
        has_label = HAS_LABEL,
        has_vents = HAS_VENTS,
    );
} else if (SLED_TYPE == "2_5_adapter") {
    three_point_five_to_two_point_five_inch_drive_sled(
        drive_sled_wall = DRIVE_SLED_WALL,
        drive_sled_front_depth = DRIVE_SLED_FRONT_DEPTH,
        edge_fillet = 1,
        has_bottom_cutout = HAS_BOTTOM_CUTOUT,
        has_screw_slots = HAS_SCREW_SLOTS,
        has_connector_cutout = HAS_CONNECTOR_CUTOUT,
        has_label = HAS_LABEL,
        has_vents = HAS_VENTS,
    );
} else {
    assert(false, "Unsupported sled type");
}
