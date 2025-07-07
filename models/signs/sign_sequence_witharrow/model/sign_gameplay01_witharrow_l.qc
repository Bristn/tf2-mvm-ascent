// Created by Crowbar 0.74

$modelname "mvm_ascent\sign\sign_sequence_witharrow.mdl" 

$staticprop

$bodygroup "Body"
{
	studio "sign_gameplay01_witharrow_L.smd"
}


$surfaceprop "metal"

$contents "solid"

$illumposition 0 -1.5 0

$cdmaterials "models\mvm_ascent\sign\"

$texturegroup "skinfamilies"
{
	{ "sign_sequence_state_active"  }
	{ "sign_sequence_state_complete"  }
	{ "sign_sequence_state_failure"  }
	{ "sign_sequence_state_inactive"  }
	{ "sign_sequence_state_title"  }

	{ "sign_sequence_step_title"  }

	{ "sign_sequence_step_drain_active"  }
	{ "sign_sequence_step_drain_error"  }
	{ "sign_sequence_step_drain_inactive"  }

	{ "sign_sequence_step_gate_1_active"  }
	{ "sign_sequence_step_gate_1_error" }
	{ "sign_sequence_step_gate_1_inactive" }

	{ "sign_sequence_step_gate_2_active"  }
	{ "sign_sequence_step_gate_2_error" }
	{ "sign_sequence_step_gate_2_inactive" }

	{ "sign_sequence_step_gate_3_active"  }
	{ "sign_sequence_step_gate_3_error" }
	{ "sign_sequence_step_gate_3_inactive" }
}

$cbox 0 0 0 0 0 0

$bbox -0.25 -47.43 -12.25 3 47.43 12.25

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"sign_gameplay01_witharrow_l_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "sign_gameplay01_witharrow_l_physics.smd"
{
	$mass 22.43588
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "

}
