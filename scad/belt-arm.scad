/* Kossel Pro and Kossel Mini belt arm holder for Kossel Leaf
 *
 * Licence:
 * CC BY-SA 3.0, http://creativecommons.org/licenses/by-sa/3.0/
 *
 * Authors:
 * Johann C. Rocholl (jcrocholl) <johann@rocholl.net>
 * Dominik Scholz (schlotzz) <schlotzz@schlotzz.com>
 * Glen Harris (astfgl) <astfgl@iamnota.org>
 * K Zhang (gnahz)
 * Jamie Bainbridge (superjamie) <jamie.bainbridge@gmail.com>
 *
 * Based on:
 * https://github.com/jcrocholl/kossel/blob/master/carriage.scad
 * https://www.thingiverse.com/thing:263205
 * https://www.thingiverse.com/thing:431251
 * https://www.thingiverse.com/thing:646889
 */

// #########################
// ### IMPORTANT         ###
// ### ARM SEPARATION    ###
// ### IS DIFFERENT:     ###
// ### Kossel Mini == 40 ###
// ### Kossel Pro  == 41 ###
// #########################
separation = 41;

if (separation == 40) {
    echo(str("<b>NOTE: Building for Kossel MINI. Not for Kossel Pro!</b>"));
} else
if (separation == 41) {
    echo(str("<b>NOTE: Building for Kossel PRO. Not for Kossel Mini!</b>"));
} else {
    echo(str("<b>NOTE: Building for custom delta. Not for Kossel Mini or Kossel Pro.</b>"));
}


// i wanted the curves to look nicer
$fn = 90;

// Increase this if your slicer or printer make holes too tight.
extra_radius = 0.1;

// OD = outside diameter, corner to corner.
m3_nut_od = 6.1;
m3_nut_radius = m3_nut_od/2 + 0.2 + extra_radius;
m3_washer_radius = 3.5 + extra_radius;

// Major diameter of metric 3mm thread.
m3_major = 2.85;
m3_radius = m3_major/2 + extra_radius;
m3_wide_radius = m3_major/2 + extra_radius + 0.2;

m3_head = 5.68;
m3_head_radius = m3_head/2 + 0.2 + extra_radius;

thickness = 6;

horn_thickness = 13;
horn_x = 8;

belt_width = 5;
belt_x = 5.6;
belt_z = 7;

module carriage() {

    clearance = 0.125;

    // timing belt, up and down
    for (x = [-belt_x, belt_x])
        translate([x, 0, belt_z + belt_width / 2])
          % cube([1.7, 100, belt_width], center = true);

    difference() {
        union() {
            // main body
            translate([0, 0, thickness / 2])
                cube([27, 38, thickness], center = true);

            // ball joint mount horns
            translate([0, -16, 0])
                for (x = [-1, 1]) {
                    scale([x, 1, 1]) {
                        intersection() {
                            translate([0, 16, horn_thickness / 2])
                              cube([separation, 18, horn_thickness], center = true);
                            translate([horn_x, 16, horn_thickness / 2])
                              rotate([0, 90, 0])
                              cylinder(r1 = 14, r2 = 2.5, h = separation / 2 - horn_x);
                        }
                    }
                }

            // screws for linear slider inforcement
            for (x = [-10, 10]) {
                for (y = [-10, 10]) {
                    translate([x, y, horn_thickness / 2])
                      cylinder(r = m3_wide_radius + 1.2, h = horn_thickness, center = true);
                }
            }

            // belt clamps for GT2
            difference() {
                union() {
                    for (y = [-12, 12]) {
                        union() {
                            translate([-0.5 - clearance * 2, y, horn_thickness / 2 + 1]) cube([1, 14, horn_thickness - 2], center = true);
                            translate([-1 - clearance * 2, y, horn_thickness / 2 + 1])
                              cube([2, 14, horn_thickness - 2], center = true);
                            translate([-2 - clearance * 2, y, horn_thickness / 2 + 1])
                              cube([3, 12, horn_thickness - 2], center = true);
                            for (n = [-5.5, 5.5])
                                translate([-2 - clearance * 2, y + n, horn_thickness / 2 + 1])
                                  cylinder(r = 1.5, h = horn_thickness - 2, center = true);

                            translate([3.25 - clearance, y, horn_thickness / 2 + 1])
                              cube([5, 14, horn_thickness - 2], center = true);

                            translate([7.5, y, horn_thickness / 2 + 1])
                              cube([2, 14, horn_thickness - 2], center = true);
                        }
                    }
                }

                // tooth cutout
                for (x = [1.125 - 0.300 - clearance, 5.375 + 0.30 - clearance]) {
                    for (y = [0 : 19]) {
                        translate([x, 19 - y * 2, 6 - 0.001])
                          cylinder(r = 0.7, h = horn_thickness / 2 + 1);
                    }
                }

                // cutout for easier inserting of belt
                for (x = [0.5 - clearance, 6 - clearance])
                    translate([x, 0, horn_thickness])
                      rotate([0, 45, 0])
                      cube([2 + clearance / 2, 50, 2 + clearance / 2], center = true);

                // avoid touching diagonal push rods (carbon tube)
                translate([20, -20, 12.5])
                  rotate([35, 35, 30])
                  cube([40, 40, 20], center = true);
            }
        }

        // screws for linear slider
        for (x = [-10, 10]) {
            for (y = [-10, 10]) {
                translate([x, y, thickness])
                  cylinder(r = m3_wide_radius, h = 30, center = true);
                // recessed screws
                translate([x, y, horn_thickness + 0.5 - 0.001])
                  cylinder(r = m3_head_radius, h = 3 + 0.003, center = true);
            }
        }

        // screws for ball joints
        translate([0, 0, horn_thickness / 2])
          rotate([0, 90, 0])
          # cylinder(r = m3_wide_radius, h = 60, center = true);

            // lock nuts for ball joints
            for (x = [-1, 1]) {
                scale([x, 1, 1]) {
                    intersection() {
                        translate([horn_x, 0, horn_thickness / 2])
                          rotate([90, 0, -90])
                          cylinder(r1 = m3_nut_radius, r2 = m3_nut_radius + 0.5, h = 8, center = true, $fn = 6);
                    }
                }
            }
    }
}

carriage();
