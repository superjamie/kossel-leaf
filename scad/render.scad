include <config.scad>
use <carriage.scad>
use <leafspring.scad>
use <endstop.scad>
use <parts.scad>

module extrusion() {
    length = 150;
    translate([0,length/2-extrusion,mgnface+(extrusion/2)])
      rotate([90,0,0])
        scale([1,1,length/20])
          vslot();
}

// vslot
color("slategray")
 %extrusion();

// carriage
color("indianred") {
    // bottom
    outer_carriage();
    
    // top
    z = (pz+ps+vspacerh)*2 + vthi;
    translate([0,0,z]) rotate([0,180,180]) inner_carriage();
}

// socket cap bolt heads
color ("silver") {
    z = (pz+ps+vspacerh)*2 + vthi - (e/2) - metric_thick_clearance;
    translate([0,0,z]) rotate([0,180,180]) plate_socket_caps();
}

// traxxas joints
color("dimgray") {
    z = (pz+ps+vspacerh)*2 + vthi + 13/2;
    translate([-20-3.5-0.5,-6,z]) rotate([-120,0,0]) tx();
    translate([20+3.5+0.5,-6,z]) rotate([-120,0,0]) tx();
}

// spacer
color("silver") {
    // bottom spacers
    translate([0,0,pz+ps]) {
        translate(axledims[0]) metal_spacer();
        translate(axledims[1]) metal_spacer();
    }
    // top spacers
    translate([0,0,pz+ps+vspacerh+vthi]) {
        translate(axledims[0]) metal_spacer();
        translate(axledims[1]) metal_spacer();
    }
}

// leaf
color("gold") {
    // bottom leaf
    translate([vout,0,pz+leaf_post_car_offset]) leafspring1();
    // top leaf
    translate([vout,0,pz+leaf_post_car_offset+leaf_post_height_center*2+0.1]) rotate([0,180,0]) leafspring2();
}

// wheel
{
    translate([0,0,pz+ps+vspacerh]) {
        // fixed wheels
        translate([0,0,0]) {
            translate(axledims[0]) %wheel();
            translate(axledims[1]) %wheel();
        }
        // sprung wheels
        translate([vout,0,0]) {
            translate(leafdims[1]) %wheel();
            translate(leafdims[2]) %wheel();
        }
    }
}

// belt arm thing
color("orange") {
    z = (pz+ps+vspacerh)*2 + vthi;
    translate([0,-6,z]) rotate([0,0,180]) belt_arm();
}

// endstop holder
color("indianred") {
    translate([0,-(extrusion*4),pz+ps+extrusion+1.5]) rotate([-90,0,0]) omron_endstop_holder();
}

// endstop
color("dimgray") {
    translate([0,-(extrusion*4)+5,pz+ps+extrusion+1.5+6.4+5.8+0.001]) rotate([180,0,0]) omron();
}

// $vpt=[-21,6,50]; $vpr=[52,0,233]; $vpd=265;
 $vpt=[5,-10,20]; $vpr=[55,0,130]; $vpd=295;

