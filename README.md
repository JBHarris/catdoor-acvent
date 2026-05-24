# Cat-door AC Vent Adapter

3D-printable adapter that routes a Toshiba **RAC-PD1212CRRU** portable AC
exhaust hose through a rectangular cat-door opening. Hose-side uses a
**snap-fit receptacle** (no twist, just push). Seasonal, removable, gasketed.

## Status

**Snap-lip dimensions are placeholders.** The geometry is generated and prints,
but the lip is sized for a generic 5.9" portable-AC hose tab. Measure the OEM
hose before final printing (see "Measurements needed" below) and update
`lip_height`, `lip_setback`, and `lip_flat_len` in the SCAD.

## Dimensions

| Item | Value |
|---|---|
| Cat-door opening | 195 mm W × 275 mm H |
| Hose OD (body) | 150 mm (5.9 in) |
| Collar bore (slip-fit on hose body) | 151 mm |
| Flange outer | 231 mm × 311 mm, 8 mm corner radius |
| Total depth | 190 mm |
| Wall | 3 mm |
| Flange plate | 8 mm thick |
| Gasket channel (back of flange) | 10 mm × 5 mm |
| Snap lip protrusion (placeholder) | 2.5 mm radial inward |
| Snap lip back-face axial position | 30 mm in from collar tip |
| Lip ramp angle | 30° from insertion axis (shallow / easy push) |
| Lip style | Continuous annular (default). Switch to 3 catches via `lip_segments = 3`. |

Hose OD verified against the Toshiba RAC-PD0812CRRU user manual (same hose
family as RAC-PD1212CRRU per OEM parts listings on Walmart / Amazon /
parts-distribution.com).

## Files

- `catdoor-acvent.scad` — parametric OpenSCAD source. Top-level vars:
  `hose_od`, `hose_clearance`, `door_w`, `door_h`, `gasket_channel`,
  `gasket_depth`, `wall`, `flange_lip`, `flange_t`, `collar_len`, `total_depth`,
  `flange_corner`, `lip_height`, `lip_setback`, `lip_flat_len`,
  `lip_ramp_angle`, `lip_segments`, `lip_segment_arc`, `lip_clearance`.

STL is not committed. Open the SCAD in the Windows OpenSCAD app and export
STL from there (`File > Export > Export as STL` after `F6` to render).

## Measurements needed (OEM hose)

Hose-side coupling end has 3 compliant tabs. To finalize the snap-fit lip:

| Parameter | What to measure | SCAD variable |
|---|---|---|
| Tab radial protrusion | Caliper across hose OD at tab vs hose OD away from tabs. Half the difference = protrusion. | `lip_height` |
| Tab axial position | Distance from hose end face to the back edge of the tab (the edge that locks against the lip). | `lip_setback` |
| Tab axial footprint | Length of the tab along the hose axis. | `lip_flat_len` (use tab length or a hair less) |
| Hose body OD at tab area | Caliper across hose OD just behind the tabs. | `hose_od` |
| Tab count and spacing | 3 tabs at 120°, or other? | `lip_segments` (0 = continuous, leave for any count) |

Continuous annular lip works regardless of tab count or rotational alignment, so
keep `lip_segments = 0` unless there is a reason to break it into discrete
catches.

## Export the STL

Open `catdoor-acvent.scad` in the OpenSCAD GUI on Windows. Press `F6` to
render, then `File > Export > Export as STL`. Save next to the SCAD as
`catdoor-acvent.stl`.

After measuring the OEM hose tabs, edit `lip_height`, `lip_setback`, and
`lip_flat_len` in the SCAD and re-export.

## Print settings (Creality K2 Plus, PLA)

| Setting | Value |
|---|---|
| Orientation | Flange-down (flat face on bed). Collar opening points up. |
| Bed footprint | 231 × 311 mm (fits 350 × 350 build plate) |
| Layer height | 0.20 mm (recommended for the lip detail) |
| Wall loops | 4 |
| Top/bottom layers | 5 |
| Infill | 15 % gyroid |
| Supports | None. Outer is convex; inner funnel narrows upward so all overhangs are self-supporting (~63° from horizontal at worst axis). The snap lip is a ~2.5 mm internal bridge across the bore at z ≈ 160 mm — PLA bridges this without supports. |
| Brim | 5 mm single-line. Big flat flange is prone to corner lift on PLA. |
| Bed | 60 °C, glue stick or Magigoo on the flange footprint |
| Nozzle | 215 °C (PLA), 0.4 mm |
| Cooling | Fan 100 % through the lip layers (z ≈ 158–162) for clean bridging |
| Print time | ~14–18 h |

If slicer warns on the lip overhang, ignore it. Bridge length is well under
PLA's clean-bridge limit. The lip's back face (the locking surface) is
horizontal and will print as a short bridge layer; ramp face above is
self-supporting.

## Assembly

1. Cut 10 mm × 5 mm adhesive-backed foam weatherstrip to fit the gasket
   channel on the flange back. Continuous rectangular loop with rounded
   inside corners; cut four lengths and butt corners, or notch a single
   strip.
2. Peel foam backing and press into the channel.
3. From inside the room, push flange against the cat-door frame so foam
   compresses evenly.
4. Push the AC exhaust hose into the collar coupling-end first. Tabs ride
   up the lip's entry ramp, deflect inward, then snap back behind the lip.
   Audible click on engagement.
5. To remove: squeeze the tabs inward (or pull firmly if tabs are
   flexible enough) and slide the hose out.

## Tuning

- Lip too tight (hose won't push past): lower `lip_height` by 0.5 mm or
  raise `lip_clearance` to 0.8.
- Lip too loose (hose backs out): raise `lip_height` by 0.5 mm.
- Tabs miss the lip entirely (snap engages too early or too late): adjust
  `lip_setback` to match tab axial position. Measure once with the hose
  inserted and the gap between flange face and hose end where it bottoms
  out.
- If 0.20 mm layer doesn't give a clean back-face on the lip, print the
  collar end down (flip orientation) and use a bit of support inside the
  bore. Reverts the flange to free-hanging — needs a tree-support tower
  under the flange edges.

## Gasket sourcing

10 mm × 5 mm closed-cell EPDM or PVC self-adhesive foam weatherstrip. Amazon
search: "10mm × 5mm self-adhesive foam weather strip". A 5 m roll covers
several adapters with leftovers. Closed-cell handles humidity better than
open-cell.
