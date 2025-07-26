# MVM Ascent

[Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=3532548365)

## Sequence

The gameplay of the map can be changed using the `InitWaveOutput` in the .pop files. The table shows the different relays and their actions.

| Relay                          | Description                                                |
| ------------------------------ | ---------------------------------------------------------- |
| relay_advance_sequence_n       | Advances the sequence by n steps                           |
| relay_advance_sequence_n_abort | Advances the sequence by n steps and aborts it right after |
| relay_abort_sequence           | Aborts the sequence without advancing                      |
| relay_idle_sequence            | Does not alter the sequence.                               |

⚠️ If any `relay_advance_` or `relay_abort_` is used, **all** waves must define a `InitWaveOutput` action. If the sequence should not change use `relay_idle_sequence`. This is required to properly reset the sequence.

As they use the `InitWaveOutput` Trigger, the actions are always executed before the wave. Defining `relay_advance_sequence_1` in the first wave will result in the first step being executed immediately after the map loads. Advancing the sequence triggers the steps one after another. The sequence consists of the following 5 steps.

![](./doc/sequence_progress.gif)

### Step 1

No gameplay changes. The sequence sign changes to `In progress`

### Step 2

No major gameplay changes. Outlet #1 is closed. The sequence signs are update accordingly.

![](./doc/outlet_1.gif)

### Step 3

Outlet #2 is closed, resulting in the channel being drained of water. Bots may chose the now drained channel as a secondary path jumping down from the bridge. The water path has a higher chance to be chosen compared to the regular path. The signs are update accordingly.

![](./doc/outlet_2.gif)
![](./doc/water_1.gif)
![](./doc/water_2.gif)
![](./doc/water_3.gif)

### Step 4

The lake is drained, removing the large death pit. Bots and tanks can chose the water path. The water path has a higher chance to be chosen compared to the regular path. The signs are update accordingly.

![](./doc/lake.gif)

### Step 5

Outlet #3 is closed, removing the death pit entirely. The signs are update accordingly.

![](./doc/outlet_3.gif)

### Aborting

Aborting the sequence stops further steps from executing, effectively locking the current state for the remainder of the game. Aborting also opens the left spawn.

![](./doc/abort_spawn.gif)

## Gatebots

Gatebots can capture a control point near the lift. Once captured, the lift is lowered enabling a shortcut route for bots and tanks. Once a tank uses the lift, the shortcut is closed again and the control point is ready to be captured again.

If the shortcut is enabled, bots and tanks are going to prioritize the shortcut path. If the shortcut is disabled during a wave, the remaining bots will fallback to the path marked with white projectors.

![](./doc/shortcut.gif)

## Demo .pop files

| File               | Description                                                          |
| ------------------ | -------------------------------------------------------------------- |
| gate               | Contains gatebots that enable the shortcut & tanks that use/close it |
| gate_flank         | Same as `gate` but uses the flank spawns                             |
| sequence           | Advances the sequence every wave starting after the first wave       |
| sequence_abort     | Advances the sequence and aborts it after step #3                    |
| sequence_completed | Starts the map with the entire sequence already completed            |

## Screenshots

![](./screenshots/mvm_ascent_position_00.jpg)
![](./screenshots/mvm_ascent_position_01.jpg)
![](./screenshots/mvm_ascent_position_02.jpg)
![](./screenshots/mvm_ascent_position_03.jpg)
![](./screenshots/mvm_ascent_position_04.jpg)
![](./screenshots/mvm_ascent_position_05.jpg)
![](./screenshots/mvm_ascent_position_06.jpg)
![](./screenshots/mvm_ascent_position_07.jpg)
![](./screenshots/mvm_ascent_position_08.jpg)
![](./screenshots/mvm_ascent_position_09.jpg)
![](./screenshots/mvm_ascent_position_10.jpg)
![](./screenshots/mvm_ascent_position_11.jpg)
![](./screenshots/mvm_ascent_position_12.jpg)
![](./screenshots/mvm_ascent_position_13.jpg)
![](./screenshots/mvm_ascent_position_14.jpg)
![](./screenshots/mvm_ascent_position_15.jpg)
![](./screenshots/mvm_ascent_position_16.jpg)
![](./screenshots/mvm_ascent_position_17.jpg)
![](./screenshots/mvm_ascent_position_18.jpg)
![](./screenshots/mvm_ascent_position_19.jpg)
