include <config.scad>
use <parts.scad>

/* Omron SS-5GL */

endstop_o_th = 5.8; // thickness at switch
endstop_o_ht = 10;  // height

endstop_o_st = 5;   // side thickness

module omron_endstop_holder() {
    translate([-(extrusion+0.5)/2,-endstop_o_th,0]) difference() {
        union() {
            cube([extrusion+0.5,endstop_o_th,endstop_o_ht]);
            // left
            hull() {
                // block
                translate([-endstop_o_st,endstop_o_th,0]) cube([endstop_o_st,extrusion,endstop_o_ht]);
                difference() {
                    // radius
                    translate([0,endstop_o_st,0]) cylinder(r=endstop_o_st,h=endstop_o_ht);
                    // get rid of half
                    translate([0,0,0]) cube([endstop_o_st,endstop_o_st*2,endstop_o_ht]);
                }
            }

            // right
            hull() {
                // block
                translate([extrusion+0.5,endstop_o_th,0]) cube([endstop_o_st,extrusion,endstop_o_ht]);
                difference() {
                    // radius
                    translate([extrusion+0.25,endstop_o_st,0]) cylinder(r=endstop_o_st,h=endstop_o_ht);
                    // get rid of half
                    translate([extrusion+0.25-endstop_o_st,0,0]) cube([endstop_o_st+0.25,endstop_o_st*2,endstop_o_ht]);
                }
            }
        }

        // switch screw holes
        translate([5.3,endstop_o_th+e/2,endstop_o_ht/2]) rotate([90,0,0]) cylinder_outer(d=m2c,h=endstop_o_th+e);
        translate([5.3+9.5,endstop_o_th+e/2,endstop_o_ht/2]) rotate([90,0,0]) cylinder_outer(d=m2c,h=endstop_o_th+e);
        
        // switch screw head
        translate([5.3,endstop_o_th+e/2,endstop_o_ht/2]) rotate([90,0,0]) cylinder_outer(d=m2d,h=m2_5k+e);
        translate([5.3+9.5,endstop_o_th+e/2,endstop_o_ht/2]) rotate([90,0,0]) cylinder_outer(d=m2d,h=m2_5k+e);

        // extrusion screw
        translate([50,endstop_o_th+(extrusion/2),endstop_o_ht/2]) rotate([-90,0,90]) cylinder_outer(h=100,d=m5c);

        // corner relief
        rel = 1;
        translate([rel/4,endstop_o_th+rel/4,-e/2]) cylinder(h=endstop_o_ht+e,d=rel);
        translate([extrusion+0.25-rel/4,endstop_o_th+rel/4,-e/2]) cylinder(h=endstop_o_ht+e,d=rel);
        
    }
}

omron_endstop_holder();

translate([-10,0,-10]) %cube([20,20,20]);

translate([0,-5.8,endstop_o_ht/2]) rotate([90,0,0]) %omron();

echo(str("Minimum M2.5 screw length = ", 6.4 + endstop_o_th - m2_5k + m2_5t));
// use at least M2.5x12
// depending on belt arm holder and belt position, up to M2.5x20mm is probably fine
