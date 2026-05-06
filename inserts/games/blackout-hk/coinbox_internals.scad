include <../../The-Boardgame-Insert-Toolkit.v2.45/boardgame_insert_toolkit_lib.2.scad>;

coin_diametre = 25;

insert_height = 23;
insert_width = 108;
insert_depth = 114;

box_height = insert_height - 3;
box_width = (insert_width);
box_depth = insert_depth;

scout_tile_xy = 22.7;
scout_tile_thickness = 1.95;
scout_tile_compartment_depth = scout_tile_thickness * 8;

// determines whether lids are output.
g_b_print_lid = false;

// determines whether boxes are output.
g_b_print_box = true; 

// Focus on one box
g_isolated_print_box = ""; 

// Used to visualize how all of the boxes fit together. 
g_b_visualization = false;          
        
// this is the outer wall thickness.
//Default = 1.5mm
g_wall_thickness = 3;

// The tolerance value is extra space put between planes of the lid and box that fit together.
// Increase the tolerance to loosen the fit and decrease it to tighten it.
//
// Note that the tolerance is applied exclusively to the lid.
// So if the lid is too tight or too loose, change this value ( up for looser fit, down for tighter fit ) and 
// you only need to reprint the lid.
// 
// The exception is the stackable box, where the bottom of the box is the lid of the box below,
// in which case the tolerance also affects that box bottom.
//
g_tolerance = 0.15;

// This adjusts the position of the lid detents downward. 
// The larger the value, the bigger the gap between the lid and the box.
g_tolerance_detents_pos = 0.1;


data =
[
	[   "simple box",
		[
			[ BOX_SIZE_XYZ, [box_width, box_depth, box_height] ],
			[ BOX_STACKABLE_B, f ],
			[ BOX_NO_LID_B, true ],
			
			[ BOX_COMPONENT,
				[ // Dice + starting player marker
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ box_width/2-g_wall_thickness,box_depth/2-g_wall_thickness,20 ] ],
					[ CMP_NUM_COMPARTMENTS_XY, [2, 2]],
					//[ POSITION_XY, [-1,scout_tile_xy*2+g_wall_thickness*2]],
					[ CMP_SHAPE, FILLET ],
					[ CMP_FILLET_RADIUS, 20 ],
				]
			],
		]
	],
];


MakeAll();