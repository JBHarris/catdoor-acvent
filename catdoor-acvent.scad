// Cat-door AC vent adapter
// Toshiba RAC-PD1212CRRU portable AC -> rectangular cat-door opening
// Hose-side: snap-fit receptacle (no rotation). OEM hose tabs deflect inward
// past an internal lip, then spring back to lock behind it.
//
// Hose OD reference: 150 mm (5.9 in), confirmed from Toshiba RAC-PD0812CRRU
// user manual (same hose family as RAC-PD1212CRRU per OEM parts listings).
//
// NOTE: Snap-lip dimensions (lip_height, lip_setback, lip_flat_len) are
// PLACEHOLDERS pending physical measurement of the OEM hose tabs. See README.

// ---------- Top-level parameters ----------
hose_od        = 150;   // Hose OD at the tab location (mm)
hose_clearance = 1.0;   // Diametric slip-fit clearance for hose body (mm)
door_w         = 195;
door_h         = 275;
gasket_channel = 10;
gasket_depth   = 5;
wall           = 3;
flange_lip     = 18;
flange_t       = 8;
collar_len     = 60;
total_depth    = 190;
flange_corner  = 8;

// ---- Snap-fit lip ----
lip_height      = 2.5;  // Radial inward protrusion of lip (mm). Match OEM tab protrusion.
lip_setback     = 30;   // Axial distance from collar tip to BACK face of lip (mm).
                        //   = axial position of tabs on the OEM hose, measured from hose end.
lip_flat_len    = 1.5;  // Axial length of the lip's flat crest (mm).
lip_ramp_angle  = 30;   // Entry-ramp angle from insertion axis (degrees). 30 = shallow / easy push.
lip_segments    = 0;    // 0 = continuous annular lip; 3 = three discrete 120 deg catches.
lip_segment_arc = 35;   // Arc width (deg) of each catch when lip_segments > 0.
lip_clearance   = 0.4;  // Diametric clearance between OEM tab OD and lip ID (mm).

$fn = 96;

// ---------- Derived ----------
eps        = 0.02;
flange_w   = door_w + 2 * flange_lip;
flange_h   = door_h + 2 * flange_lip;
collar_id  = hose_od + hose_clearance;
collar_od  = collar_id + 2 * wall;
trans_z0   = flange_t;
trans_z1   = total_depth - collar_len;
lip_z      = total_depth - lip_setback;
ramp_run   = lip_height / tan(lip_ramp_angle);

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

// ---------- Collar (rotate-extrude cross section) ----------
module collar_profile_with_lip() {
    polygon(points = [
        [collar_od / 2, trans_z1],
        [collar_od / 2, total_depth],
        [collar_id / 2, total_depth],
        [collar_id / 2,                  lip_z + lip_flat_len + ramp_run],
        [collar_id / 2 - lip_height,     lip_z + lip_flat_len],
        [collar_id / 2 - lip_height,     lip_z],
        [collar_id / 2,                  lip_z],
        [collar_id / 2, trans_z1],
    ]);
}

module collar_profile_no_lip() {
    polygon(points = [
        [collar_od / 2, trans_z1],
        [collar_od / 2, total_depth],
        [collar_id / 2, total_depth],
        [collar_id / 2, trans_z1],
    ]);
}

module lip_segment_profile() {
    polygon(points = [
        [collar_id / 2 - lip_height, lip_z + lip_flat_len],
        [collar_id / 2 - lip_height, lip_z],
        [collar_id / 2,              lip_z],
        [collar_id / 2,              lip_z + lip_flat_len + ramp_run],
    ]);
}

module collar_continuous() {
    rotate_extrude($fn = 120) collar_profile_with_lip();
}

module collar_segmented() {
    rotate_extrude($fn = 120) collar_profile_no_lip();
    for (i = [0 : lip_segments - 1]) {
        rotate([0, 0, i * 360 / lip_segments - lip_segment_arc / 2])
            rotate_extrude(angle = lip_segment_arc, $fn = 120)
                lip_segment_profile();
    }
}

module collar_assembly() {
    if (lip_segments == 0) collar_continuous();
    else                   collar_segmented();
}

// ---------- Body ----------
module body() {
    difference() {
        union() {
            linear_extrude(flange_t)
                rounded_rect(flange_w, flange_h, flange_corner);

            hull() {
                translate([0, 0, trans_z0])
                    linear_extrude(eps)
                        square([door_w + 2 * wall, door_h + 2 * wall],
                               center = true);
                translate([0, 0, trans_z1 - eps])
                    linear_extrude(eps)
                        circle(d = collar_od);
            }

            collar_assembly();
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
    }
}

body();
