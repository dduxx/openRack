include <../../lib/pi/pi_4.scad>
include <../../lib/pi/pi_0.scad>

PI_TYPE = "pi_4"; // [pi_4, pi_0]

HAS_VENTS = true;
HAS_KEYSTONE_LEFT = true;
HAS_KEYSTONE_RIGHT = true;

module __Customizer_Limit__ () {}

$fn = 100;

if (PI_TYPE == "pi_4") {
    pi_4_sled(
        has_keystone_left = HAS_KEYSTONE_LEFT,
        has_keystone_right = HAS_KEYSTONE_RIGHT,
        has_vents = HAS_VENTS
    );
} else if (PI_TYPE == "pi_0") {
    pi_0_sled(
        has_vents = HAS_VENTS,
        has_keystone_left = HAS_KEYSTONE_LEFT,
        has_keystone_right = HAS_KEYSTONE_RIGHT,
    );
}
