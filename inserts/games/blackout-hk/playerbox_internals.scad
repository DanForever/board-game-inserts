include <../../The-Boardgame-Insert-Toolkit.v2.45/boardgame_insert_toolkit_lib.2.scad>;

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
g_wall_thickness = 1.5;

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
			[ BOX_SIZE_XYZ, [60, 126, 20] ],
			[ BOX_STACKABLE_B, f ],
			[ BOX_NO_LID_B, true ],
			[ BOX_LID,
				[
					[ LID_PATTERN_RADIUS, 5],
					[ LID_PATTERN_THICKNESS, 1],
					[ LID_PATTERN_N1,               5 ],
					[ LID_PATTERN_N2,               10 ],
					[ LID_PATTERN_ANGLE,            60 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       140 ],
					[ LID_PATTERN_THICKNESS,        0.6 ],
					[ LID_FIT_UNDER_B, f],
				],
					[ ENABLED_B, f ],
			],
			[ BOX_COMPONENT,
				[ // cubes
					[CMP_COMPARTMENT_SIZE_XYZ,  [ 55, 40, 20 ] ],
					[CMP_SHAPE, FILLET],
					[POSITION_XY, [CENTER,0]],
					[CMP_FILLET_RADIUS, 25],
				]
			],
			[ BOX_COMPONENT,
				[ // houses
					[CMP_COMPARTMENT_SIZE_XYZ,  [ 10.5*5, 14.7, 12 ] ],
					[POSITION_XY, [CENTER,42]],
					//[ CMP_CUTOUT_SIDES_4B, [ f, t, f, f ] ],
					//[ CMP_CUTOUT_WIDTH_PCT, 10.2*10 ],
					//[ CMP_CUTOUT_TYPE, EXTERIOR ],
					//[ CMP_CUTOUT_DEPTH_PCT, 0 ],
					//[ CMP_CUTOUT_HEIGHT_PCT, 50 ]
				]
			],
			[ BOX_COMPONENT,
				[  // House cutout
					[CMP_COMPARTMENT_SIZE_XYZ,  [ 10.6*7.4, 9.3, 10 ] ],
					[POSITION_XY, [CENTER,42+13.2]],
					[ CMP_SHAPE, ROUND ]
				]
			],
			[ BOX_COMPONENT,
				[ // Score token
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ 16, 16, 5 ] ],
					[ POSITION_XY, [5.5,42+13+8+4.5] ],
					[ CMP_SHAPE, ROUND ],
					[ CMP_SHAPE_VERTICAL_B, t ],
					[ CMP_CUTOUT_SIDES_4B, [ f, f, t, t ] ],
					[ CMP_CUTOUT_WIDTH_PCT, 90 ],
					[ CMP_CUTOUT_DEPTH_PCT, 40 ],
				]
			],
			[ BOX_COMPONENT,
				[ // Coins
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ 20.45, 20.45, 2*4 ] ],
					[ POSITION_XY, [31.5,42+13+8+2] ],
					[ CMP_SHAPE, ROUND ],
					[ CMP_SHAPE_VERTICAL_B, t ],
					[ CMP_CUTOUT_SIDES_4B, [ f, f, t, t ] ],
					[ CMP_CUTOUT_WIDTH_PCT, 80 ],
					[ CMP_CUTOUT_DEPTH_PCT, 30 ],
					[ CMP_CUTOUT_TYPE, INTERIOR ],
					[ CMP_CUTOUT_BOTTOM_B, true ],
				]
			],
			[ BOX_COMPONENT,
				[ // Trucks
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ 20.2, 16.2, 2*5 ] ],
					[ POSITION_XY, [31.5,42+13+8+22+1.5]],
					[ CMP_CUTOUT_SIDES_4B, [ f, f, t, t ] ],
					[ CMP_CUTOUT_WIDTH_PCT, 85 ],
					[ CMP_CUTOUT_DEPTH_PCT, 5 ],
					[ CMP_CUTOUT_TYPE, INTERIOR ],
					[ CMP_CUTOUT_BOTTOM_B, true ],
				]
			],
			[ BOX_COMPONENT,
				[ // hand size
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ 15.3, 15.3, 2 ] ],
					[ POSITION_XY, [6,42+13+8+22+1.5]],
					[ CMP_CUTOUT_SIDES_4B, [ f, f, t, t ] ],
					[ CMP_CUTOUT_WIDTH_PCT, 80 ],
				]
			],
			[ BOX_COMPONENT,
				[ // slot blocker
					[ CMP_COMPARTMENT_SIZE_XYZ,  [ 57, 14.8, 2 ] ],
					[ POSITION_XY, [CENTER,42+13+15+21+17] ],
					[ CMP_SHAPE_VERTICAL_B, t ],
					[ CMP_CUTOUT_SIDES_4B, [ t, f, f, f ] ],
					[ CMP_CUTOUT_DEPTH_PCT, 75 ]
				]
			],
		]
	],
];


MakeAll();