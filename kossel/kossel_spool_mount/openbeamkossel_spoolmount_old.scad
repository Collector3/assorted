// License: CC0 Universal 1.0
// Notes: Weekend project. Hacks galore.
// FWIW, most things are dialed in, but there may be weird places
// that are happy only at a certain range/constants. Defaults are 
// mostly appropriate for the spool holder this is designed for though.

$fn = 30;

// ** Bracket Panel Settings **
// These control how the bracket (which contacts the OpenBeam) is shaped
bracket_thickness = 3;
bracket_length = 64;
bracket_slot_width = 28;
bracket_depth = 12; // Note that thickness of other parts affects depth
						// of the slot. bracket_side_thickness+bracket_thickness
						// contribute to the overall shape. You must account
						// for this in the parameterization.
						// bracket_depth-(bracket_side_thickness+bracket_thickness)


// ** Side Panel Settings **
// Change bracket_side_height if you want the captive area to be
// higher. This adjusts other dependents as well, such as the front
// retainer.
bracket_side_height = bracket_length/1.60;
bracket_side_width = bracket_depth; //bracket_thickness+bracket_side_height;
bracket_side_thickness = 2;

// ** Front Retention Plate Settings **
bracket_retainer_thickness = 2;
bracket_retainer_dist_from_panel = bracket_depth;
bracket_retainer_height = bracket_length-bracket_side_height;

// ** Bottom Panel Settings **
bracket_bottom_length = 0;
bracket_bottom_thickness = bracket_depth+bracket_retainer_thickness;

// ** Drill Settings **
// M3 screws are used for mounting to OpenBeam extrusion
// drill_orientation: 1 = horizontal, 0 = vertical.
// Vertical notes:
// 1. A front pocket is created to ease the use of driving in
//    M3 screws at bottom. Not present on the horizontal version.
// 2. The rear panel is also extended by 
//    vertical_panel_bottom_extension. See its notes below for info.
drill_orientation = 2; // 2 == combined, 1 == horizontal, 0 = vertical

// When using vertical drills, extending the bottom by a bit helps with
// holder strain relief, since it can't be "clipped" to the back of
// the extrusion as on the horizontal configuration.
// This is a non-op if horizontal drills are used.
vertical_panel_bottom_extension = 0; 

num_drills  = 3;
drill_depth = bracket_thickness;
inset_depth = 1.5;

// Note that drill will be slightly larger or smaller on some printers. 
// Adjust as needed. 
drill_size  = 3.7; 

// ** Calculations **
// Normally you do not need to change these unless something is weird.

// bracket_width
// Combines the slot width into the total bracket width. Asking for
// slot width is easier/less annoying than making the user do the 
// math themselves.
bracket_width = bracket_slot_width+(bracket_side_thickness*2);

module side_panels() {
	cube([bracket_side_height, bracket_side_thickness, 
		bracket_side_width]);
}

module drills(num_drills) {
	for ( i = [1 : num_drills ] ) {
		if (drill_orientation == 1) {
		  // Horizontal orientation. Add 7mm spacing from top so that
		  // the adapter ends up peeking over the extrusion a bit..
		  // that way, the holder can be placed flush with the
	     // rear of the holder for additional support.
		  translate([bracket_width/3+7, i*(bracket_width/4), -1]) cylinder(r=drill_size/2, h=drill_depth+1);
		  translate([bracket_width/3+7, i*(bracket_width/4), bracket_thickness-inset_depth]) cylinder(r=drill_size/1.2, h=inset_depth);
		} else if(drill_orientation == 0) {
	   	  // Vertical orientation
		  translate([(i*9), bracket_width/2, -1]) cylinder(r=drill_size/2, h=drill_depth+1);
		  translate([(i*9), bracket_width/2, bracket_thickness-inset_depth]) cylinder(r=drill_size, h=inset_depth);
		} else if(drill_orientation == 2) {
		  // This combines both horizontal and vertical orientations
		  // but adds a bit of spacing to the drills.
		  // Max drills is 3 in horizontal, but more for vertical.

		  // Horizontal orientation
		  if(i % 2 == 1) { // Don't do even numbered drills
		  	translate([bracket_width/3.5, i*(bracket_width/4), -1]) cylinder(r=drill_size/2, h=drill_depth+1);
		  	translate([bracket_width/3.5, i*(bracket_width/4), bracket_thickness-inset_depth]) cylinder(r=drill_size/1.2, h=inset_depth);
		  }

  	     // Vertical orientation
		  translate([(i*9), bracket_width/2, -1]) cylinder(r=drill_size/2, h=drill_depth+1);
		  translate([(i*9), bracket_width/2, bracket_thickness-inset_depth]) cylinder(r=drill_size/1.2, h=inset_depth);
		}
	}
}

union() {
	// Back panel
	difference() {
		if(drill_orientation == 1) {
		translate([0, 0, 0]) cube([bracket_length, bracket_width, bracket_thickness]);
		} else {
		translate([0, 0, 0]) cube([bracket_length+vertical_panel_bottom_extension, bracket_width, bracket_thickness]);
		}
		drills(num_drills);
	}

	// Bottom panel. -.1 for patchup.
	translate([bracket_length-.1,0,0]) 
		#cube([bracket_bottom_length, bracket_width, 
			bracket_bottom_thickness]);

	// Side panel -- Left
	translate([bracket_length-bracket_side_height, 0, 0]) 
		side_panels();

	// Side panel -- Right
	translate([bracket_length-bracket_side_height, bracket_width-2, 0]) 
		side_panels();

	// Retainer panel with center cutout
	difference() {
		translate([bracket_retainer_height, 0, 
			bracket_retainer_dist_from_panel]) cube([bracket_side_height, 
				bracket_width, bracket_retainer_thickness]);
		if(drill_orientation == 0 || drill_orientation == 2) {
		// Cutout, centered based on drill if doing vertical drills
		translate([bracket_retainer_height, bracket_width/PI+1, 
			bracket_retainer_dist_from_panel]) cube([4*num_drills,10,5+bracket_retainer_thickness]);
		}
	}
}

translate([30,30,30]) import("R2_spool_holder.scad");
