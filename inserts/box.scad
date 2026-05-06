wall_width = 3;
back_wall_width = 3.4;

minimum_wall_width = 1.5;

magnet_depth = 2;
magnet_diameter = 3;
magnet_radius = magnet_diameter / 2;

magnet_slot_tolerance = 1.09;
lid_cutout_tolerance = 0.3;

box_y_centre_adjustment = -back_wall_width/2 + wall_width/2;

function calc_outer_volume(internal_volume = [1,1,1], enable_floor = true) = 
[
	internal_volume.x + wall_width + wall_width,
	internal_volume.y + wall_width + back_wall_width,
	internal_volume.z + wall_width + (enable_floor? wall_width : 0),
];

function calc_lid_depth(internal_volume = [1,1,1]) = internal_volume.y + wall_width;

module magnet_slot()
{
	scale([magnet_slot_tolerance, magnet_slot_tolerance, magnet_slot_tolerance])
	rotate([90,0,0])
	union()
	{
		cylinder(magnet_depth, d=magnet_diameter, $fn=30, center = true);
		
		translate([0, magnet_diameter/2,0])
		cube([magnet_diameter, magnet_diameter, magnet_depth], center = true);
	}
}

module multi_magnet_slot(internal_volume = [1,1,1], num_slots = 1)
{
	originalX = internal_volume.x / 2;
	spacing = internal_volume.x / (num_slots + 1);
	leftmostX = -originalX;
	
	for(i = [0:num_slots-1])
	{
		translate([leftmostX+spacing*(i+1),0,0])
		magnet_slot();
	}
}

module box_magnet_slot(internal_volume = [1,1,1], num_slots = 1, enable_floor = true)
{
	outer_volume = calc_outer_volume(internal_volume);
	
	translation =
	[
		0,
		outer_volume.y/2-back_wall_width/2,
		outer_volume.z/2-magnet_diameter/2-(enable_floor? 0 : wall_width/2)
	];
	
	
	difference()
	{
		children();
		
		translate(translation)
		#multi_magnet_slot(internal_volume, num_slots);
		//magnet_slot();
	}
}

module lid_magnet_slot(internal_volume = [1, 1, 1], num_slots = 1)
{
	lid_depth = calc_lid_depth(internal_volume);
	
	distance_from_edge = 0.3;
	magnet_slot_y = lid_depth/2 - (magnet_depth*magnet_slot_tolerance)/2 - distance_from_edge;
	
	//translate([0,lid_depth/2-magnet_depth/2-0.6, magnet_diameter/2+0.1])
	translate([0,magnet_slot_y, magnet_diameter/2+0.1])
	multi_magnet_slot(internal_volume, num_slots);
	//magnet_slot();
}

module internal_volume(internal_volume = [1,1,1], enable_floor = true)
{
	dimensions =
	[
		internal_volume.x,
		internal_volume.y,
		internal_volume.z + wall_width + (enable_floor? wall_width : 0),
	];
	
	translation =
	[
		0,
		-(back_wall_width - wall_width),
		enable_floor? wall_width : 0,
	];
	
	translate(translation)
	cube(dimensions, center = true);
}

module fillet(internal_volume = [1,1,1])
{
	radius = internal_volume.z+(wall_width/6);
	x_scale = (internal_volume.x/radius)/2;
	
	difference()
	{
		internal_volume(internal_volume);
		
		translate([0, 0, internal_volume.x/2])
		internal_volume(internal_volume);
		
		scale([x_scale,2,1])
		translate([0,0,(internal_volume.z/2)])
		rotate([-90, 0, 0])
		cylinder(internal_volume.y, r=radius, center = true, $fn=64);
	}
}

module cutout_internals(internal_volume = [1,1,1], enable_floor = true)
{
	difference()
	{
		children();
		
		internal_volume(internal_volume, enable_floor);
	}
}

module cutout_lid(internal_volume = [1,1,1], enable_floor = true)
{
	outer_volume = calc_outer_volume(internal_volume, enable_floor);
	
	lid_width = outer_volume.x - minimum_wall_width - minimum_wall_width;
	lid_top_width = lid_width - wall_width - wall_width;
	
	x_centre_offset = lid_width / 2;
	
//   2  --  3
//     /  \
//	 1 ---- 4
	
	x1 = 0                            - lid_cutout_tolerance;
	y1 = 0;
	
	x2 = wall_width                   - lid_cutout_tolerance;
	y2 = wall_width                   + lid_cutout_tolerance;
	
	x3 = lid_top_width + wall_width   + lid_cutout_tolerance;
	y3 = wall_width                   + lid_cutout_tolerance;
	
	x4 = lid_width                    + lid_cutout_tolerance;
	y4 = 0;
	
	left_triangle =
	[
		[x1, y1],
		[x2, y2],
		[x2, y1]
	];
	
	right_triangle =
	[
		[x3, y3],
		[x4, y4],
		[x3, y4]
	];
	
	lid_depth = calc_lid_depth(internal_volume);
	
	x_offset = 0;
	y_offset = -(wall_width - back_wall_width) - (internal_volume.y / 2);
	z_offset = internal_volume.z;
	
	difference()
	{
		children();
		
		color("lightblue")
		translate([0, -internal_volume.y/2-back_wall_width, outer_volume.z/2 - wall_width])
		scale([1, 2, 1])
		lid(internal_volume);
		
		translate([0, -back_wall_width/2, outer_volume.z/2 - wall_width])
		translate([-x_centre_offset, (wall_width - back_wall_width) / 2, 0])
		rotate([90, 0, 0])
		linear_extrude(lid_depth, center = true)
		polygon(left_triangle);
		
		translate([0, -back_wall_width/2, outer_volume.z/2 - wall_width])
		translate([-x_centre_offset, (wall_width - back_wall_width) / 2, 0])
		rotate([90, 0, 0])
		linear_extrude(lid_depth, center = true)
		polygon(right_triangle);
		
		translate([x_offset, y_offset, z_offset])
		scale([1,2,1])
		internal_volume(internal_volume);
	}
}

module box(internal_volume = [1, 1, 1], enable_fillet = true, enable_floor = true, num_slots = 1)
{
	outer_volume = calc_outer_volume(internal_volume, enable_floor);
	
	floor_translation = enable_floor? [0,0,0] : [0,0,-wall_width/2];
	
	translate(floor_translation)
	cutout_lid(internal_volume, enable_floor)
	box_magnet_slot(internal_volume, num_slots, enable_floor)
	union()
	{
		if(enable_fillet) fillet(internal_volume);
			
		cutout_internals(internal_volume, enable_floor)
		cube(outer_volume, center = true);
	}
}

module lid(internal_volume = [1, 1, 1], num_slots = 1)
{
	outer_volume = calc_outer_volume(internal_volume);
	
	lid_width = outer_volume.x - minimum_wall_width - minimum_wall_width;
	lid_top_width = lid_width - wall_width - wall_width;
	lid_depth = calc_lid_depth(internal_volume);
	
	x1 = 0;
	y1 = 0;
	
	x2 = wall_width;
	y2 = wall_width;
	
	x3 = lid_top_width + wall_width;
	y3 = wall_width;
	
	x4 = lid_width;
	y4 = 0;

	x_centre_offset = lid_width / 2;
	
	magnet_slot_y = magnet_depth + outer_volume.y - wall_width;

	difference()
	{
		rotate([90, 0, 0])
		linear_extrude(lid_depth, center = true)
		polygon([[x1 - x_centre_offset, y1], [x2 - x_centre_offset,y2], [x3 - x_centre_offset,y3], [x4 - x_centre_offset,y4]]);
		
		//translate([0,lid_depth/2-magnet_depth/2-0.6, magnet_diameter/2+0.1])
		lid_magnet_slot(internal_volume, num_slots);
		//translate([0,lid_depth/2-magnet_depth/2-0.6, magnet_diameter/2+0.1])
		//magnet_slot();
	}
	
}

module lid_with_label(label, internal_volume = [1, 1, 1], num_slots = 1)
{
	difference()
	{
		lid(internal_volume, num_slots);
		
		translate([0,0,wall_width/6*7])
		linear_extrude(wall_width, center = true)
		text(label, halign="center", valign="center");
	}
}

module neighbouring_lid(internal_volume = [1, 1, 1], num_slots = 1, label = undef)
{
	outer_volume = calc_outer_volume(internal_volume);
	
	translate([outer_volume.x + wall_width,0, -outer_volume.z/2])
	if(label == undef) lid(internal_volume, num_slots); else lid_with_label(label, internal_volume, num_slots);
	
}

module inplace_lid(internal_volume = [1, 1, 1], enable_floor = true, num_slots = 1)
{
	translate([0, -back_wall_width/2, internal_volume.z/2 + (enable_floor? 0 : -wall_width)])
	lid(internal_volume, num_slots);
}

*box([60,126,20], enable_fillet = false, enable_floor = false, num_slots = 3);

*neighbouring_lid([60,126,20],  num_slots = 2, label = "Money");

color("lightblue")
*inplace_lid([60,126,20], enable_floor = false, num_slots = 3);

//fillet();
