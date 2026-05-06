
length = 154;
depth = 17;
height = 46;

wall_size = 5;


length_cutout = length - wall_size * 2;
depth_cutout = depth + 2;
height_cutout = height - wall_size * 2;
	
rotate([90,0,0])
difference()
{
	cube([length, depth, height], center = true);

	cube([length_cutout, depth_cutout, height_cutout], center = true);
	
	translate([0,0,height/2])
	linear_extrude(0.5, center=true)
	text("Blackout: Hong kong", halign="center", valign="center");
}
