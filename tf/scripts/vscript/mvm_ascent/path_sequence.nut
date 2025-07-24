// script_reload_code mvm_ascent/path_sequence
// ent_fire script_test callScriptFunction RootTestFunction

class DamSequence {
	// Step indices
	static STEP_NONE = 0
	static STEP_OUTLET_A = 1
	static STEP_OUTLET_B = 2
	static STEP_DRAIN_LAKE = 3
	static STEP_OUTLET_C = 4

	// Execution types
	static TYPE_REGULAR = "regular";
	static TYPE_INSTANT = "instant";
	static TYPE_ABORT = "abort";

	// Path types
	static PATH_MAIN = "main"
	static PATH_WATER = "water"
	static PATH_WATER_BRIDGE = "water_bridge" // Water path but the lake is not drained
	static PATH_SHORTCUT_MAIN = "shortcut_main"
	static PATH_SHORTCUT_WATER = "shortcut_water" // The tank may not be able to use the water path, as the lake does not need to be drained for this path type

	// Path chances
	static CHANCE_PATH_WATER = 70

	// Instance members
	maxSequenceSteps = 5;
	currentSequenceStep = -1;
	abortedSequenceStep = -1;

	advancedThisWave = 0;
	abortedThisWave = false;

	blueWonThisWave = false
	redWonThisWave = false

	isShortcutActive = false;
	wasShortcutActiveAtWaveStart = false;
	currentPath = "main";

	function resetSequence() {
		// Successful tests
		// - Red win does not reset
		// - Blue win properly resets
		// - Vote to change / restart properly resets

		printl("----- Resetting sequence info")
		this.maxSequenceSteps = 4
		this.currentSequenceStep = -1
		this.abortedSequenceStep = -1

		this.advancedThisWave = 0;
		this.abortedThisWave = false;

		this.blueWonThisWave = false
		this.redWonThisWave = false;
	}

	function resetShortcut() {
		printl("----- Resetting shortcut info")
		this.isShortcutActive = false
		this.wasShortcutActiveAtWaveStart = false;
	}

	function printSequence() {
		printl("----- Sequence info -----")
		printl("Current: " + this.currentSequenceStep)
		printl("Aborted: " + this.abortedSequenceStep)
		printl("----- ------------- -----")
	}

	function printPaths() {
		printl("----- Allowed paths -----")
		printl("Main.           " + true)
		printl("Water Bridge:   " + this.isWaterBridgePathOpen())
		printl("Water:          " + this.isWaterPathOpen())
		printl("Shortcut:       " + this.isShortcutActive)
		printl("----- ------------- -----")
	}

	function triggerRelay(relay) {
		printl("Relay: " + relay)
		EntFire(relay, "Trigger", null, 0, null)
	}

	/**
	 * Is called on first map load, vote to restart/change mission & when bots win the round.
	 * Called before the initWave & advance/abort functions are triggered
	 */
	function onFirstMapSpawn() {
		printl("----- OnMapSpawn -----")
		printl("Red Won:  " + this.redWonThisWave)
		printl("Blue Won: " + this.blueWonThisWave)
		printl("----- ---------- -----")

		local anyTeamWon = this.redWonThisWave || this.blueWonThisWave

		// If the map has been loaded due to a vote or the initial load, reset all variables
		if (anyTeamWon == false) {
			this.resetSequence()
			this.resetShortcut()
		}
	}

	/**
	 * This is invoked every time a wave is initialized. Includes after win, after loose, after vote, after map load, ...
	 */
	function initWave() {
		local anyTeamWon = this.redWonThisWave || this.blueWonThisWave

		printl("----- InitWave -----")
		printl("Red Won:  " + this.redWonThisWave)
		printl("Blue Won: " + this.blueWonThisWave)
		printl("Shortcut (current):  " + this.isShortcutActive)
		printl("Shortcut (previous): " + this.wasShortcutActiveAtWaveStart)
		printl("----- -------- -----")

		// Ensure that the map objects have the correct state
		this.printSequence()
		this.performExecutions();

		// Set the shortcut state appropriately
		local didShortcutChange = this.wasShortcutActiveAtWaveStart != this.isShortcutActive
		if (this.redWonThisWave == false && didShortcutChange == true) {
			if (this.wasShortcutActiveAtWaveStart) {
				this.startEnablingShortcut();
				this.enableShortcut();
			} else {
				this.startDisablingShortcut();
			}
		}

		this.wasShortcutActiveAtWaveStart = this.isShortcutActive;

		// Reset wave won flags
		this.blueWonThisWave = false;
		this.redWonThisWave = false;
	}

	function finishWave() {
		this.redWonThisWave = true;
		this.advancedThisWave = 0;
		this.abortedThisWave = false;
	}

	function looseWave() {
		this.blueWonThisWave = true;

		// Reduce the current step by one if the sequence has advanced at the start of this wave
		// ! The InitWaveOutput is called again after loosing. This prevents duplicate progress
		if (this.advancedThisWave != 0) {
			this.currentSequenceStep = this.currentSequenceStep - this.advancedThisWave;
		}
	}

	// TODO: Flank spawns testen

	function abortSequence() {
		if (this.abortedSequenceStep != -1) {
			return;
		}

		printl("----- Aborting sequence after step " + this.currentSequenceStep)
		this.abortedThisWave = true;
		this.abortedSequenceStep = this.currentSequenceStep + 1;
	}

	function advanceSequence(advanceBy) {
		if (this.abortedSequenceStep != -1) {
			return;
		}

		printl("----- Advancing sequence by " + advanceBy)
		this.advancedThisWave = advanceBy;
		this.currentSequenceStep = this.currentSequenceStep + this.advancedThisWave;
	}

	function performExecutions() {
		local executions = this.getExecutions();

		printl("----- Step Executions -----")

		for (local i = 0; i < executions.len(); i++) {
			local element = executions[i];
			local relayName = "relay_dam_sequence_" + element.type + "_" + element.step
			this.triggerRelay(relayName)
		}

		// Determine the current state of the sequence
		local sequenceDone = this.currentSequenceStep >= this.maxSequenceSteps;
		local sequenceInProgress = executions.len() != 0;
		local hasAborted = this.abortedSequenceStep != -1;
		local currentRelayName = "relay_dam_sequence_current_"

		if (sequenceInProgress == false) {
			currentRelayName = currentRelayName + "inactive"
		} else if (sequenceDone) {
			currentRelayName = currentRelayName + "finished"
		} else if (hasAborted) {
			currentRelayName = currentRelayName + "aborted"
		} else {
			currentRelayName = currentRelayName + "active"
		}

		this.triggerRelay(currentRelayName)

		if (hasAborted == true) {
			this.triggerRelay("relay_dam_sequence_has_aborted")
		}

		printl("----- --------------- -----")
	}

	function getExecutions() {
		local result = []

		// Return the "instant" execution for all previous steps
		for (local step = 0; step <= this.currentSequenceStep - this.advancedThisWave; step++) {
			result.append({
				"type": this.TYPE_INSTANT,
				"step": step,
			})
		}

		// Use "regular" for the steps started this wave
		for (local i = 0; i < this.advancedThisWave; i++) {
			result.append({
				"type": this.TYPE_REGULAR,
				"step": this.currentSequenceStep + i - this.advancedThisWave + 1,
			})
		}

		// Return the "aborted" for every step after the abortion happened
		if (this.abortedSequenceStep != -1) {
			for (local step = this.abortedSequenceStep; step <= this.maxSequenceSteps; step++) {
				result.append({
					"type": this.TYPE_ABORT,
					"step": step,
				})
			}
		}

		return result;
	}

	// ----- ----- ----- ----- -----
	// Path logic
	// ----- ----- ----- ----- -----

	// TODO: Test (Funktioniert das Revergatebot mehrmals in einer Welle?)

	/**
	 * Called once the bots capture the point.
	 * Starts the move linear, but does not enable the bot stun / crits
	 */
	function startEnablingShortcut() {
		printl("----- Start enabling the shortcut -----")
		this.triggerRelay("relay_start_enabling_shortcut");
		printl("----- ----------- -----")
	}

	/**
	 * Called once the move linear has reached the lower position.
	 */
	function enableShortcut() {
		this.isShortcutActive = true;

		printl("----- Enabled the shortcut -----")
		this.triggerRelay("relay_enable_shortcut");
		printl("----- ----------- -----")
	}

	/**
	 * Called once the move linear start going to the upper position.
	 * Disables the shortcut path for the tank & bots
	 */
	function startDisablingShortcut() {
		this.isShortcutActive = false;

		printl("----- Start disabling the shortcut -----")
		this.triggerRelay("relay_start_disabling_shortcut");
		printl("----- ----------- -----")
	}

	/**
	 * Called once the move linear has reached the top.
	 * Reenables the gate bot logic
	 */
	function disableShortcut() {
		printl("----- Disabled the shortcut -----")
		this.triggerRelay("relay_disable_shortcut");
		printl("----- ----------- -----")
	}

	function updateStartBranch() {
		// Default = main, Alternate = water
		local pathEntity = "path_start_branch";
		local useMain = true;

		switch (this.currentPath) {
			case this.PATH_MAIN:
			case this.PATH_SHORTCUT_MAIN:
			case this.PATH_WATER_BRIDGE:
				useMain = true
				break;

			case this.PATH_WATER:
				useMain = false
				break;

			case this.PATH_SHORTCUT_WATER:
				useMain = this.isShortcutActive || this.isWaterPathOpen() == false
				break;
		}

		// Overwrite the decision if the shortcut is currently open
		// ! This allows tanks to use the shortcut in the same round as the shortcut has been unlocked
		if (this.isShortcutActive == true) {
			useMain = true;
		}

		printl("----- Setting start branch path -----")
		printl("Bots: " + this.currentPath)
		printl("Tank: " + (useMain ? "main" : "water"))
		printl("----- ------------------------- -----")

		local event = useMain ? "DisableAlternatePath" : "EnableAlternatePath";
		EntFire(pathEntity, event, null, 0, null)
	}

	function updateShortcutBranch() {
		// Default = main, Alternate = shortcut
		local pathEntity = "path_shortcut_branch";
		local useShortcut = this.isShortcutActive;

		printl("----- Setting shortcut branch path -----")
		printl("Bots: " + this.currentPath)
		printl("Tank: " + (useShortcut ? "shortcut" : "main"))
		printl("----- ---------------------------- -----")

		local event = useShortcut ? "EnableAlternatePath" : "DisableAlternatePath";
		EntFire(pathEntity, event, null, 0, null)
	}

	function chooseRandomPath() {
		printl("----- Choosing bot path")
		this.printPaths();

		local allowWater = this.isWaterPathOpen();
		local allowWaterBridge = this.isWaterBridgePathOpen();
		local random = this.getRandomFloat(101);

		local path = this.getRandomPath();
		this.currentPath = path;
		printl("----- Chosen path -----")
		printl("Path:" + path)

		this.triggerRelay("relay_enable_path_" + path);

		printl("----- ----------- -----")
	}

	function getRandomPath() {
		local allowWater = this.isWaterPathOpen();
		local allowWaterBridge = this.isWaterBridgePathOpen();
		local random = this.getRandomFloat(101);
		local useWater = random < this.CHANCE_PATH_WATER;

		// If the shortcut is open, determine a shortcut path
		if (this.isShortcutActive == true) {
			if (useWater == false || (allowWater == false && allowWaterBridge == false)) {
				return this.PATH_SHORTCUT_MAIN;
			}

			// At this point, the useWater is true, and one of the paths is open
			return this.PATH_SHORTCUT_WATER;
		}

		// The shortcut is not open. Return the main path if water is closed or random decided main path
		if (useWater == false || (allowWater == false && allowWaterBridge == false)) {
			return this.PATH_MAIN;
		}

		// If the main water path is open, return it. Otherwise use the water bridge path
		return allowWater ? this.PATH_WATER : this.PATH_WATER_BRIDGE
	}

	function isWaterBridgePathOpen() {
		return this.currentSequenceStep >= this.STEP_OUTLET_B;
	}

	function isWaterPathOpen() {
		return this.currentSequenceStep >= this.STEP_DRAIN_LAKE;
	}

	/**
	 * Generate a pseudo-random float between 0 and max - 1, inclusive.
	 * Source: https://developer.electricimp.com/examples/random
	 */
	function getRandomFloat(max) {
		return 1.0 * max * rand() / RAND_MAX;
	}
}

// Only update the instance if it is not already set
// ! The catch clause is executed on the initial load of the map, as sequence is not defined yet
try {
	printl(sequence + ": Instance before update");
} catch (error) {
	::sequence <- DamSequence();
}

// ----- ----- ----- ----- -----
// I/O Debug
// ----- ----- ----- ----- -----

function io_printSequence() {
	sequence.printSequence();
}

// ----- ----- ----- ----- -----
// I/O InitWaveOutput (All relays must call io_initWave)
// ----- ----- ----- ----- -----

function io_onFirstMapSpawn() {
	sequence.onFirstMapSpawn();
}

function io_initWave() {
	sequence.initWave();
}

function io_abortSequence() {
	sequence.abortSequence();
}

// --- Advance the sequence

function io_advanceSequence_1() {
	sequence.advanceSequence(1);
}

function io_advanceSequence_2() {
	sequence.advanceSequence(2);
}

function io_advanceSequence_3() {
	sequence.advanceSequence(3);
}

function io_advanceSequence_4() {
	sequence.advanceSequence(4);
}

function io_advanceSequence_5() {
	sequence.advanceSequence(5);
}

// --- Advance and abort in the same round

function io_advanceSequence_1_abort() {
	sequence.advanceSequence(1);
	sequence.abortSequence()
}

function io_advanceSequence_2_abort() {
	sequence.advanceSequence(2);
	sequence.abortSequence()
}

function io_advanceSequence_3_abort() {
	sequence.advanceSequence(3);
	sequence.abortSequence()
}

function io_advanceSequence_4_abort() {
	sequence.advanceSequence(4);
	sequence.abortSequence()
}

function io_advanceSequence_5_abort() {
	sequence.advanceSequence(5);
	sequence.abortSequence()
}

// ----- ----- ----- ----- -----
// I/O Tank
// ----- ----- ----- ----- -----

function io_updateStartBranch() {
	sequence.updateStartBranch()
}

function io_updateShortcutBranch() {
	sequence.updateShortcutBranch()
}

// ----- ----- ----- ----- -----
// I/O Shortcut
// ----- ----- ----- ----- -----

function io_startEnablingShortcut() {
	sequence.startEnablingShortcut();
}

function io_enableShortcut() {
	sequence.enableShortcut();
}

function io_startDisablingShortcut() {
	sequence.startDisablingShortcut();
}

function io_disableShortcut() {
	sequence.disableShortcut();
}

// ----- ----- ----- ----- -----
// I/O Waves
// ----- ----- ----- ----- -----


function io_finishWave() {
	sequence.finishWave();
}

function io_looseWave() {
	sequence.looseWave()
}

/**
 * Should be called with a delay to ensure this is called after the InitWaveOutput.
 * ! This is not in the InitWaveOutput function to allow pop files that don' use this output to still work
 */
function io_chooseRandomPath() {
	sequence.chooseRandomPath();
}