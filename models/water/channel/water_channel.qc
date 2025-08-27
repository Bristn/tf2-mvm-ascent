// Created by Crowbar 0.74

$modelname "mvm_ascent\water\water_channel.mdl"

$scale 100

$bodygroup "body"
{
	studio "water_channel.smd"
}

$surfaceprop "water"

$contents "solid"

$cdmaterials "models\mvm_ascent\water\"

$illumposition 0 -3.369 69.354

$cbox 0 0 0 0 0 0

$definebone "group1" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
	"anims\big_idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

$sequence "drain" {
	"anims\big_drain.smd"
	fadein 0.2
	fadeout 0.2
	fps 24
}

