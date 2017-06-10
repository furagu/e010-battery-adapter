$fn = 100;

main(
    battery_w = 11,
    battery_h = 5.9,

    cage_l    = 27,
    cage_w    = 17.7,
    cage_h    = 9,

    stand_l   = 3,
    stop_l    = 5,

    hook_l    = 3,
    hook_h    = 5,
    wall_w    = 0.6,

    thickness = 0.55
);

module main() {
    translate([0, (cage_w - battery_w) / 2 - thickness, 0])
    base(
        l = cage_l,
        w = battery_w + thickness * 2,
        h = cage_h - battery_h,
        t = thickness,
        s = stand_l
    );

    gate_r = (cage_w - battery_w) / 4;

    for (y = [0, cage_w - gate_r * 2]) {
        translate([0, y, 0])
        side(
            r = gate_r,
            l = cage_l,
            h = cage_h - battery_h + battery_h * 0.6,
            t = thickness,
            stand_l = stand_l
        );
    }

    translate([cage_l, gate_r * 2 - thickness, cage_h - battery_h + battery_h * 0.2 ])
    stopper(
        w = battery_w + thickness * 2,
        h = battery_h * 0.4,
        l = stop_l + thickness,
        t = thickness
    );

    for (y = [- wall_w - thickness, cage_w - thickness]) {
        translate([-thickness, y, 0])
        hook(
            l      = hook_l,
            w      = thickness * 2 + wall_w,
            wall_w = wall_w,
            h      = hook_h,
            t      = thickness
        );
    }

    for (y = [-wall_w, cage_w - wall_w]) {
        translate([cage_l, y, 0])
        cube([thickness * 2, wall_w * 2, hook_h]);
    }
}

module base() {
    chamfer = 1.2;

    difference() {
        cube(size=[l, w, h]);

        translate([s, t, -1])
        cube(size=[l - s * 2, w - t * 2, h + 2]);

        for (x = [0, l - s]) {
            translate([x, t, h])
            rotate([0, -45, 0])
            translate([-chamfer / 2, 0, -chamfer / 2])
            cube(size=[chamfer, w - t * 2, chamfer]);
        }
    }
}

module side() {
    column_l = stand_l * 2;

    translate([0, r, 0])
    difference() {
        hull() {
            cylinder(r=r, h=h);

            translate([l, 0, 0])
            cylinder(r=r, h=h);
        }

        translate([0, 0, -1])
        hull() {
            cylinder(r=r - t, h=h + 2);

            translate([l, 0, 0])
            cylinder(r=r - t, h=h + 2);
        }

        translate([column_l, -r - 1, t * 2])
        cube(size=[l - column_l * 2, r * 2 + 2, h]);

        cut_angle = 20;

        translate([column_l, -r - 1, t * 2])
        rotate([0, -cut_angle, 0])
        cube(size=[column_l, r * 2 + 2, h * 2]);

        translate([l - column_l, -r - 1, t * 2])
        rotate([0, cut_angle, 0])
        translate([-column_l, 0, 0])
        cube(size=[column_l, r * 2 + 2, h * 2]);
    }
}

module stopper() {
    r = 1;

    linear_extrude(height=h) {
        translate([0, r + t])
        difference() {
            offset(r=r + t) {
                square([l - r - t, w - (r + t) * 2]);
            }
            offset(r=r) {
                square([l - r - t, w - (r + t) * 2]);
            }
            translate([-r -t - 1, -r -t - 1])
            square([r + t + 1, w + 2]);
        }
    }
}

module hook() {
    difference() {
        cube([l, w, h]);

        translate([t, t, -1])
        cube([l, wall_w, h + 2]);
    }
}
