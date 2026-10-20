# Effect Reference

## 1. File format

One injector per one config. It is either `Zomboid/Lua/Injectors/<id>.ini` or the shipped default in `server/Injectors/Defaults/<id>.lua`.

```ini
[Effects.<EffectName>_<N>]
duration = 100
delay = 0
rate = 10
amount = 0.05
```

| Rule | Detail |
|---|---|
| Section name | `Effects.<EffectName>_<N>`. The suffix `_<N>` is how you add several copies of the same effect to one injector (`_1`, `_2`, ...). The handler is looked up by the leading letters only, so effect names contain no digits. |
| Keys | letters, digits, underscore. `key = value`. |
| Values | numbers (`0.05`, `-3`), `true`/`false`, or comma lists. All effect parameters are plain numbers. |
| Comments | lines starting with `#` or `;` (inside `.ini` files and inside the Lua default string). |
| Unknown keys | ignored. |
| Required keys | every key in the effect's parameter list below. A missing `duration` silently disables the effect; a missing `delay`, `rate`, `amount` or `base` causes a Lua error when the effect ticks. |
| Constructor default | "Add Effect" creates every key with value `0`, and `duration = 0` is ignored, so a fresh effect does nothing until you set `duration`. |

## 2. Timing parameters

Units are engine ticks: one `OnTick` event each. In single player a tick follows the frame rate; on a server it follows the server tick, so durations are not exact.

| Key | Type | Allowed | Meaning |
|---|---|---|---|
| `duration` | number | `> 0` (0 or less = effect ignored) | Ticks the effect stays active after the delay. |
| `delay` | number | `>= 0` | Ticks to wait before the first activation. |
| `rate` | number | `>= 1` (lower values are raised to 1) | Activate every `rate` ticks. |

Activations per use: `ceil(duration / rate)`. Total change for a stat effect: `amount * ceil(duration / rate)`, before clamping. Example: `duration = 100`, `rate = 10`, `amount = 0.02` gives 10 activations, +0.2 in total.

Effects of one injector are independent, so you can stack them: `ChangePainEffect_1` for a quick relief and `ChangePainEffect_2` with a later `delay` for a rebound.

## 3. Effects

| Effect | Target | Parameters | What each activation does |
|---|---|---|---|
| `ChangeHungerEffect` | HUNGER stat | `amount` | Adds `amount`, clamped. UI range 0 to 1. Higher = hungrier, negative feeds. |
| `ChangeThirstEffect` | THIRST stat | `amount` | Adds `amount`, clamped. UI range 0 to 1. Higher = thirstier. |
| `ChangeEnduranceEffect` | ENDURANCE stat | `amount` | Adds `amount`, clamped. UI range 0 to 1. Higher = more endurance. |
| `ChangeTemperatureEffect` | TEMPERATURE stat | `amount` | Adds `amount`, clamped. UI range 20 to 40. |
| `ChangeIntoxicationEffect` | INTOXICATION stat | `amount` | Adds `amount`, clamped. UI range 0 to 100. |
| `ChangeZombieInfectionEffect` | ZOMBIE_INFECTION stat | `amount` | Adds `amount`, clamped. UI range 0 to 100. |
| `ChangeFoodSicknessEffect` | FOOD_SICKNESS stat | `amount` | Adds `amount`, clamped. UI range 0 to 100. |
| `ChangePainEffect` | PAIN stat | `base`, `minRange`, `maxRange`, `minScale`, `maxScale` | `delta = base * scale(current pain)`; adds `delta`, clamped. UI pain range 0 to 100. |
| `ChangeGeneralHealthEffect` | overall body health | `base`, `minRange`, `maxRange`, `minScale`, `maxScale` | `delta = base * scale(current body health)`. `delta > 0` heals, `delta < 0` damages. UI range 0 to 100. |
| `ChangeOverdoseEffect` | mod's overdose counter | `base` | Adds `base`, clamped to `0 .. OVERDOSE_THRESHOLD + 10`. Death is handled by the overdose tick. |
| `ChangeCarryWeightEffect` | max carry weight | `amount` | While the effect is active the player's max carry weight is changed by `amount` percent of base capacity. Several active carry effects add up. Re-applied after relog. |
| `MendBleedingEffect` | bleeding on each body part | `base` + 17 body-part coefficients | Per part: `delta = base * coefficient`. `delta > 0` shortens bleeding time. `delta < 0` starts bleeding if needed and adds `abs(delta)` bleeding time. |
| `MendDeepWoundEffect` | deep wounds on each body part | `base` + 17 body-part coefficients | Per part: `delta = base * coefficient`. `delta < 0` creates a deep wound if none. On a deep-wounded part, wound time is reduced by `delta`. |

### 3.1 Scaling parameters

`scale(x)` is a clamped linear interpolation of the current stat value `x`:

| Condition | Result |
|---|---|
| `x <= minRange` | `minScale` |
| `x >= maxRange` | `maxScale` |
| otherwise | `minScale + (x - minRange) / (maxRange - minRange) * (maxScale - minScale)` |

| Key | Meaning |
|---|---|
| `minRange`, `maxRange` | Stat values where scaling starts and ends. Keep `minRange <= maxRange`. |
| `minScale`, `maxScale` | Multiplier at the low and high end. |

For a constant, unscaled effect, set `minScale = 1` and `maxScale = 1`, the range values then do not matter. To make an effect stronger when the stat is low, use a larger `minScale` than `maxScale`.

### 3.2 Body-part keys

Each is a number multiplied by `base`.

| Group | Keys |
|---|---|
| Head and neck | `Head`, `Neck` |
| Torso | `Torso_Upper`, `Torso_Lower`, `Groin` |
| Arms | `UpperArm_L`, `UpperArm_R`, `ForeArm_L`, `ForeArm_R`, `Hand_L`, `Hand_R` |
| Legs | `UpperLeg_L`, `UpperLeg_R`, `LowerLeg_L`, `LowerLeg_R`, `Foot_L`, `Foot_R` |

## 4. Example templates

Stat effects:

```ini
[Effects.ChangeHungerEffect_1]
duration = 100
delay = 0
rate = 10
amount = -0.02
```

Pain and general health:

```ini
[Effects.ChangeGeneralHealthEffect_1]
duration = 60
delay = 1
rate = 1
base = 0.5
minRange = 0
maxRange = 100
minScale = 1
maxScale = 1
```

Overdose:

```ini
[Effects.ChangeOverdoseEffect_1]
duration = 1
delay = 0
rate = 1
base = 10
```

Bleeding and deep wounds on all parts:

```ini
[Effects.MendBleedingEffect_1]
duration = 120
delay = 0
rate = 10
base = 1
Head = 1
Neck = 1
Torso_Upper = 1
Torso_Lower = 1
UpperArm_L = 1
UpperArm_R = 1
ForeArm_L = 1
ForeArm_R = 1
Hand_L = 1
Hand_R = 1
Groin = 1
UpperLeg_L = 1
UpperLeg_R = 1
LowerLeg_L = 1
LowerLeg_R = 1
Foot_L = 1
Foot_R = 1
```