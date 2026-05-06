
//insert_height = 20;
//insert_width = 108;
//insert_depth = 114;

include <../../box.scad>

internal_dimensions = [108, 114, 20];
box_internals = [internal_dimensions.x - wall_width*2, internal_dimensions.y - wall_width - back_wall_width, internal_dimensions.z];

module box_internals()
{
	include <coinbox_internals.scad>
}


union()
{
	box(box_internals, enable_fillet=false, enable_floor=false, num_slots = 2);
	
	translate([0,0,-wall_width])
	translate(-internal_dimensions/2)
	box_internals();
}

neighbouring_lid(box_internals, num_slots = 2, label="Money");
