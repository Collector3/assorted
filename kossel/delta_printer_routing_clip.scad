// Kossel 1515 extrusion cable organizer/clip
// License: CC1.0 Universal

plate_length = 25;
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
      }
    
      // Mounting plate drills
      #translate([2,  -27.5, 10]) rotate([0,90,0]) inset_drills(2, 3.75, 2);
      
      // Driver drills
      for ( i = [ 1 : num_drills ] ) {
        translate([15, -2, 2]) translate([0, i*20, -3]) polyhole(9, 4.5);
        translate([15, -2, 16]) translate([0, i*20, -3]) polyhole(9, 4.5);
          
        translate([15, -13, 2]) translate([0, i*20, -3]) polyhole(9, 4.5);
        translate([15, -13, 16]) translate([0, i*20, -3]) polyhole(9, 4.5);
      }
      
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
