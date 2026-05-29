# Window AC Vent Adapter

3D-printable adapter that routes a Toshiba **RAC-PD1212CRRU** portable AC
exhaust hose through the OEM window slider panel. Mates the hose's coupler
ring on one end and snaps into the window slider port on the other.

## Geometry

- **Hose end:** circular collar with internal cantilever tabs that grip
  the OEM hose-end coupler. Identical mechanism to the prior revision.
- **Window end:** stadium (racetrack) plug that passes through the OEM
  window slider port, retained by two compliant cantilever snap tabs on
  the short (curved) ends. Tabs hook the far side of the slider plate.

## Dimensions

| Item | Value |
|---|---|
| Window slider port (racetrack) | 100 mm × 190 mm |
| Window slider plate thickness | 4 mm |
| Plug body | 99.4 × 189.4 mm (port − 0.6 mm slip-fit), 22 mm long |
| Wall (plug + collar) | 3 mm |
| Flange (room-side) | 124 × 214 mm, 4 mm thick, 14 mm corner radius |
| Plug snap tab inward protrusion | 2.0 mm |
| Plug snap tab angular width | 100° per tab (1 tab per short end) |
| Plug tab ramp angle | 30° from insertion axis |
| Plug tab lock overlap past port | 0.5 mm |
| Hose collar bore | 156 mm (ring_od 155 + 1 mm slip-fit) |
| Hose collar length | 30 mm |
| Hose-grip tab count | 7, spaced 360°/7 |
| Total adapter depth | ~120 mm (4 flange + 60 transition + 30 collar + 22 plug + 4 tab projection ≈) |

The 100 × 190 mm port and 4 mm plate are confirmed from the OEM window
slider. `ring_od = 155` is carried forward from the prior design and should
be re-verified against the actual OEM hose-end with calipers.

## Files

- `window-acvent-adapter.scad` — parametric OpenSCAD source.

STL is not committed. Open the SCAD in the Windows OpenSCAD app and export
STL (F6 to render, File → Export → Export as STL).

## Key parameters

Window port (OEM measurements):

- `port_w`, `port_h` — racetrack short and long dimensions.
- `port_thickness` — slider plate thickness around the port.
- `port_slip` — diametric slip-fit clearance for the plug in the port.

Flange (room-side plate):

- `flange_overhang` — how far the flange extends past the port edge.
- `flange_t`, `flange_corner` — flange thickness and outer corner radius.
- `gasket_channel`, `gasket_depth` — set both > 0 to mill a foam-strip
  channel into the back face of the flange.

Plug body and snap tabs:

- `plug_depth` — axial length of plug body beyond the flange face. Sets
  the cantilever finger length, so it also sets the snap-tab compliance
  (longer = softer).
- `wall` — plug and collar wall thickness. Snap force scales as `wall³`.
- `plug_tab_inset` — radial protrusion of the tab past the plug OD; equals
  the maximum cantilever deflection during insertion.
- `plug_tab_arc_deg` — angular width of each tab on the short-end
  semicircle. 100° covers most of the curved end.
- `plug_tab_ramp_angle` — entry ramp angle. Lower angle = easier push.
- `plug_tab_lock_back_t` — flat-crest axial length at the tab tip.
- `plug_tab_overlap` — how far past `port_thickness` the locking face
  sits. The locking face engages the far-side surface of the slider plate.
- `plug_relief_slot_arc_deg` — angular width of each relief slot. Two
  slots flank each tab.

Hose-end coupler (preserved from prior design):

- `ring_od`, `ring_depth`, `hose_clearance`, `collar_len` — bore and
  length of the hose collar.
- `htab_*`, `hrelief_slot_*` — internal cantilever tabs gripping the
  hose-end. Same semantics as the prior revision.

## Installation

1. (Optional) If you set `gasket_channel > 0`, cut a foam weatherstrip to
   fit the channel on the back face of the flange and press it in.
2. With the OEM window slider already installed in the window, push the
   plug end of the adapter through the slider port from the room side.
   The two short-end ramps hit the port edges first, the cantilever
   fingers flex inward, and the tabs snap outward behind the far face of
   the slider plate. Audible click at lock.
3. Push the AC exhaust hose into the round collar coupler-end first.
   The hose-end coupler ring slides up the internal tab ramps, deflects
   the cantilever fingers outward, and snaps inward into the recess
   behind the ring.
4. To remove the adapter from the window slider, squeeze the two short-end
   tabs inward (or pull firmly if the latch is set soft enough) and slide
   the adapter out toward the room.

## Tuning

Plug-side snap (window slider port):

- Too stiff (won't push through the port): drop `plug_tab_inset` to 1.5 mm,
  drop `wall` to 2.5 mm, or lower `plug_tab_ramp_angle` to 20°.
- Too loose (rattles or backs out): raise `plug_tab_inset` to 2.5 mm or
  raise `plug_tab_overlap` to 1.0 mm.
- Tabs crack on insertion: relief slots are too short. Raise `plug_depth`
  to 28 mm (longer finger = lower stress).

Hose-side snap (collar gripper):

- Same tuning model as the prior revision: adjust `htab_inset`, `htab_count`,
  and `hrelief_slot_depth` to trade hold strength for insertion force.

## Print settings (Creality K2 Plus, PLA)

| Setting | Value |
|---|---|
| Orientation | Plug-up. Flange flat on bed (room-side face down). |
| Bed footprint | 124 × 214 mm |
| Layer height | 0.20 mm |
| Wall loops | 4 |
| Top/bottom layers | 5 |
| Infill | 15% gyroid |
| Supports | None. Collar bore self-supporting at the transition; tab crests are short overhangs that PLA bridges without supports. |
| Brim | 5 mm single-line on the flange perimeter |
| Bed | 60 °C, glue stick or Magigoo on the flange footprint |
| Nozzle | 215 °C (PLA), 0.4 mm |
| Cooling | Fan 100% from the tab z-range upward, to clean-bridge lock faces. |
