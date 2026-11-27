include <../../../lib/faceplate/ears.scad>
include <../../../lib/rack_units.scad>
include <../../../lib/pi/pi_sled_builder.scad>
include <../../../../dependencies/BelfrySCAD:BOSL2:v2.0.741/std.scad>
include <../../../lib/fasteners/screws.scad>

EAR_TYPE = "LEFT"; // [LEFT, RIGHT]
PI_SLED = "NONE"; // [NONE, LEFT, RIGHT]

module __Customizer_Limit__ () {}

$fn = 100;

DGS_1024D_WIDTH = 281.9;
DGS_1024D_MOUNTING_SLOT_LENGTH = 30;
DGS_1024D_MOUNTING_SLOT_OFFSET = 12;
DGS_1024D_MOUNTING_DISTANCE_BETWEEN_HOLES = 20;
DGS_1024D_MOUNTING_BOTTOM_OFFSET = (RACK_UNIT - DGS_1024D_MOUNTING_DISTANCE_BETWEEN_HOLES) / 2;

PI_SIDE_EAR_WIDTH = 155;

EAR_WIDTH = PI_SLED == EAR_TYPE ? PI_SIDE_EAR_WIDTH :
    PI_SLED != "NONE" ? NINETEEN_INCH_STANDARD_WIDTH - PI_SIDE_EAR_WIDTH - DGS_1024D_WIDTH :
    (NINETEEN_INCH_STANDARD_WIDTH - DGS_1024D_WIDTH) / 2;

IS_LEFT_EAR = EAR_TYPE == "LEFT";

PI_PANEL_SKIP_HOLES = [1];

PI_RACK_Z_OFFSET = FACEPLATE__PLATE_THICKNESS;

PI_RACK_SUPPORT_WIDTH = 45;
PI_RACK_SUPPORT_DEPTH = 20;

PI_RACK_RETENTION_NUT_WIDTH = 10;
PI_RACK_RETENTION_NUT_DEPTH = 6;
PI_RACK_RETENTION_NUT_HEIGHT = RACK_UNIT - PI_SLED__FRONT_HEIGHT - PI_RACK_Z_OFFSET;

difference() {
    union() {
        rack_ear(
            width = EAR_WIDTH,
            ear_depth = 80,
            is_left_ear = IS_LEFT_EAR,
            rack_units = 1,
            thickness = FACEPLATE__PLATE_THICKNESS,
            rad = FACEPLATE__FILLET_RAD,
            skip_holes = [1],
            has_bottom_support = true,
            countersink_rad = 0
        );

        if (PI_SLED == EAR_TYPE) {
            right(EAR_WIDTH / 2) back(FACEPLATE__PLATE_THICKNESS) up(RACK_UNIT) {
                cuboid(
                    [
                        PI_RACK_RETENTION_NUT_WIDTH,
                        PI_RACK_RETENTION_NUT_DEPTH,
                        PI_RACK_RETENTION_NUT_HEIGHT,
                    ],
                    edges = [
                        LEFT + BACK,
                        BACK + RIGHT,
                        TOP + BACK,
                        BOTTOM + BACK,
                    ],
                    rounding = 1.5,
                    anchor = TOP + FRONT,
                );
            }
        }
    }

    if (PI_SLED == EAR_TYPE) {
        right(EAR_WIDTH / 2) up((PI_SLED__FRONT_HEIGHT / 2) + PI_RACK_Z_OFFSET) {
            pi_sled_mount_negative(depth = FACEPLATE__PLATE_THICKNESS);
            back(FACEPLATE__PLATE_THICKNESS) {
                pi_sled_mount_retaining_nut_negative();
            }
        }
    }

    ear_x_trans = EAR_TYPE == "LEFT" ? EAR_WIDTH - FACEPLATE__PLATE_THICKNESS : 0;
    right(ear_x_trans) back(DGS_1024D_MOUNTING_SLOT_LENGTH / 2 + DGS_1024D_MOUNTING_SLOT_OFFSET) {
        up(DGS_1024D_MOUNTING_BOTTOM_OFFSET) {
            xrot(90) yrot(90) {
                screw_slot(
                    screw_rad = SCREWS__M4_RAD,
                    slot_width = DGS_1024D_MOUNTING_SLOT_LENGTH,
                    total_length = FACEPLATE__PLATE_THICKNESS,
                    thread_buffer = 0.5
                );
            }
        }

        up(DGS_1024D_MOUNTING_BOTTOM_OFFSET + DGS_1024D_MOUNTING_DISTANCE_BETWEEN_HOLES) {
            xrot(90) yrot(90) {
                screw_slot(
                    screw_rad = SCREWS__M4_RAD,
                    slot_width = DGS_1024D_MOUNTING_SLOT_LENGTH,
                    total_length = FACEPLATE__PLATE_THICKNESS,
                    thread_buffer = 0.5
                );
            }
        }
    }

}
