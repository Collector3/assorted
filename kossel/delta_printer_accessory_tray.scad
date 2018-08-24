// Kossel 1515 extrusion cable organizer/clip
// License: CC1.0 Universal

$fn = 100;
plate_length = 15;
plate_height = 20;

plate_width  = 20;
plate_thickness = 2;

num_drills = 1;
inset_depth = 1.5;
drill_depth = 4;

wall_length = 19;

// Polyholes from: http://hydraraptor.blogspot.com/2011/02/polyholes.html
module polyhole(h, d) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}

module openbeam() {
    linear_extrude(rotate = 90, height = 100, center = true, convexity = 10) import (file = "openbeam.dxf");
}


module inset_drills(distance, drill_size, inset_depth) {
    translate([0, distance*20, -drill_depth]) cylinder(r=drill_size/2, h=drill_depth);
    translate([0, distance*20, -1]) cylinder(r=drill_size/1.2, h=inset_depth);
}

module holders() {
    union() {
        difference() {
        // Glue stick holder
            rotate([90, 0, 0]) translate([9, 37, -30]) {
                cylinder(d=25, h=30);
        
            }
            rotate([90, 0, 0]) translate([9, 37, -30]) cylinder(d=23, h=25.5);
        }
        difference() {
            
            translate([0, 0, -15]) cube([18, plate_thickness, 24]);
           
            // USB stick/microSD <-> USB card reader
            #translate([4, -plate_thickness, 3]) cube([12, 5, 5]);
            
            // Holder for a spatula/flat print removal tool (Toybuilder labs spatula here)
            translate([2, -plate_thickness, -14]) cube([2, 6, 13]);
        
            // Tweezer hanger (one side hangs off of the edge)
            translate([14.5, -plate_thickness, -12]) cube([3, 6, 8]);            
 
            // Messograf calipers/pen
            #translate([5, -plate_thickness, -10]) cube([8.5, 5, 12]);            
            
        }
        
        difference() {
        
            translate([0, 0, 11]) cube([18, plate_thickness, 24]);
            
            // Intended to hold a flush cutter's handle
            translate([4, -plate_thickness, 12]) cube([13, 5, 6]);
            
            // Outer areas for securing larger pliers
            // Remove the glue stick holder if this is desired -- unrefined
            // but tested against Hakko red pliers
            //translate([9, -plate_thickness, 25]) cube([6, 6, 7]);
            //translate([0, -plate_thickness, 25]) cube([6, 6, 7]); 
        }
    }
}

module plate() {
    difference() {
      union() {
        // Interface plate (to extrusion)
        cube([plate_thickness, plate_length, plate_height]);
        
        // Bottom plate (where driver shafts exit))
        cube([plate_width, plate_length, plate_thickness]);
          
        // Top plate (driver landing area)
        translate([19-wall_length, 0, plate_height-2]) cube([plate_width, plate_length, plate_thickness]);  
         
        // Top 'ceiling' wall  
        translate([-(wall_length), 0, 10]) cube([wall_length, plate_length, plate_height - 10]); 
          
        // Bottom 'floor' wall
        translate([-(wall_length), 0, 0]) cube([wall_length, plate_length, plate_height - 10]);
         
        holders(); 
      }
    
      // Mounting plate drills
      translate([2,  -32, 10]) rotate([0,90,0]) inset_drills(2, 3.75, 2);
      
      // Beam connector
      translate([-(wall_length-2.5), 0, 2]) cube([(wall_length-3), plate_length, 16]);
      
      // Cutout at snap area
      translate([-wall_length, 0, 3.5]) cube([2.5, plate_length, 13]);
    }
}

rotate([0, 90, 180]) {
    rotate([0, 0, 90]) translate([9, 0, -10]) plate();
    //rotate([0, 90, 180]) translate([0, 0, 0]) openbeam();
}
