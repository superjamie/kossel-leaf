include <handyscad.scad>

/* global */

$fn = 36;
// need openscad nightly for this, see Issue 149
$fn = $preview ? 36 : 180;
e = 1.1; // epsilon, used for not sharing faces

/*
 * carriage
 */

// 2020 extrusion is 20mm
extrusion = 20;

// metric clearances - depending on how good your printer and tuning is
metric_thick_clearance = 0.25;
metric_round_clearance = 0.25;

// metric screw clearance holes
m2_5c = 2.9;
m3c   = 3.3;
m4c   = 4.3;
m5c   = 5.3;

// metric screw socket cap diameter
m2_5d = 4.5 + metric_round_clearance;
m3d   = 5.5 + metric_round_clearance;
m4d   = 7.0 + metric_round_clearance;
m5d   = 8.5 + metric_round_clearance; // i have 8.4

// metric screw socket cap depth
m2_5k = 2.5;
m3k   = 3.0;
m4k   = 4.0;
m5k   = 5.0; // i have 4.87 and 4.95

// metric nut diameter (flat to flat)
m3n   = 5.5 + metric_round_clearance;
m4n   = 7.0 + metric_round_clearance;
m5n   = 8.0 + metric_round_clearance; // i have 7.6

// metric nut thickness
m2_5t = 2.0 + metric_thick_clearance;
m3t   = 2.4 + metric_thick_clearance;
m4t   = 3.2 + metric_thick_clearance;
m5t   = (4.7 + 3.4) / 2; // internet says 4.7 but i have 3.4! so averaged

// metric nut width (opposite to flats)
m3w = 6.08; // i have 6.07
m4w = 7.74;
m5w = 8.87;

// metric nyloc nut thickness
m3y = 4; // i have 3.78
m4y = 5;
m5y = 5;

// metric pan head diameter
m2_5p =  5.0 + metric_round_clearance;
m3p   =  6.0 + metric_round_clearance;
m4p   =  8.0 + metric_round_clearance;
m5p   = 10.0 + metric_round_clearance;

// v-wheel
vout = 20.4; // v-wheel axle outset from extrusion centreline
vdia = 24.2; // v-wheel diameter (OB solid = 23.9, OB Delrin = 24.39)
vthi = 10.9; // v-wheel thickness, bearing-to-bearing face with shim

// v-wheel spacer
// https://www.aliexpress.com/item/20pcs-6mm-V-slot-v-wheel-aluminum-spacers-Free-shipping/32723187768.html
// OD 10mm, ID 5.1mm, Height 6.0mm

vspacerh =  6; // v-wheel metal spacer height
vspacerd = 10; // v-wheel spacer diameter

// linear rail mounts
mgn12x = 20; // MGN-12 horizontal mount distance
mgn12c = 15; // MGN-12-C vertical mount distance
mgn12h = 20; // MGN-12-H vertical mount distance
mgn12y = mgn12h; // change this if you use 20x15 carriage mounts

mgnface = 13; // distance from extrusion to MGN-12 mounting face

// plate
px = 56; // horizontal
py = 55; // vertical
pw = 10; // wheel axle inset
pay = 60; // plate axle y, cos i resized the plate but based everything off these, oops

platerad = 5; // plate outer curve radius

/* pz and ps
 * MGN12 mounting face is 13mm off extrusion.
 * so from middle of 2020 extrusion, we need 23mm to mounting face.
 * my 2x625+shim v-wheel is 10.9 thick at the bearing surfaces.
 * commercial metal v-wheel spacer/eccentric is 6mm thick.
 * 10.9 / 2 = 5.45  (from middle of extrusion to face of wheel bearing)
 * 5.45 + 6 = 11.45  (from middle of extrusion to top of spacer/eccentric)
 * 23 - 11.45 = 11.55 (from mount face to spacer, mount point thickness)
 * however, we can't print 0.05mm in Z with 0.25mm layer height
 * so i'll make it 11.5 and need to increase DELTA_RADIUS by 0.05mm
 */

ptemp1 = (mgnface + extrusion/2) - ((vthi/2) + vspacerh); // 11.55
layerheight = 0.25;
ptemp2 = round(ptemp1 / layerheight) * layerheight; // 11.50
pz = 8; // plate thickness, you can change this
ps = ptemp2 - pz; // standoff thickness

ppost = 12; // plate post diameter

axledims = [ [-vout,pay/2-pw],
             [-vout,-(pay/2-pw)],
             [+vout,0],
           ];

/*
 * leaf spring
 */

leaf_inset = 1.5;  // initial preload of leaf force
leaf_post_car_offset = 1; // height of leaf off the carriage
leaf_post_diam = 12;
leaf_post_height_wheel = ps - leaf_post_car_offset + vspacerh;
leaf_post_height_center = leaf_post_height_wheel + (vthi/2);
leaf_spring_thickness = 2;

leafdims = [ [0,0],
             [-leaf_inset,+(py/2-pw)],
             [-leaf_inset,-(py/2-pw)],
           ];
