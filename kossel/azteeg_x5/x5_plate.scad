// Azteeg X5 board <-> 1515 extrusion board clip
// Allows access to the reset/boot buttons when mounted in a Kossel Pro
//
// Fastener stack (choose your own adventure if you like):
// Nut
// Board
// Nut
// Washer
// Board Clip
// 8mm M3 socket head cap screw (SHCS)
//
// With a longer screw adding washers in the proper place (X5 board drills) is 
// possible, but with the 10mm screw the current stack is rather tight on tolerances.
//

$fn=60;

// Show OpenBeam DXF profile alongside clip
// Note: Enabling this may result in a non-manifold warning on render/export
show_openbeam_profile = false;

// Allow the board to be slid back if desired.
enable_stacked_hits = true;

// Do deeper wall cutouts for stiffer materials like PLA
rigid_material = false;

// Allow the piece to just clip into the extrusion and hold without screws
enable_clips = true;

module openbeam() {
    linear_extrude(rotate = 90, height = 100, center = true, convexity = 10) import (file = "openbeam.DXF");
}

module polyhole(h, d) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module countersunk_hole(d = 3.5, h = 8, countersink_height=2.5) {
    cylinder(d = d, h = h);
    translate([0, 0, countersink_height]) polyhole(d = 6, h = h);
}

module mounting_drills() {
    // Mounting hole top left:
    translate([89.0, 0, -5]) countersunk_hole(d = 3.6, h = 8, countersink_height = -2);
    
    // Mounting hole top right: 
    translate([0, 0, -5]) countersunk_hole(d = 3.6, h = 8, countersink_height = -2);
    
    // Mounting hole bottom left:
    translate([89.0, 43.0, -5]) countersunk_hole(d = 3.6, h = 8, countersink_height = -2);
    
    // Mounting hole bottom right:
    translate([0, 43.0, -5]) countersunk_hole(d = 3.6, h = 8, countersink_height = -2);
}

// Covers the vertical plates around the 1515 extrusion, and the
// small horizontal overhangs that clip the plate to the beam
module beam_clip() {
    union() {
        difference() {
            // Wall facing outside of triangle
            cube([101, 2, 16], center = true);
            
            // Screw holes
            translate([0, 1.5, -3]) rotate([90, 0, 0]) {
                // Screw holes for extra rigidity if desired
                countersunk_hole(countersink_height=1.2);
                translate([-30, 0, 0]) countersunk_hole(countersink_height=1.2);
                translate([ 30,  0, 0])  countersunk_hole(countersink_height=1.2);
            }
        }
    }
        
    if ( enable_clips ) {
        // Clip
        translate([0, .5, -8.2]) {
            cube([101, 3, 1.5], center = true);
        }
    }

    
    translate([0,18.5,0]) {
        union() {
            difference() {
                // Wall
                cube([101, 2, 16], center = true);
                /* -- Can be enabled, but not entirely necessary
                
                #translate([0, -2, -.5], center = true) {
                    // Screw holes for extra rigidity if desired
                    rotate([0,90,90]) countersunk_hole();
                    translate([-30,0,0]) rotate([0,90,90]) countersunk_hole();
                    translate([30,0,0]) rotate([0,90,90]) countersunk_hole();
                }
                -- */
            }
            
            if ( enable_clips ) {
                // Clip
                translate([0, -.5, -8.2]) {
                    cube([101, 3, 1.5], center = true);
                }
            }
        }
    }
}

// Board
module x5_plate() {
    difference() {
        // Board total dimensions
        // Board X: 98.9  
        // Board Y: 68 -- 1515 extrusion accounts for some of this 
        cube([101, 71.5, 5]);
    
        
        translate([6, 10, 3]) {
            mounting_drills();
        }
        
        if ( enable_stacked_hits ) {
        
            translate([6, 8, 3]) {
              mounting_drills();
            }
            translate([6, 24.5, 3]) {
                mounting_drills();
            }
        }
        
        // Thin the wall in these areas to allow this area to flex for easier snapping into beam
        translate([50.5, 22, 0]) {
            cube([101, 2, 5], center=true);
        }
        
        translate([50.5, 2.5, 1]) {
            if ( rigid_material ) {
                cube([101, .5, 6], center=true);
            } else {
                cube([101, 1.5, 4.5], center=true);
            }
        }        
        
        // Thin wall to allow this area to flex for easier snapping
        // to beam
        translate([50.5, 18, 1]) {
            if ( rigid_material ) {
                cube([101, .5, 6], center=true);
            } else {
                cube([101, 1.5, 4.5], center=true);
            }
        }
        
        // Cutout for passive underside cooling
        #translate([50.5, 53, 3]) {
            cube([80.5, 55, 7], center=true);
        }
    }
}

rotate([180, 0, 0]) union() {
    translate([0, -9, -2]) beam_clip();
    translate([-50.5, -10, 3.5]) x5_plate();
}

if ( show_openbeam_profile ) {
    rotate([0, 90, 180]) translate([5, 0, 0]) openbeam();
}
