// [ BOX_SIZE_XYZ, [60, 126, 20] ],


internal_dimensions = [60, 126, 20];
box_internals = [internal_dimensions.x - 1, internal_dimensions.y - 1, internal_dimensions.z];

eps = 0.01;

module box_internals()
{
	include <playerbox_internals.scad>
}

include <../../box.scad>

union()
{
	box(box_internals, enable_fillet=false, enable_floor=false);
	
	translate([0,0,-wall_width])
	translate(-internal_dimensions/2)
	box_internals();
}

neighbouring_lid(box_internals);