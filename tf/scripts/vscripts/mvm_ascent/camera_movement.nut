// script_reload_code mvm_ascent/camera_movement

class CameraMovement {
	tank = null
	camera = null

	// Defines max position & rotation changes to make the camera movement smoother
	maxDistancePerTick = 5
	maxRotationPerTick = 0.75

	function initMainCamera() {
		tank = Entities.FindByName(null, "tank_viewcontrol_main");
		camera = Entities.FindByName(null, "viewcontrol");
		this.init();
	}

	function initWaterCamera() {
		tank = Entities.FindByName(null, "tank_viewcontrol_water");
		camera = Entities.FindByName(null, "viewcontrol");
		this.init();
	}

	function init() {
		local tankPos = tank.GetOrigin();
		local tankAngles = tank.GetAngles();
		camera.SetOrigin(tankPos);
		camera.SetAngles(tankAngles.x, tankAngles.y, tankAngles.z);
	}

	function update() {
		if (tank == null || camera == null) return;

		local tankPos = tank.GetOrigin();
		local cameraPos = camera.GetOrigin();

		// Calculate direction and distance
		local direction = tankPos - cameraPos;
		local distance = direction.Length();

		// Interpolate the camera position
		local moveDist = this.min(distance, maxDistancePerTick);
		local moveDir = this.normalize(direction)
		local newCameraPos = cameraPos + moveDir.Scale(moveDist);
		camera.SetOrigin(newCameraPos);

		// Interpolate the camera rotation
		local cameraAngles = camera.GetAngles();
		local tankAngles = tank.GetAngles();
		local newAngles = this.interpolateRotation(cameraAngles, tankAngles, 0.015)
		camera.SetAngles(newAngles.x, newAngles.y, newAngles.z);
	}

	function normalize(vec) {
		local distance = vec.Length()
		return Vector(vec.x / distance, vec.y / distance, vec.z / distance);
	}

	function min(a, b) {
		if (a < b) return a
		return b;
	}

	// Ensures the that the returned value is the shortest angle between the two rotations.
	// Otherwise the camera occasionally spins 360 degrees
	function getClosesAngle(delta) {
		delta = (delta + 180.0) % 360.0;
		if (delta < 0) delta += 360.0;
		return delta - 180.0;
	}

	// Lerps Euler angles by a given delta
	function interpolateRotation(a, b, t) {
		local x = a.x + getClosesAngle(b.x - a.x) * t;
		local y = a.y + getClosesAngle(b.y - a.y) * t;
		local z = a.z + getClosesAngle(b.z - a.z) * t;
		return Vector(x, y, z);
	}
}

::movement <- CameraMovement();

function io_initMainCamera() {
	movement.initMainCamera();
}

function io_initWaterCamera() {
	movement.initWaterCamera();
}

function io_update() {
	movement.update();

}