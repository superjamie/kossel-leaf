include <config.scad>

module plate_body_inner() {
    r = platerad;
    translate([-px/2,-py/2,0]) hull() {
        for(x = [r, px-r]) {
            for(y = [r, py-r]) {
                translate([x,y,0]) cylinder(h=pz,d=r*2);
            }
        }
    }
}

module plate_axles() {
    h = pz + ps + vspacerh + e;
    translate([0,0,-e/2]) {
        for(a = [0:2]) {
                // wheel axles
                translate(axledims[a]) cylinder_outer(h,m5c);
        }
    }
}

module plate_socket_caps() {
    h = pz + ps + vspacerh + e;
    translate([0,0,-e/2]) {
        for(a = [0:2]) {
            // space for the socket cap to sit in
            // not sure if this really needs to be totally flush
            translate(axledims[a]) cylinder_outer(m5k+e,m5d);
        }
    }
}

module plate_nuts() {
    translate([0,0,-e/2]) {
        for(a = [0:2]) {
                // nut traps
                translate(axledims[a]) cylinder_outer(h=m5t+e/2,d=m5n,$fn=6);
        }
    }
    
}

module plate_posts() {
    diam = ppost;
    translate([0,0,pz]) {
        // fixed posts
        translate(axledims[0]) cylinder(h=ps,d2=diam,d1=diam+2);
        translate(axledims[1]) cylinder(h=ps,d2=diam,d1=diam+2);
        // small offset for leaf spring to sit on
        translate(axledims[2]) cylinder(h=leaf_post_car_offset,d2=diam,d1=diam+2);
    }
}

module mgn_mount() {
    yoff = 4;
    for(ym = [-yoff,-yoff+mgn12h]) {
        for(xm = [-1,1]) {
            // screw hole
            translate([mgn12x/2*xm,ym,-e/2]) cylinder_outer(pz+e,m3c);
            // nut trap
            translate([mgn12x/2*xm,ym,pz-m3t]) cylinder_outer(h=m3t+e,d=m3n,$fn=6);
        }
    }
}

module level_screw() {
    for (i = [0,-1]) rotate([i*180,i*180,0]) {
        // hole for captive nyloc
        translate([-m3n/2,py/2-m3y-4,-e/2]) cube([m3n,m3y,pz+e]);

        // screw shaft
        inset = 16;
        translate([0,(py/2)-inset,pz/2]) rotate([-90,0,0]) cylinder_outer(d=m3c,h=inset+e);
    }
}


module outer_plate_hole() {
    r = platerad;
    translate([-(px-4)/4,-py/4,-e/2]) hull() {
        for(x = [r, px/2-r-2]) {
            for(y = [r, py/2-r]) {
                translate([x,y,0]) cylinder(h=pz+e,d=r*2);
            }
        }
    }
}

module inner_carriage() {
    difference() {
        union() {
            plate_body_inner();
            plate_posts();
        }
        plate_axles();
        plate_socket_caps();
        mgn_mount();
        level_screw();
    }
}

module outer_carriage() {
    difference() {
        union() {
            plate_body_inner();
            plate_posts();
        }
        plate_axles();
        plate_nuts();
        outer_plate_hole();
        // mgn_mount();  // you could add this back in to mount something to the outside if you wanted
    }
}

ro = 50; // render offset

translate([-ro,0,0])
  inner_carriage();

translate([ro,0,0])
//translate([0,0,pz])
//rotate([180,0,0])
  outer_carriage();