// Created by Crowbar 0.74

$modelname "mvm_ascent\tunnel\train_tunnel_01.mdl"

$scale 12

$staticprop

$bodygroup "body"
{
	studio "train_tunnel_01_reference.smd"
}


$surfaceprop "stone"

$contents "solid"

$illumposition 3.25 0 196.997

$cdmaterials "models\props_forest\"

$cbox 0 0 0 0 0 0

$bbox -232.917 -135.03 -0.006 232.917 141.53 394

$definebone "static_prop" "" 0 0 0 0 0 0 0 0 0 0 0 0


$sequence "idle" {
	"train_tunnel_01_anims\idle.smd"
	fadein 0.2
	fadeout 0.2
	fps 30
}

$collisionmodel "train_tunnel_01_collision.smd"
{
	$mass 1000
	$inertia 1
	$damping 0
	$rotdamping 0
	$rootbone " "
	$concave
	$maxconvexpieces 30

}
