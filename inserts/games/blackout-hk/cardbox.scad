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

card_shear_angle = 20;

card_height = 90;
card_width = 60;

starter_deck_thickness = 7;
emergency_plan_deck_thickness = 4;
dice_distribution_deck_thickness = 4;
s_deck_thickness = 5;
main_deck_thickness = 35;

cutout_percentage = 70;

slot_separation_thickness = 2;

slot_angle = 90 - card_shear_angle;
slot_offset_caused_by_shear = (cos(slot_angle)*card_width)*0.615;

tiger_deck_slot_position = slot_offset_caused_by_shear;
tiger_deck_slot_thickness = starter_deck_thickness;
tiger_deck_slot_label = "Tiger";
tiger_deck_slot_icon = "tiger.svg";

dragon_deck_slot_position = tiger_deck_slot_position + tiger_deck_slot_thickness + slot_separation_thickness;
dragon_deck_slot_thickness = starter_deck_thickness;
dragon_deck_slot_label = "Dragon";
dragon_deck_slot_icon = "dragon.svg";

ox_deck_slot_position = dragon_deck_slot_position + dragon_deck_slot_thickness + slot_separation_thickness;
ox_deck_slot_thickness = starter_deck_thickness;
ox_deck_slot_label = "Ox";
ox_deck_slot_icon = "ox.svg";

horse_deck_slot_position = ox_deck_slot_position + ox_deck_slot_thickness + slot_separation_thickness;
horse_deck_slot_thickness = starter_deck_thickness;
horse_deck_slot_label = "Ox";
horse_deck_slot_icon = "ox.svg";

emergency_plan_deck_slot_position = horse_deck_slot_position + horse_deck_slot_thickness + slot_separation_thickness;
emergency_plan_deck_slot_thickness = emergency_plan_deck_thickness;
emergency_plan_deck_slot_label = "Ox";
emergency_plan_deck_slot_icon = "ox.svg";

dice_distribution_deck_slot_position = emergency_plan_deck_slot_position + emergency_plan_deck_slot_thickness + slot_separation_thickness;
dice_distribution_deck_slot_thickness = dice_distribution_deck_thickness;

s_deck_slot_position = dice_distribution_deck_slot_position + dice_distribution_deck_slot_thickness + slot_separation_thickness;
s_deck_slot_thickness = s_deck_thickness;

main_deck_slot_position = s_deck_slot_position + s_deck_slot_thickness + slot_separation_thickness;
main_deck_slot_thickness = main_deck_thickness;

box_length =
	tiger_deck_slot_thickness +
	dragon_deck_slot_thickness +
	ox_deck_slot_thickness +
	horse_deck_slot_thickness +
	emergency_plan_deck_slot_thickness +
	dice_distribution_deck_slot_thickness +
	s_deck_slot_thickness +
	main_deck_slot_thickness +
	(7 * slot_separation_thickness) +
	(cos(slot_angle) * card_width) +
	(g_wall_thickness * 2);

box_height = sin(slot_angle) * card_width;

function shear_correction_y(angle, box_height, compartment_height) = -tan(angle)*(box_height/2 - g_wall_thickness - cos(angle)*compartment_height/2);

data =
[
	[   "cards",
		[
			[ BOX_SIZE_XYZ, [ card_height + (g_wall_thickness*2), box_length, box_height] ],
			[ BOX_STACKABLE_B, f ],
			[ BOX_NO_LID_B, true ],
			[ BOX_LID,
				[
					[ LID_PATTERN_RADIUS, 10],
					[ LID_PATTERN_THICKNESS, 1.5],
					[ LABEL,
						[
							[ LBL_TEXT,     "STOCK"],
							[ LBL_SIZE,     AUTO ],
						]
					],  

					[ LID_PATTERN_N1,               10 ],
					[ LID_PATTERN_N2,               10 ],
					[ LID_PATTERN_ANGLE,            60 ],
					[ LID_PATTERN_ROW_OFFSET,       10 ],
					[ LID_PATTERN_COL_OFFSET,       140 ],
					[ LID_PATTERN_THICKNESS,        0.6 ],
				],
			],
			[ BOX_COMPONENT,
				[ // cutout
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height * (cutout_percentage/100), box_length - (g_wall_thickness*2), card_width] ],
				]
			],
			[ BOX_COMPONENT,
				[ // player starter deck (tiger)
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, tiger_deck_slot_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,tiger_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, false],
//							//[LBL_TEXT,        tiger_deck_slot_label],
//							[LBL_IMAGE, tiger_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // player starter deck (dragon)
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, dragon_deck_slot_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,dragon_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_, false],
//							[LBL_TEXT,        dragon_deck_slot_label],
//							//[LBL_IMAGE, dragon_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        1],
//							[ LBL_DEPTH, 1 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // player starter deck (ox)
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, ox_deck_slot_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,ox_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // player starter deck (horse)
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, horse_deck_slot_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,horse_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // Emergency plan
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, emergency_plan_deck_slot_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,emergency_plan_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // Dice distribution
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, dice_distribution_deck_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,dice_distribution_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // s cards
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, s_deck_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,s_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
			[ BOX_COMPONENT,
				[ // main cards
					[CMP_COMPARTMENT_SIZE_XYZ,      [card_height, main_deck_thickness, card_width] ],
					[CMP_SHEAR,                     [0,card_shear_angle]],
					[POSITION_XY,                   [0,main_deck_slot_position - shear_correction_y(card_shear_angle, box_height, box_height)]],
//					[LABEL,
//						[
//							[ENABLED_B, labels_enabled],
//							//[LBL_TEXT,        ox_deck_slot_label],
//							[LBL_IMAGE, ox_deck_slot_icon],
//							[LBL_PLACEMENT,   BACK_WALL],
//							[LBL_SIZE,        4],
//							[ LBL_DEPTH, 4 ],
//							[POSITION_XY, [38,27]],
//						]
//					]
				]
			],
		]
	],
];


MakeAll();