// Created by Crowbar 0.74

$modelname "mvm_ascent\water\water.mdl"

$scale 100

$bodygroup "body"
{
	studio "water.smd"
}


$surfaceprop "water"

$contents "solid"

$illumposition 0 -3.369 69.354

$cdmaterials "models\mvm_ascent\water\"

$cbox 0 0 0 0 0 0

$bbox -32.468 -9.581 0 39.205 9.581 138.708

$definebone "group1" "" 0 0 0 0 0 0 0 0 0 0 0 0

$sequence "idle" {
	"anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}


$sequence "drain" {
	"anims\drain.smd"
	fadein 0.2
	fadeout 0.2
	fps 15
}

