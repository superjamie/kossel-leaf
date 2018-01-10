include <config.scad>

module leaf_posts() {
    diam = leaf_post_diam;
    // this middle post lands in the middle of the V wheel so you can place two facing each other as spacers between two plates
    translate(leafdims[0]) cylinder(h=leaf_post_height_center,d=diam);
    
    // these outer posts center the V wheel correctly
    for(i = [1,2]) {
        translate(leafdims[i]) cylinder(h=leaf_post_height_wheel-1,d=diam+2);
        translate(leafdims[i]) translate([0,0,leaf_post_height_wheel-1])
          cylinder(h=1,d2=m5c+2,d1=m5c+4);
    }
}

echo(leaf_post_height_wheel);

module leaf_springs() {
    diam = leaf_spring_thickness;
    // top spring
    hull() {
        translate(leafdims[0]) cylinder(h=leaf_post_height_wheel-1,d=diam);
        translate(leafdims[1]) cylinder(h=leaf_post_height_wheel-1,d=diam);
    }
    // bottom spring
    hull() {
        translate(leafdims[0]) cylinder(h=leaf_post_height_wheel-1,d=diam);
        translate(leafdims[2]) cylinder(h=leaf_post_height_wheel-1,d=diam);
    }
}

module leaf_axles() {
    translate([0,0,-e/2]) {
        for(a = [0:2]) {
            translate(leafdims[a]) cylinder_outer(leaf_post_height_center+e,m5c);
        }
    }
}

module leaf_bolt_and_nut() {
    translate([0,0,-e/2]) {
        translate(leafdims[1]) cylinder_outer(h=m5t+e,d=m5n,$fn=6);
        // offset the hex head down a bit so you can use a M5x25 screw.
        // there's enough room
        headoffset = 1.0;
        translate(leafdims[2]) cylinder_outer(h=m5k-headoffset+e,d=m5d);
    }
}

module leafspring1() {
    difference() {
        union() {
            leaf_posts();
            leaf_springs();
        }
        leaf_axles();
        leaf_bolt_and_nut();
    }
}

module leafspring2() {
    mirror([0,1,0]) mirror([1,0,0]) leafspring1();
}

translate([-leaf_post_diam,0,0])
  leafspring1();
translate([+leaf_post_diam,0,0])
  leafspring2();
