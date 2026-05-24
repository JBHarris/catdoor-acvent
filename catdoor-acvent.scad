// Cat-door AC vent adapter
// Toshiba RAC-PD1212CRRU portable AC -> rectangular cat-door opening
// Hose-side: snap-fit receptacle with 3 internal cantilever tabs that engage
// behind the OEM hose-end coupler ring (77 mm OD x 7 mm axial depth).
//
// Geometry summary:
//   - Hose-end coupler ring inserts in -z direction (z+ = collar opening).
//   - Each tab is on a cantilever finger formed by two axial relief slots
//     through the collar wall, flanking the tab circumferentially.
//   - Finger anchored at the deep end; free at the collar tip.
//   - Locking face is at the bottom of the tab (smaller z), faces -z,
//     blocks the ring's rear edge from withdrawing past it.

// ---------- Top-level parameters ----------
// Flange / shell
door_w         = 195;
door_h         = 275;
flange_lip     = 18;
flange_t       = 8;
flange_corner  = 8;
wall           = 3;
gasket_channel = 10;
gasket_depth   = 5;
total_depth    = 190;
collar_len     = 60;

// OEM hose-end coupler ring (PLACEHOLDERS; verify with measurements)
ring_od        = 77;    // OD of the plastic ring at the hose end (mm)
ring_depth     = 7;     // Axial depth of the ring along the hose (mm)
hose_clearance = 1.0;   // Diametric slip-fit clearance for the ring in the collar bore (mm)

// Cantilever snap tabs
tab_count         = 3;     // Number of tabs (120 deg spacing if 3)
tab_inset         = 2.5;   // Radial inward protrusion of tab from collar bore (mm)
tab_width         = 12;    // Circumferential width of tab + finger strip (mm)
tab_ramp_angle    = 30;    // Entry-ramp angle from insertion axis (deg). Lower = easier push.
tab_lock_back_t   = 1.0;   // Axial length of the flat crest at the tab tip (mm)
relief_slot_width = 1.2;   // Width of each axial relief slot (mm)
relief_slot_depth = 18;    // Axial length of relief slot extending behind the tab (mm)

$fn = 96;

// ---------- Derived ----------
eps              = 0.02;
flange_w         = door_w + 2 * flange_lip;
flange_h         = door_h + 2 * flange_lip;
collar_id        = ring_od + hose_clearance;
collar_od        = collar_id + 2 * wall;
trans_z0         = flange_t;
trans_z1         = total_depth - collar_len;
ramp_run         = tab_inset / tan(tab_ramp_angle);
tab_axial_length = tab_lock_back_t + ramp_run;
z_lock           = total_depth - ring_depth - tab_axial_length;
slot_z_root      = z_lock - relief_slot_depth;
tab_arc_deg      = (tab_width / (collar_id / 2)) * 180 / PI;
slot_arc_deg     = (relief_slot_width / (collar_id / 2)) * 180 / PI;

// ---------- 2D helpers ----------
module rounded_rect(w, h, r) {
    offset(r = r) offset(r = -r) square([w, h], center = true);
}

module gasket_channel_2d() {
    difference() {
        square([door_w + flange_lip + gasket_channel,
                door_h + flange_lip + gasket_channel], center = true);
        square([door_w + flange_lip - gasket_channel,
                door_h + flange_lip - gasket_channel], center = true);
    }
}

// ---------- Tab geometry (rotate-extrude cross section) ----------
// Polygon walks CCW in (radial, axial) plane:
//   A: (collar_id/2, z_lock)                                  outer-bottom = wall end of locking face
//   B: (collar_id/2 - tab_inset, z_lock)                      inner-bottom = tab tip / locking face
//   C: (collar_id/2 - tab_inset, z_lock + tab_lock_back_t)    inner-top of flat crest
//   D: (collar_id/2, z_lock + tab_lock_back_t + ramp_run)     outer-top = wall at ramp top
module tab_profile() {
    polygon(points = [
        [collar_id / 2,              z_lock],
        [collar_id / 2 - tab_inset,  z_lock],
        [collar_id / 2 - tab_inset,  z_lock + tab_lock_back_t],
        [collar_id / 2,              z_lock + tab_lock_back_t + ramp_run],
    ]);
}

module tab_at(theta_deg) {
    rotate([0, 0, theta_deg - tab_arc_deg / 2])
        rotate_extrude(angle = tab_arc_deg, $fn = 120)
            tab_profile();
}

// Relief slot cuts through wall from collar bore to collar OD,
// axial range = [slot_z_root, total_depth + eps].
module slot_at(theta_deg) {
    rotate([0, 0, theta_deg - slot_arc_deg / 2])
        rotate_extrude(angle = slot_arc_deg, $fn = 120)
            polygon(points = [
                [collar_id / 2 - eps,  slot_z_root],
                [collar_od / 2 + eps,  slot_z_root],
                [collar_od / 2 + eps,  total_depth + eps],
                [collar_id / 2 - eps,  total_depth + eps],
            ]);
}

// ---------- Body ----------
module body() {
    difference() {
        union() {
            // Flange plate
            linear_extrude(flange_t)
                rounded_rect(flange_w, flange_h, flange_corner);

            // Rect -> circle transition shell (outer)
            hull() {
                translate([0, 0, trans_z0])
                    linear_extrude(eps)
                        square([door_w + 2 * wall, door_h + 2 * wall],
                               center = true);
                translate([0, 0, trans_z1 - eps])
                    linear_extrude(eps)
                        circle(d = collar_od);
            }

            // Collar tube (open cylinder, wall thickness = wall)
            translate([0, 0, trans_z1])
                difference() {
                    cylinder(d = collar_od, h = collar_len);
                    translate([0, 0, -eps])
                        cylinder(d = collar_id, h = collar_len + 2 * eps);
                }

            // Cantilever tabs
            for (i = [0 : tab_count - 1]) {
                tab_at(i * 360 / tab_count);
            }
        }

        // Door opening through flange
        translate([0, 0, -eps])
            linear_extrude(flange_t + 2 * eps)
                square([door_w, door_h], center = true);

        // Transition interior (rect -> circle bore at collar_id)
        hull() {
            translate([0, 0, trans_z0 - eps])
                linear_extrude(eps)
                    square([door_w, door_h], center = true);
            translate([0, 0, trans_z1])
                linear_extrude(eps)
                    circle(d = collar_id);
        }

        // Gasket channel on flange back
        translate([0, 0, -eps])
            linear_extrude(gasket_depth + eps)
                gasket_channel_2d();

        // Relief slots: two per tab, flanking it circumferentially
        for (i = [0 : tab_count - 1]) {
            theta = i * 360 / tab_count;
            slot_at(theta - tab_arc_deg / 2 - slot_arc_deg / 2);
            slot_at(theta + tab_arc_deg / 2 + slot_arc_deg / 2);
        }
    }
}

body();
