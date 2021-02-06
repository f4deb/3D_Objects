/* [Bolt holes in the corners] */

// Pick the size of the long threaded rods that run through
// the corners and hold everything together.
//
// These are the sizes that are commonly available at
// Home Depot or Lowes:
//
// 1/4 inch: 3.175
// #12     : 2.778125
// #10     : 2.38125 (default and recommended)
//
// Note: you should pick the same size and fudge factor
// for the ear parts.
bolt_size = 2.38125;

// Make the bolt holes this much bigger than the size of the bolt
// to give a more comfortable fit
bolt_hole_fudge = 0.2; // [0:0.25:1]


/* [Notches and tabs for stacking] */

// You can optionally omit the notches for the frame on the end
// that joins with an ear with no tabs. For all of the others
// you should leave this at its default of true.
notches_enabled = true;

// Make the slot this much taller than the tabs
// to give a more comfortable fit.
notch_fudge = 0.3; // [0:0.25:1]


/* [Size] */

// This design will fit 13 units with PoE hats in a standard rack.
// If you are not using PoE hats you can change this to 14 and fit
// and extra Pi in the rack (each frame will be a little shorter).
// You can also bump this down to 12 for a more relaxed fit.
// This would make sense if your switch can only power 12 units, or
// if you are planning to use 2 racks to fit 24 units and use a
// 24-port switch.
number_to_fit = 13; // [12:Relaxed fit, 13:Using PoE, 14:Without PoE hats]

/* [Hidden] */
// make the screw holes this much bigger than the
// actual screw for a more comfortable fit
// (a bigger number here will make the screws fit looser)
screw_hole_fudge = 0.15;

height = (450.85 - 20) / number_to_fit;

width = 82;
length = 90;

// The height of the notches and tabs
notch_height = 2;

// epsilon is used to slightly overlap pieces to help the previewer
epsilon = 0.001;

bolt_radius = bolt_size + bolt_hole_fudge;

outer_wall_thickness = 12;
inner_wall_thickness = 7;
back_wall_thickness = 5;
wall_diff = outer_wall_thickness - inner_wall_thickness;
floor_depth = 3;
tray_depth = 5;
tray_slot_depth = 2.5;
spacer_depth = 3;

sd_window_width = 40;
sd_window_height = height - (tray_depth + floor_depth)*2;
near_pillar_width = 15;
far_pillar_width = 10;
floor_window_width = sd_window_width;
floor_window_border = (width - floor_window_width - outer_wall_thickness*2) / 2;
floor_window_length = length - back_wall_thickness - floor_window_border*2;
port_window_width = length - near_pillar_width - far_pillar_width;
port_window_frame_height = floor_depth + tray_depth + spacer_depth - notch_height;

difference() {
    union() {
        // the main block
        cube([width, length, height]);
        
        // the tabs
        translate([ wall_diff,
                    near_pillar_width + wall_diff,
                    height - epsilon]) {
            cube([  inner_wall_thickness - 2,
                    length - near_pillar_width - far_pillar_width - wall_diff*2,
                    notch_height + epsilon]);
        }
        translate([ width - outer_wall_thickness + 2,
                    near_pillar_width + wall_diff,
                    height - epsilon]) {
            cube([  inner_wall_thickness - 2,
                    length - near_pillar_width - far_pillar_width - wall_diff*2,
                    notch_height + epsilon]);
        }
    }

    // carve out the interior
    translate([outer_wall_thickness, -epsilon, floor_depth]) {
        cube(  [width - outer_wall_thickness*2,
                length - back_wall_thickness + epsilon,
                height + notch_height - floor_depth + epsilon]);
    }

    // punch a hole for the sd card
    translate([ (width - sd_window_width) / 2,
                length - back_wall_thickness - epsilon,
                tray_depth + floor_depth]) {
        cube([  sd_window_width,
                back_wall_thickness + 2*epsilon,
                height - port_window_frame_height - tray_depth - floor_depth + notch_height]);
    }

    // punch a hole for side port access
    translate([ -epsilon,
                near_pillar_width,
                port_window_frame_height + notch_height]) {
        cube([  width + 2*epsilon,
                port_window_width,
                height - port_window_frame_height*2]);
    }

    // punch a hole in the bottom
    translate([ outer_wall_thickness + floor_window_border,
                floor_window_border,
                -epsilon]) {
        cube([  floor_window_width,
                floor_window_length,
                floor_depth + 2*epsilon]);
    }
    
    // open a groove that the speaker jack can slide through
    translate([ outer_wall_thickness - 2,
                -epsilon,
                port_window_frame_height + notch_height]) {
        cube([  2 + epsilon,
                near_pillar_width + 2*epsilon,
                8]);
    }
    
    // soften the leading edge a bit
    translate([ outer_wall_thickness,
                0,
                floor_depth-0.5]) {
        rotate([25,0,0]) {
            cube([  width - outer_wall_thickness*2,
                    2,
                    2]);
        }
    }

    if (notches_enabled) {
        // cut the notches in the bottom
        translate([ -epsilon,
                    near_pillar_width + wall_diff,
                    -epsilon]) {
            cube([  outer_wall_thickness - 2 + epsilon,
                    length - near_pillar_width - far_pillar_width - wall_diff*2,
                    notch_height + notch_fudge + epsilon]);
        }
        translate([ width - outer_wall_thickness + 2,
                    near_pillar_width + wall_diff,
                    -epsilon]) {
            cube([  outer_wall_thickness - 2 + epsilon,
                    length - near_pillar_width - far_pillar_width - wall_diff*2,
                    notch_height + notch_fudge + epsilon]);
        }
    }

    // cut out the sides to make them thinner
    polyhedron(
        points = [
            [ wall_diff, length-far_pillar_width-wall_diff, height+notch_height+epsilon],
            [ wall_diff, near_pillar_width+wall_diff,       height+notch_height+epsilon],
            [ wall_diff, length-far_pillar_width-wall_diff, -epsilon],
            [ wall_diff, near_pillar_width+wall_diff,       -epsilon],
            [-wall_diff, length-far_pillar_width+wall_diff, height+notch_height+epsilon],
            [-wall_diff, near_pillar_width-wall_diff,       height+notch_height+epsilon],
            [-wall_diff, length-far_pillar_width+wall_diff, -epsilon],
            [-wall_diff, near_pillar_width-wall_diff,       -epsilon]
        ],
        faces = [
            [1,0,2,3],
            [4,5,7,6],
            [0,4,6,2],
            [6,7,3,2],
            [7,5,1,3],
            [5,4,0,1]
        ],
        convexity = 10);
    polyhedron(
        points = [
            [width-wall_diff, near_pillar_width+wall_diff,       height+notch_height+epsilon],
            [width-wall_diff, length-far_pillar_width-wall_diff, height+notch_height+epsilon],
            [width-wall_diff, near_pillar_width+wall_diff,       -epsilon],
            [width-wall_diff, length-far_pillar_width-wall_diff, -epsilon],
            [width+wall_diff, near_pillar_width-wall_diff,       height+notch_height+epsilon],
            [width+wall_diff, length-far_pillar_width+wall_diff, height+notch_height+epsilon],
            [width+wall_diff, near_pillar_width-wall_diff,       -epsilon],
            [width+wall_diff, length-far_pillar_width+wall_diff, -epsilon]
        ],
        faces = [
            [1,0,2,3],
            [4,5,7,6],
            [0,4,6,2],
            [6,7,3,2],
            [7,5,1,3],
            [5,4,0,1]
        ],
        convexity = 10);

    // drill the bolt holes
    for (a=[[outer_wall_thickness/2, near_pillar_width/2],
            [outer_wall_thickness/2, length - far_pillar_width/2],
            [width - outer_wall_thickness/2, near_pillar_width/2],
            [width - outer_wall_thickness/2, length - far_pillar_width/2]]) {
        translate([a[0], a[1], -epsilon]) {
            cylinder(   h=height + notch_height + 2*epsilon,
                        r=bolt_radius,
                        center=false,
                        $fn=360);
        }
    }

    // cut the tray insert slots
    // note: the tray will be slightly narrower to
    // give a more comfortable fit. If it is too loose or too tight,
    // adjust the tray.
    for (a=[    outer_wall_thickness,
                width - outer_wall_thickness]) {
        translate([ a,
                    -epsilon,
                    floor_depth + tray_depth/2]) {
            intersection() {
                rotate([0, 45, 0]) {
                    translate([-tray_depth/sqrt(2)/2, 0, -tray_depth/sqrt(2)/2]) {
                        cube([  tray_depth/sqrt(2),
                                length - back_wall_thickness + epsilon,
                                tray_depth/sqrt(2)]);
                    }
                }
                translate([-tray_depth/2+0.5, 0, -tray_depth/2]) {
                    cube([  tray_depth-1,
                            length - back_wall_thickness + epsilon,
                            tray_depth]);
                }
            }
        }
    }
}