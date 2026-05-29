// Window-fixture AC vent adapter
// Toshiba RAC-PD1212CRRU portable AC -> OEM window slider port
//
// Hose-side (preserved): round collar with internal cantilever tabs that
// grip the OEM hose-end coupler ring.
// Window-side (new): stadium (racetrack) plug that passes through the OEM
// window slider port (~100 x 190 mm), retained by compliant cantilever snap
// tabs on the two short (curved) ends, hooking the far side of the 4 mm
// slider plate.
//
// Coordinate convention:
//   z = 0          back face of flange (the face that rests against the
//                  slider plate, room-side surface of the plate)
//   z > 0          plug body passing through the port (outside direction)
//   z < 0          flange thickness, transition shell, and hose collar
//
// Insertion direction: push plug into the port in the +z direction. Tabs
// ramp inward, then snap outward behind the slider plate's far face.

// ---------- Window slider port (OEM measurements) ----------
port_w         = 100;    // short dimension of the racetrack hole (mm)
port_h         = 190;    // long dimension of the racetrack hole (mm)
port_thickness = 4;      // slider plate thickness around the port (mm)
port_slip      = 0.6;    // slip-fit clearance: plug OD = port - port_slip

// ---------- Outer flange (rests against the room side of the plate) ----------
flange_overhang = 12;    // flange extends this far past the port edge (mm)
flange_t        = 4;     // flange axial thickness (mm)
flange_corner   = 14;    // outer corner radius of the flange (mm)
gasket_channel  = 0;     // gasket channel width (back of flange); 0 = none
gasket_depth    = 0;     // gasket channel depth

// ---------- Plug body (stadium prism through the port) ----------
// Plug extends past the port for cantilever compliance: finger length =
// plug_depth, anchored at the flange face (z=0), free at the plug tip.
plug_depth      = 22;    // axial length of plug beyond flange face (mm)
wall            = 3;     // plug & collar wall thickness (mm)

// ---------- Snap tabs on plug short (curved) ends ----------
plug_tab_inset           = 2.0;   // outward protrusion past plug OD (mm)
plug_tab_arc_deg         = 100;   // angular width of each tab (deg)
plug_tab_ramp_angle      = 30;    // entry ramp angle (deg from axis)
plug_tab_lock_back_t     = 1.0;   // flat crest length, axial (mm)
plug_tab_overlap         = 0.5;   // how far past port_thickness the lock
                                  // face sits (mm; engages the far face)
plug_relief_slot_arc_deg = 6;     // angular slot width (deg)

// ---------- Hose-end coupler (preserved) ----------
ring_od        = 155;    // OD of OEM hose-end (mm); verify with caliper
ring_depth     = 0;      // axial depth of the ring along the hose (mm)
hose_clearance = 1.0;    // diametric slip-fit clearance in the collar bore
collar_len     = 30;     // hose collar axial length (mm)

htab_count        = 7;
htab_inset        = 2.0;
htab_width        = 12;
htab_ramp_angle   = 30;
htab_lock_back_t  = 1.0;
hrelief_slot_w    = 1.2;
hrelief_slot_depth = 10;

// ---------- Geometry derived ----------
$fn = 96;
eps = 0.02;

// Outer flange outline
flange_w = port_w + 2 * flange_overhang;
flange_h = port_h + 2 * flange_overhang;

// Stadium dimensions (the racetrack 2D outline parameters)
//   "stadium(w, h)" = rectangle of (h - w) length capped by two semicircles
//   of radius w/2. Requires h >= w. Both outer plug and inner flange opening
//   use stadium shapes scaled appropriately.
plug_outer_w = port_w - port_slip;
plug_outer_h = port_h - port_slip;
plug_outer_r = plug_outer_w / 2;
plug_inner_w = plug_outer_w - 2 * wall;
plug_inner_h = plug_outer_h - 2 * wall;
plug_inner_r = plug_inner_w / 2;

// Stadium semicircle centers along y-axis (long dimension)
stadium_y_off_outer = (plug_outer_h - plug_outer_w) / 2;
stadium_y_off_inner = (plug_inner_h - plug_inner_w) / 2;

// Hose collar
collar_id = ring_od + hose_clearance;
collar_od = collar_id + 2 * wall;

// z layout (see header)
//   z = -(flange_t + trans_h + collar_len)  bottom of collar (hose enters)
//   z = -(flange_t + trans_h)               top of collar / bottom of trans
//   z = -flange_t                           bottom of flange (transition top)
//   z = 0                                   back of flange (slider plate)
//   z = plug_depth                          plug tip (outside of plate)
trans_h     = 60;
z_collar_lo = -(flange_t + trans_h + collar_len);
z_collar_hi = -(flange_t + trans_h);
z_trans_lo  = z_collar_hi;
z_trans_hi  = -flange_t;
z_flange_lo = -flange_t;
z_flange_hi = 0;
z_plug_lo   = 0;
z_plug_hi   = plug_depth;

// Plug snap tab geometry derived
plug_ramp_run    = plug_tab_inset / tan(plug_tab_ramp_angle);
plug_z_lock      = port_thickness + plug_tab_overlap;
plug_tab_axial   = plug_tab_lock_back_t + plug_ramp_run;
// Slot spans the full plug body (open at tip, anchored at flange face).
// Finger length = plug_depth.
plug_slot_z_root = -eps;

// Internal hose-grip tab geometry. Hose enters in +z direction from
// z=z_collar_lo (collar opening). After insertion the hose tip sits above
// the locking face. Locking face faces +z (blocks the tip from moving back
// down to -z = the collar opening).
htab_ramp_run    = htab_inset / tan(htab_ramp_angle);
htab_axial       = htab_lock_back_t + htab_ramp_run;
htab_base_z      = z_collar_lo + ring_depth;            // base of ramp (outer wall)
htab_lock_z      = htab_base_z + htab_axial;            // top of locking face
htab_slot_top_z  = htab_lock_z + hrelief_slot_depth;    // top (anchor) of slot
htab_arc_deg     = (htab_width / (collar_id / 2)) * 180 / PI;
hslot_arc_deg    = (hrelief_slot_w / (collar_id / 2)) * 180 / PI;

// ---------- 2D helpers ----------
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r) square([w, h], center = true);
}

module stadium_2d(w, h) {
    // axis along y; semicircles capped at top and bottom
    hull() {
        translate([0,  (h - w) / 2, 0]) circle(d = w);
        translate([0, -(h - w) / 2, 0]) circle(d = w);
    }
}

// ---------- Plug snap-tab geometry ----------
// Tab cross section in (r, z) at one of the semicircle centers. The plug's
// outer wall at the semicircle is at r = plug_outer_r. The tab protrudes
// radially outward (positive r) and locks at z = plug_z_lock.
// Polygon walks CCW:
//   A (plug_outer_r,                  plug_z_lock)
//   B (plug_outer_r + plug_tab_inset, plug_z_lock)
//   C (plug_outer_r + plug_tab_inset, plug_z_lock + plug_tab_lock_back_t)
//   D (plug_outer_r,                  plug_z_lock + plug_tab_axial)
module plug_tab_profile() {
    polygon(points = [
        [plug_outer_r,                  plug_z_lock],
        [plug_outer_r + plug_tab_inset, plug_z_lock],
        [plug_outer_r + plug_tab_inset, plug_z_lock + plug_tab_lock_back_t],
        [plug_outer_r,                  plug_z_lock + plug_tab_axial],
    ]);
}

// side_sign: +1 for the +y semicircle, -1 for the -y semicircle
module plug_tab(side_sign) {
    translate([0, side_sign * stadium_y_off_outer, 0])
        rotate([0, 0, (side_sign > 0 ? 90 : 270) - plug_tab_arc_deg / 2])
            rotate_extrude(angle = plug_tab_arc_deg, $fn = 120)
                plug_tab_profile();
}

// Relief slot cross section: cuts through the plug wall from inner to
// outer (+ tab protrusion) over z = [plug_slot_z_root, z_plug_hi + eps].
module plug_slot_profile() {
    polygon(points = [
        [plug_inner_r - eps,                  plug_slot_z_root],
        [plug_outer_r + plug_tab_inset + eps, plug_slot_z_root],
        [plug_outer_r + plug_tab_inset + eps, z_plug_hi + eps],
        [plug_inner_r - eps,                  z_plug_hi + eps],
    ]);
}

// theta_offset: degrees from the +x axis at the semicircle's local frame,
// where 90 = pointing along +y. Used to flank a tab with two slots.
module plug_slot(side_sign, theta_offset) {
    translate([0, side_sign * stadium_y_off_outer, 0])
        rotate([0, 0, theta_offset - plug_relief_slot_arc_deg / 2])
            rotate_extrude(angle = plug_relief_slot_arc_deg, $fn = 60)
                plug_slot_profile();
}

// ---------- Hose-collar tab geometry (preserved) ----------
// Tab protrudes inward (smaller r) from the collar bore wall. Cantilever
// finger is anchored at htab_slot_top_z and free at the collar opening
// (z = z_collar_lo). Ramp on the -z side (hose-entry side); locking face
// on the +z side (deeper into collar), facing +z.
//   A (outer_r, htab_base_z)                                 base of ramp
//   B (outer_r, htab_lock_z)                                 outer-top of lock
//   C (inner_r, htab_lock_z)                                 tab tip, top of lock
//   D (inner_r, htab_lock_z - htab_lock_back_t)              end of flat crest
//   D->A = ramp (slopes from inner_r at z_D down-right to outer_r at base)
module htab_profile() {
    polygon(points = [
        [collar_id / 2,              htab_base_z],
        [collar_id / 2,              htab_lock_z],
        [collar_id / 2 - htab_inset, htab_lock_z],
        [collar_id / 2 - htab_inset, htab_lock_z - htab_lock_back_t],
    ]);
}

module htab_at(theta_deg) {
    rotate([0, 0, theta_deg - htab_arc_deg / 2])
        rotate_extrude(angle = htab_arc_deg, $fn = 120)
            htab_profile();
}

// Relief slots flank the tab and run from the collar opening upward
// (open at z = z_collar_lo, anchored at htab_slot_top_z).
module hslot_at(theta_deg) {
    rotate([0, 0, theta_deg - hslot_arc_deg / 2])
        rotate_extrude(angle = hslot_arc_deg, $fn = 120)
            polygon(points = [
                [collar_id / 2 - eps, z_collar_lo - eps],
                [collar_od / 2 + eps, z_collar_lo - eps],
                [collar_od / 2 + eps, htab_slot_top_z],
                [collar_id / 2 - eps, htab_slot_top_z],
            ]);
}

// ---------- Body ----------
module body() {
    difference() {
        union() {
            // Flange plate (rounded rectangle, room-side)
            translate([0, 0, z_flange_lo])
                linear_extrude(flange_t)
                    rounded_rect(flange_w, flange_h, flange_corner);

            // Plug body (stadium prism, projects outward into the port)
            translate([0, 0, z_plug_lo])
                linear_extrude(plug_depth)
                    stadium_2d(plug_outer_w, plug_outer_h);

            // Transition shell (outer hull from stadium back to circle)
            hull() {
                translate([0, 0, z_trans_hi - eps])
                    linear_extrude(eps)
                        stadium_2d(plug_outer_w, plug_outer_h);
                translate([0, 0, z_trans_lo + eps])
                    linear_extrude(eps)
                        circle(d = collar_od);
            }

            // Hose collar tube (open cylinder)
            translate([0, 0, z_collar_lo])
                cylinder(d = collar_od, h = collar_len);

            // Plug snap tabs on the two short (curved) ends
            plug_tab(+1);
            plug_tab(-1);

            // Internal hose-grip cantilever tabs around the collar bore
            for (i = [0 : htab_count - 1])
                htab_at(i * 360 / htab_count);
        }

        // Through-bore in flange & plug: stadium hole
        translate([0, 0, z_flange_lo - eps])
            linear_extrude(flange_t + plug_depth + 2 * eps)
                stadium_2d(plug_inner_w, plug_inner_h);

        // Transition interior (stadium inner -> circle inner)
        hull() {
            translate([0, 0, z_trans_hi + eps])
                linear_extrude(eps)
                    stadium_2d(plug_inner_w, plug_inner_h);
            translate([0, 0, z_trans_lo - eps])
                linear_extrude(eps)
                    circle(d = collar_id);
        }

        // Hose collar bore
        translate([0, 0, z_collar_lo - eps])
            cylinder(d = collar_id, h = collar_len + 2 * eps);

        // Gasket channel on back of flange (optional)
        if (gasket_channel > 0 && gasket_depth > 0) {
            translate([0, 0, z_flange_lo - eps])
                linear_extrude(gasket_depth + eps)
                    difference() {
                        rounded_rect(port_w + 2 * (flange_overhang - 2),
                                     port_h + 2 * (flange_overhang - 2),
                                     flange_corner);
                        rounded_rect(port_w + 2 * (flange_overhang - 2 - gasket_channel),
                                     port_h + 2 * (flange_overhang - 2 - gasket_channel),
                                     max(flange_corner - gasket_channel, 1));
                    }
        }

        // Plug relief slots: two per tab, flanking it. theta is local angle
        // about the semicircle center; 90 = pointing along +y.
        // Top semicircle (+y): tab centered at 90; slots flank at +-half-arc.
        plug_slot(+1,  90 - plug_tab_arc_deg / 2 - plug_relief_slot_arc_deg / 2);
        plug_slot(+1,  90 + plug_tab_arc_deg / 2 + plug_relief_slot_arc_deg / 2);
        // Bottom semicircle (-y): tab centered at 270 in its local frame.
        plug_slot(-1, 270 - plug_tab_arc_deg / 2 - plug_relief_slot_arc_deg / 2);
        plug_slot(-1, 270 + plug_tab_arc_deg / 2 + plug_relief_slot_arc_deg / 2);

        // Hose-collar relief slots: two per htab, flanking each
        for (i = [0 : htab_count - 1]) {
            theta = i * 360 / htab_count;
            hslot_at(theta - htab_arc_deg / 2 - hslot_arc_deg / 2);
            hslot_at(theta + htab_arc_deg / 2 + hslot_arc_deg / 2);
        }
    }
}

body();
