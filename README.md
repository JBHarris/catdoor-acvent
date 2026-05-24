# Cat-door AC Vent Adapter

3D-printable adapter that routes a Toshiba **RAC-PD1212CRRU** portable AC
exhaust hose through a rectangular cat-door opening. Hose-side uses a
**cantilever-tab snap-fit** that engages behind the OEM hose-end coupler
ring. Seasonal, removable, gasketed.

## Status

Snap-fit dimensions use placeholder values. The geometry generates and
prints; physical measurements of the OEM hose-end coupler may shift the
numbers slightly. See "Measurements needed" below.

## Dimensions

| Item | Value |
|---|---|
| Cat-door opening | 195 mm W × 275 mm H |
| Hose-end coupler ring OD | 77 mm |
| Hose-end coupler ring axial depth | 7 mm |
| Collar bore (slip-fit on ring) | 78 mm |
| Collar OD (outside) | 84 mm |
| Flange outer | 231 mm × 311 mm, 8 mm corner radius |
| Total depth | 190 mm |
| Wall | 3 mm |
| Flange plate | 8 mm thick |
| Gasket channel (back of flange) | 10 mm × 5 mm |
| Tab count | 3 (120° apart) |
| Tab inward protrusion | 2.5 mm |
| Tab circumferential width | 12 mm |
| Tab ramp angle | 30° from insertion axis (shallow / easy push) |
| Tab flat crest length | 1.0 mm axial |
| Tab locking face axial position | z = 177.67 mm (= total_depth − ring_depth − tab_axial_length) |
| Lock engagement | 2.0 mm radial overlap (ring OR 38.5 vs tab tip 36.5) |
| Relief slot width | 1.2 mm |
| Relief slot depth (behind tab) | 18 mm |
| Cantilever finger length | ~30 mm (anchored at deep end, free at collar tip) |

Hose-body OD (150 mm / 5.9 in) confirmed from sibling-model Toshiba
RAC-PD0812CRRU user manual and OEM hose parts listings — but the snap-fit
engages the smaller **77 mm coupler ring** at the hose end, not the hose
body.

## Files

- `catdoor-acvent.scad` — parametric OpenSCAD source. Top-level vars:
  `door_w`, `door_h`, `flange_lip`, `flange_t`, `flange_corner`, `wall`,
  `gasket_channel`, `gasket_depth`, `total_depth`, `collar_len`,
  `ring_od`, `ring_depth`, `hose_clearance`,
  `tab_count`, `tab_inset`, `tab_width`, `tab_ramp_angle`, `tab_lock_back_t`,
  `relief_slot_width`, `relief_slot_depth`.

STL is not committed. Open the SCAD in the Windows OpenSCAD app and export
STL from there (F6 to render, File → Export → Export as STL).

## Measurements needed (OEM hose-end coupler)

Confirm or correct these on the actual hose:

| Parameter | What to measure | SCAD variable |
|---|---|---|
| Ring OD | Caliper across the plastic ring at the very end of the hose. | `ring_od` |
| Ring axial depth | Length of the ring along the hose axis (the 77 mm-OD section). | `ring_depth` |
| Necked region behind the ring | Confirm that behind the ring, the hose OD drops to something less than the collar bore (78 mm) so the tab can spring inward. | (informational; not a SCAD var) |
| Tab count expected | 3 tabs at 120° is current default. Adjust `tab_count` if the OEM ring uses 2 or 4 catches. | `tab_count` |

The cantilever tabs in the adapter mate against the ring's rear edge; they
don't require any specific feature on the ring beyond a clean 77 mm OD ×
7 mm cylindrical surface with a smaller-OD neck behind it.

## Export the STL

Open `catdoor-acvent.scad` in the OpenSCAD GUI on Windows. `F6` to render,
`File → Export → Export as STL`. Save next to the SCAD as
`catdoor-acvent.stl`.

After verifying measurements on the OEM hose, edit `ring_od`, `ring_depth`,
and any tab parameters in the SCAD and re-export.

## Print settings (Creality K2 Plus, PLA)

| Setting | Value |
|---|---|
| Orientation | Flange-down (flat face on bed). Collar opening points up. |
| Bed footprint | 231 × 311 mm (fits 350 × 350 build plate) |
| Layer height | 0.20 mm (recommended for tab + lock-face detail) |
| Wall loops | 4 |
| Top/bottom layers | 5 |
| Infill | 15% gyroid |
| Supports | None. Outer is convex; inner funnel self-supporting. The 2.5 mm tab locking-face is a short horizontal overhang at z ≈ 178 mm — PLA bridges it without supports. Relief slots are open vertical cuts. |
| Brim | 5 mm single-line. Large flat flange is prone to corner lift on PLA. |
| Bed | 60 °C, glue stick or Magigoo on the flange footprint |
| Nozzle | 215 °C (PLA), 0.4 mm |
| Cooling | Fan 100% from z ≈ 175 mm upward to clean-bridge the lock face. |
| Print time | ~14–18 h |

The cantilever fingers print standing upright (axial direction = print Z).
Each finger is 12 mm wide × 30 mm tall × 3 mm thick. Should flex enough in
PLA to engage the snap-fit (~22 N force at the tab to deflect 2.5 mm,
well below PLA yield stress). If snap is too stiff, edit the SCAD to
thin the wall locally — drop `wall` to 2.0 mm at the tab area or shorten
`tab_inset` to 2.0 mm.

## Assembly

1. Cut 10 mm × 5 mm adhesive-backed foam weatherstrip to fit the gasket
   channel on the flange back. Continuous rectangular loop with rounded
   inside corners; cut four lengths and butt corners, or notch a single
   strip.
2. Peel foam backing and press into the channel.
3. From inside the room, push the flange against the cat-door frame so
   the foam compresses evenly.
4. Push the AC exhaust hose into the collar coupler-end first. The
   ring's outer surface slides up the tab ramps, deflects the cantilever
   fingers outward, then snaps back inward into the recess behind the
   ring once the ring's rear edge clears the tab. Audible click at lock.
5. To remove: squeeze the three tabs inward (or pull firmly if they're
   flexible enough) and slide the hose straight out.

## Tuning

- Snap too stiff (hose won't push past): drop `tab_inset` to 2.0 mm or
  shorten `tab_lock_back_t` to 0.5 mm. Alternatively lengthen
  `relief_slot_depth` to 22 mm for a longer cantilever (lower stiffness).
- Snap too loose (hose backs out under light pull): raise `tab_inset` to
  3.0 mm so the tab overlaps more of the ring's rear edge.
- Tabs miss the ring entirely (snap engages before ring is seated):
  measure ring axial depth precisely and update `ring_depth`. Setback
  derives automatically from `ring_depth + tab_axial_length`.
- Tabs crack on first insertion: relief slots are too short. Raise
  `relief_slot_depth` to 22–25 mm.
- Air leak through relief slots is a concern for tight sealing: stuff
  small foam plugs into each slot after the hose is locked in. Or print
  with the slot exits sealed (would need a SCAD edit; ask if needed).

## Gasket sourcing

10 mm × 5 mm closed-cell EPDM or PVC self-adhesive foam weatherstrip.
Amazon search: "10mm × 5mm self-adhesive foam weather strip". A 5 m roll
covers several adapters with leftovers. Closed-cell handles humidity
better than open-cell.
