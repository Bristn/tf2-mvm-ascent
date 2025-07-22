// Created by Crowbar 0.74

$modelname "mvm_ascent\hologram\robot_hologram.mdl"

$bodygroup "body"
{
	studio "robot_hologram.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition 0 -3.369 69.354

$cdmaterials "models\mvm_ascent\hologram\"

$texturegroup "skinfamilies"
{
	{ "robo_beam_neutral" "robo_marker_neutral" "robo_marker_neutral_dark" }		
	{ "robo_beam_blue" "robo_marker_blue" "robo_marker_blue_dark" }		
}

$cbox 0 0 0 0 0 0

$bbox -32.468 -9.581 0 39.205 9.581 138.708

$definebone "group1" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "ref" {
	"robot_hologram_anims\ref.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}
