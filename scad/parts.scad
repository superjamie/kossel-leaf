include <config.scad>

po = 50; // part offset

/* external vitamins, just here for fitment testing */

module metal_spacer() {
    /* you can find these on aliexpress, eg:
    https://www.aliexpress.com/item/20pcs-6mm-V-slot-v-wheel-aluminum-spacers-Free-shipping/32723187768.html
    https://www.aliexpress.com/item/10-PCS-for-v-slot-Openbuilds-Isolation-Column-Separate-Pillar-Quarantine-Bore-5-5-1mm-Thickness/32820502527.html
    */
    
    difference() {
        // metal spacer body
        cylinder(h=vspacerh,d=vspacerd);
        
        // screw hole
        translate([0,0,-e/2]) cylinder_outer(vspacerh+e,m5c);
        // chamfer
        translate([0,0,vspacerh-e/2]) cylinder(h=e,d1=m5c,d2=m5c+1);
        translate([0,0,-e/2]) cylinder(h=e,d2=m5c,d1=m5c+1);
    }
}

module bearing625() {
    d = 16; // diameter
    h = 5;  // height
    i = 5;  // inner hole
    color("silver") difference() {
        cylinder(h=h,d=d);
        translate([0,0,-e/2]) cylinder(d=i,h=h+e);
    }
}

module wheel() {
    // V-slot wheel by eightball103
    // https://www.thingiverse.com/thing:611025

    my_wheel_height = 10.9;
    stl_wheel_height = 10.998;
    zscale = my_wheel_height / stl_wheel_height;
    color("dimgrey") translate([-8,8,0]) scale([1,1,zscale]) import("parts/_wheel.stl");
    bearing625();
    translate([0,0,my_wheel_height-5]) bearing625();
}

module vslot() {
    // 2020 profile by stwarbird
    // https://www.thingiverse.com/thing:2401625

    // renders vertical, centred, 20mm long    
    translate([17.35,-18.62,0]) import("parts/_vslot.stl");
}

module belt_arm() {
    // there are better designs available, like wwchen/kumy/schlotzz
    // https://github.com/jcrocholl/kossel/blob/master/carriage.stl
    //import("_belt-arm_johann.stl");
    //translate([-20.5,22.9,0]) rotate([90,0,0]) import("_belt-arm_kosselpro.stl");
    import("../Kossel Leaf Pro 41mm Belt-Arm MGN12H.stl");
}

module tx() {
    // Traxxas 5347 clone by tiqdreng
    // https://www.thingiverse.com/thing:272070
    translate([0,-17.1825,0]) rotate([0,90,90]) import("parts/_tx5347.stl");
}

module omron() {
    /* Omron SS-5GL */
    rotate([0,0,180]) translate([-19.8/2,-2.5,0]) difference() {
        union() {
            cube([19.8,10.2,6.4]);
            hull() {
                translate([1.6-0.55,10.2,1.4]) cylinder(h=3.6,d=1.1);
                FP = 4.5;
                translate([19.8-0.55,10.2+FP,1.4]) cylinder(h=3.6,d=1.1);
                // cube([18.2,1.1,3.6]);
            }
        }
        translate([5.1,2.5,-e/2]) cylinder_outer(h=6.4+e,d=2.35);
        translate([5.1+9.5,2.5,-e/2]) cylinder_outer(h=6.4+e,d=2.35);
    }
}

translate([-po,po ,0]) metal_spacer();
translate([  0,po ,0]) wheel();
translate([ po,po ,0]) vslot();
translate([ po,  0,0]) belt_arm();
translate([-po,  0,0]) tx();
translate([-po,-po,0]) omron();

/* M5 screw axle lengths
 *
 * long axle - through the main carriage
 * you could go longer on this as it just sticks out into nowhere.
 *
 * short axle - leaf spring
 * probably have an extra 1.25mm here, so it renders as 23.15mm
 * and you could use a screw up to 24.4mm screw, but no more.
 * that's a bit of an awkward size. grind down with dremel.
 */

axle_long_fixed = (pz + ps + vspacerh + (vthi/2)) * 2 - (m5k-0.25);
axle_long_leaf = (pz + leaf_post_car_offset + leaf_post_height_center) * 2  - (m5k-0.25);
axle_short = (leaf_post_height_wheel + (vthi/2)) * 2 - (m5k-0.25);

if(axle_long_fixed == axle_long_leaf) {
    echo(str("long axle = ", axle_long_fixed, " mm"));
} else {
    echo("ERROR: Long axles do not match!");
}
echo(str("short axle = ", axle_short, " mm"));
