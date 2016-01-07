/* https://edux.fit.cvut.cz/courses/BI-3DT/classification/semestralka */
/* https://github.com/nesro/nesrotom-3dt-2015 */
/* nesrotom@fit.cvut.cz */
/* v0 3.12.2015 */
/* v1 3.12.2015 */

SHOW_EDUX_DEFAULT_CRYSTAL = 0;
SHOW_EDUX_DEFAULT_RANDOM_CRYSTAL = 0;
PRINT_DEBUG_INFO = 0;

module spike(rotx, roty, rotz, height, circumr, seg) {
    
    if (PRINT_DEBUG_INFO) {
        echo(rotx,roty,rotz,height,circumr,seg);
    }
    
    $fn = seg;

    hi_height = pow(height, 1 / 3);
    lo_height = height - hi_height;     
        
    rotate([rotx, roty, rotz])
    union() {
        cylinder(
            h = lo_height,
            r1 = circumr / 3,
            r2 = circumr,
            center = false);
        
        translate([0, 0, lo_height])
        cylinder(
            h = hi_height,
            r1 = circumr,
            r2 = 0,
            center = false);
        }
}

module crystal(thorns=[]) {
    for (t = thorns) {
        rotx = t[0][0];
        roty = t[0][1];
        rotz = t[0][2];
        height = t[1];
        circumr = t[2];
        seg = t[3];
        
        spike(rotx, roty, rotz, height, circumr, seg);
    }
}

module random_crystal(
        nthorns = 350,
        rot = [-90, 100],
        height = [20, 40],
        circumr = [2, 4.5],
        seg = [3, 10])
{
    for (i = [0 : nthorns]) {
        spike(
            rotx = rands(rot[0], rot[1], 1)[0],
            roty = rands(rot[0], rot[1], 1)[0],
            rotz = rands(rot[0], rot[1], 1)[0],
            height = rands(height[0], height[1], 1)[0],
            circumr = rands(circumr[0], circumr[1], 1)[0],
            seg = round(rands(seg[0] - 0.5, seg[1] + 0.5, 1)[0])
        );
    }
}

if (SHOW_EDUX_DEFAULT_CRYSTAL) {
    crystal([[[0,0,0], 30, 3, 4], [[90,0,0], 25.5, 2.65, 7]]);
}

if (SHOW_EDUX_DEFAULT_RANDOM_CRYSTAL) {
    random_crystal();   
}