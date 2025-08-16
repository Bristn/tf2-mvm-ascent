// Created by Crowbar 0.74

$modelname "mvm_ascent\pipes\gutter_pipe_64.mdl"

$staticprop

$bodygroup "Body"
{
	studio "gutter_pipe_64.smd"
}


$surfaceprop "default"

$contents "solid"

$illumposition -0.3 0 0

$cdmaterials "models\props_farm\"

$texturegroup "skinfamilies"
{
	{ "gutters001"  }
	{ "gutters001a" }
}

$cbox 0 0 0 0 0 0

$bbox -10 -6.6 -64.25 10 6.25 64.25

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"gutter_pipe_64_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "gutter_pipe_64_physics.smd"
{
	$mass 10
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 1

}
