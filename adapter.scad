$fn = 100;

main(
    battery_l       = 32.5,
    battery_w       = 10.7,
    battery_h       = 5.9,
    battery_stop_h  = 2,
    battery_stop_r  = 1.1,
    battery_grip_l  = 3,
    battery_cage_l  = 6,

    cage_l          = 27,
    cage_w          = 17.7,
    cage_h          = 7,

    grip_w          = 0.4,
    grip_l          = 1.2,
    grip_h          = 4.5,

    thickness       = 0.5
);

module main() {
    gate_r = (cage_w - battery_w) / 4;

    difference() {
        union() {
            difference() {
                union() {
                    pillar_positions = [
                        [0, gate_r],
                        [0, cage_w - gate_r],
                        [cage_l, gate_r],
                        [cage_l, cage_w - gate_r],
                    ];

                    for(pos = pillar_positions) {
                        translate(pos)
                            cylinder(h=cage_h, r=gate_r);
                    }

                    cube([cage_l, cage_w, cage_h]);

                    translate([battery_stop_r + thickness, battery_stop_r + thickness + gate_r * 2 - thickness, cage_h - battery_h + (battery_h - battery_stop_h) / 2]) {
                        linear_extrude(height=battery_stop_h) {
                            r = battery_stop_r + thickness;
                            difference() {
                                offset(r=r) {
                                    square([battery_l + thickness - r * 2, battery_w + thickness * 2 - r * 2]);
                                }
                                offset(r=battery_stop_r) {
                                    square([battery_l + thickness - r * 2, battery_w - battery_stop_r * 2]);
                                }
                            }
                        }
                    }
                }

                translate([-1, (cage_w - battery_w) / 2, cage_h - battery_h])
                    cube([cage_l + 2, battery_w, battery_h + 1]);

                pillars = [
                    [
                        [0, gate_r, -1],
                        [cage_l, gate_r, -1],
                    ],
                    [
                        [0, cage_w - gate_r, -1],
                        [cage_l, cage_w - gate_r, -1],
                    ],
                ];

                for(pillar_positions = pillars) {
                    hull() {
                        for(pos = pillar_positions) {
                            translate(pos)
                                cylinder(h=cage_h + 2, r=gate_r - thickness);
                        }
                    }
                }

                translate([battery_grip_l, (cage_w - battery_w - thickness) / 2 - 1, cage_h - battery_h])
                    cube(size=[cage_l - battery_grip_l * 2, battery_w + thickness * 2 + 2, cage_h]);

                translate([battery_cage_l, - 1, cage_h - battery_h])
                    cube(size=[cage_l - battery_cage_l * 2, cage_w + 2, cage_h]);

            }

            grip_t = grip_w + thickness;

            grip_positions = [
                [-grip_l, -grip_w],
                [cage_l, -grip_w],
                [-grip_l, cage_w - thickness],
                [cage_l, cage_w - thickness],
            ];

            for(pos = grip_positions) {
                translate(pos)
                    cube(size=[grip_l, grip_t, grip_h]);
            }
        }

        translate([thickness, gate_r * 2, -1])
            cube(size=[cage_l - thickness * 2, cage_w - gate_r * 4, cage_h]);

        for(x = [-gate_r - 1, cage_l - battery_grip_l]) {
            translate([x, -1, cage_h - battery_h + (battery_h - battery_stop_h) / 2 + battery_stop_h])
                cube(size=[battery_grip_l + gate_r + 1, cage_w + 2, cage_h]);
        }
    }
}
