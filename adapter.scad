$fn = 100;

main(
    battery_l       = 32.5,
    battery_w       = 11,
    battery_h       = 6,
    battery_stop_h  = 2,
    battery_stop_r  = 0.4,
    battery_grip_l  = 5,

    cage_l          = 25,
    cage_w          = 17.7,
    cage_h          = 7,
    cage_grip       = 0.3,
    cage_flange     = 1,
    cage_base       = 5,
    cage_top        = 15,

    thickness       = 0.6
);

module main() {
    box_l = cage_l + cage_flange * 2;
    box_w = cage_w + cage_grip * 2;

    gate_r = ((cage_w - battery_w) / 2 + cage_grip) / 2;

    difference() {
        union() {
            difference() {
                union() {
                    pillar_positions = [
                        [0, gate_r],
                        [0, box_w - gate_r],
                        [box_l, gate_r],
                        [box_l, box_w - gate_r],
                    ];

                    for(pos = pillar_positions) {
                        translate(pos)
                            cylinder(h=cage_h, r=gate_r);
                    }

                    cube([box_l, box_w, cage_h]);

                    translate([battery_stop_r + thickness, battery_stop_r + thickness + gate_r * 2 - thickness, cage_h - battery_h + (battery_h - battery_stop_h) / 2]) {
                        linear_extrude(height=battery_stop_h) {
                            r = battery_stop_r + thickness;
                            difference() {
                                offset(r=r) {
                                    square([battery_l + cage_flange + thickness - r * 2, battery_w + thickness * 2 - r * 2]);
                                }
                                offset(r=battery_stop_r) {
                                    square([battery_l + cage_flange + thickness - r * 2, battery_w - battery_stop_r * 2]);
                                }
                            }
                        }
                    }
                }

                for(y = [-1, box_w - cage_grip]) {
                    translate([cage_flange, y, -1])
                        cube([cage_l, cage_grip + 1, cage_h + 2]);
                }

                translate([-1, (box_w - battery_w) / 2, cage_h - battery_h])
                    cube([box_l + 2, battery_w, battery_h + 1]);

                hull() {
                    pillar_positions = [
                        [0, gate_r],
                        [box_l, gate_r],
                    ];

                    for(pos = pillar_positions) {
                        translate(pos)
                        translate([0, 0, cage_h - battery_h])
                            cylinder(h=cage_h + 1, r=gate_r - thickness);
                    }
                }

                hull() {
                    pillar_positions = [
                        [0, box_w - gate_r],
                        [box_l, box_w - gate_r],
                    ];

                    for(pos = pillar_positions) {
                        translate(pos)
                        translate([0, 0, cage_h - battery_h])
                            cylinder(h=cage_h + 1, r=gate_r - thickness);
                    }
                }

                translate([battery_grip_l, (cage_w - battery_w - thickness) / 2 - 1, cage_h - battery_h])
                    cube(size=[cage_l + cage_flange * 2 - battery_grip_l * 2, battery_w + thickness * 2 + 2, cage_h]);

            }

            for(y = [thickness, box_w - thickness - cage_grip]) {
                translate([cage_flange - thickness, y, 0])
                    cube(size=[cage_l + thickness * 2, thickness - cage_grip, cage_h]);
            }

            helper_positions = [
                [battery_grip_l,  gate_r * 2 - thickness],
                [box_l - battery_grip_l, gate_r * 2 - thickness],
                [battery_grip_l,  box_w - gate_r * 2 + thickness],
                [box_l - battery_grip_l, box_w - gate_r * 2 + thickness],
            ];

            for(pos = helper_positions) {
                translate(pos)
                    cylinder(h=cage_h, r=thickness);
            }
        }

        translate([0, (box_w - battery_w) / 2, -1])
            triangle_mesh(l=box_l, w=battery_w, h=cage_h, thickness=thickness, segments=8);

        for(y = [gate_r, box_w]) {
            translate([cage_flange, y, cage_h - battery_h])
            rotate([90, 0, 0])
                circle_mesh(l=cage_l, w=battery_h, h=gate_r, thickness=thickness, segments=9);
        }
    }
}

module triangle_mesh(l, w, h, thickness, segments) {
    segment_l = (l - thickness * 2) / segments;
    angle = atan((w - thickness * 2) / segment_l);

    segment_base = sqrt(pow(w, 2) + pow(segment_l, 2));

    linear_extrude(height=h)
    difference() {
        square([l, w]);

        intersection() {
            union() {
                for(x = [thickness : segment_l * 2 : l]) {
                    translate([x, thickness])
                    rotate([0, 0, angle])
                    translate([segment_base / 2, 0])
                        square([segment_base, thickness], center=true);
                }

                for(x = [thickness + segment_l * 2 : segment_l * 2 : l]) {
                    translate([x, thickness])
                    rotate([0, 0, 180 - angle])
                    translate([segment_base / 2, 0])
                        square([segment_base, thickness], center=true);
                }
            }
            square([l, w]);
        }

        difference() {
            square([l, w]);
            translate([thickness, thickness])
                square([l - thickness * 2, w - thickness * 2]);
        }
    }
}

module circle_mesh(l, w, h, thickness, segments) {
    segment_l = (l - thickness * 2) / segments;
    segment_w = (w - thickness * 2) / segments;
    r = (l - thickness * (segments + 1)) / segments / 2;

    linear_extrude(height=h) {
        for(x = [thickness + r : r * 2 + thickness : l]) {
            hull() {
                translate([x, thickness + r])
                    circle(r=r);

                translate([x, w - thickness - r])
                    circle(r=r);
            }
        }
    }
}

