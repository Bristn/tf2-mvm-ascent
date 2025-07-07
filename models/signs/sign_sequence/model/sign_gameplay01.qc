// Created by Crowbar 0.74

$modelname "mvm_ascent\sign\sign_sequence.mdl"

$staticprop

$bodygroup "Body"
{
	studio "sign_gameplay01.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 -1.5 0

$cdmaterials "models\mvm_ascent\sign\"

$texturegroup "skinfamilies"
{
	{ "sign_sequence_state_active"  }			// 0
	{ "sign_sequence_state_complete"  }			// 1
	{ "sign_sequence_state_failure"  }			// 2
	{ "sign_sequence_state_inactive"  }			// 3
	{ "sign_sequence_state_title"  }			// 4

	{ "sign_sequence_step_title"  }				// 5

	{ "sign_sequence_step_drain_active"  }		// 6
	{ "sign_sequence_step_drain_error"  }		// 7
	{ "sign_sequence_step_drain_inactive"  }	// 8

	{ "sign_sequence_step_gate_1_active"  }		// 9
	{ "sign_sequence_step_gate_1_error" }		// 10
	{ "sign_sequence_step_gate_1_inactive" }	// 11

	{ "sign_sequence_step_gate_2_active"  }		// 12
	{ "sign_sequence_step_gate_2_error" }		// 13
	{ "sign_sequence_step_gate_2_inactive" }	// 14

	{ "sign_sequence_step_gate_3_active"  }		// 15
	{ "sign_sequence_step_gate_3_error" }		// 16
	{ "sign_sequence_step_gate_3_inactive" }	// 17
}

$cbox 0 0 0 0 0 0

$bbox -0.25 -35.25 -12.25 3 35.25 12.25

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"sign_gameplay01_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "sign_gameplay01_physics.smd"
{
	$mass 16.7234
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
}
