/* https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */
/* https://github.com/nesro/nesrotom-3dt-2015 */
/* nesrotom@fit.cvut.cz */

/* comment this out before submission! */
$fn = 20;

/************************************************************/

/* rounded cube - 4 cylinder + hull */
module rc4CH(x,y,z,r) {
    echo("rc4CH x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    //%cube([x+2*r,y+2*r,z], center=true);
    hull() {
        for (i=[-1,1])
            for (j=[-1,1])
                translate([(i*x/2),(j*y/2),0]) 
                    cylinder(r=r, h=z, center=true);
    }
}

/* rounded cube - linear extrude */
module rcLE(x,y,z,r) {
    echo("rcSOE x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    //%cube([x+2*r,y+2*r,z], center=true);
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    offset(r=+r)
    square([x,y],center=true);
}

module rc(x,y,z,r) { 
    if (y == 0) {
        rc4CH(x,y,z,r);
    } else {
        rcLE(x,y,z,r);
    }
}

/************************************************************/

module one_card(x,y,z,t,s,c,d,v,i) {
    c_height = y*(1-v); /* one card height */
    ch_height = c_height + 2*s; /* one card holder height */
    bottom_offset = 0 - (ch_height / 2) - (t / 2);
    
    side_y = z + t + 2 * s;
    
    /* posun podle poradi karty a tak, aby 1 karta zacinala na
       y 0 */
    to_side = (i * (t + s + s + z)) + ((side_y + t)/2);
    to_up = 0 + (i * d);
    translate([0,
        to_side, //y
        (ch_height / 2) + t + s - to_up //z
    ]) {
 
        difference() {
            rc(x, z, ch_height + 2*s, t + s);
            rc(x, z, ch_height + 2*s, s);
        }
        
        color("red")
        translate([0, 0, bottom_offset - s + (to_up / 2)])
            rc(x, z, t - to_up, t + s);
        
        /* postrani kostky, aby hrany nebyli kulaty */
        //side_cube_height =
        delta_side = -(i * d);
        
        if (i < c - 1) {
        color("green")
        for (mp = [-1, 1]) /* mp = minus 1, plus 1 */
            //translate([i * (x/2 - y/2), 0, -(z / 2) + (y / 2)])
            translate([
                    mp * ((x/2) + s + t/2), //x
                    side_y/2,//-(z/2 + s + t)/2 , //y
                    -t/2 -(delta_side / 2) ])
                cube([
                    t,
                    side_y, //2*(z/2 + s) + 1,
                    ch_height + 2*s + t + delta_side
                ], center=true);
        }
    }
}

module draw_cardholder(x,y,z,t,s,c,d,v) {
    
    if (d >= 0) {
        translate([0,
            -(((c * (t + s + z + s)) + t) / 2)
        ,0])
        for (i=[1:c]) {
            one_card(x,y,z,t,s,c,d,v, i - 1);
        }
    } else {
        translate([0,
            -(((c * (t + s + z + s)) + t) / 2)
        ,0])
        for (i=[1:c]) {
            one_card(x,y,z,t,s,c,d,v, i - 1);
        }
    }   
}

/************************************************************/


module cardholder(
    size=[85, 54, 1],
    thickness=3,
    spacing=1,
    cards=4,
    delta=25,
    visibility=0.3)
{
    draw = (len(size) < 2 || size[0] <= 0 ||
            size[1] <= 0 || cards <= 0) ? false : true;
    visibility = (visibility < 0) ? 0 : (1 < visibility) ? 1 : visibility;
    thickness = (thickness < 0) ? 0 : thickness;
    spacing = (spacing < 0) ? 0 : spacing;
    size = len(size) == 2 ? concat(size, 0) : size;
    
    echo("draw",draw,"visibility",visibility,"thickness",thickness,
        "spacing",spacing,"size",size);
    
    /* i need shortcuts because i have a small screen */
    x = size[0];
    y = size[1];
    z = size[2];   
    s = spacing;
    t = thickness;
    c = cards;
    d = -delta;
    v = visibility;
    
    if (draw) {
        draw_cardholder(x,y,z,t,s,c,d,v);
    }
}

/************************************************************/
/* TESTS ****************************************************/
/************************************************************/

test_no = 1;

if (test_no == 1) {
    cardholder();
    echo("TEST #1: edux default <<<<<");
}

if (test_no == 2) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #2: edux default copied <<<<<");
}

if (test_no == 3) {
    cardholder(size=[90, 70, 4], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #3: edux slightly different size <<<<<");
}

if (test_no == 300) {
    cardholder(size=[900, 700, 40], thickness=30, spacing=10, cards=4, delta=2500, visibility=0.3);
    echo("TEST #3: edux slightly different size <<<<<");
}


if (test_no == 4) {
    cardholder(size=[90, 70, 4], thickness=5, spacing=3, cards=6, delta=10, visibility=0.5);
    echo("TEST #4: edux slightly different size and rest <<<<<");
}

if (test_no == 5) {
    cardholder(size=[666], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #5: vector has only 1 item <<<<<");
    echo("TEST #5: NOTHIG SHALL BE GENERATED! <<<<<");
}

if (test_no == 6) {
    cardholder(size=[85, 54], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #6: vector has only 2 item <<<<<");
}

if (test_no == 7) {
    cardholder(size=[0, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #7: size[0] == 0 <<<<<");
    echo("TEST #7: NOTHIG SHALL BE GENERATED! <<<<<");
}

if (test_no == 8) {
    cardholder(size=[85, 0, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #8: size[1] == 0 <<<<<");
    echo("TEST #8: NOTHIG SHALL BE GENERATED! <<<<<");
}

if (test_no == 9) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=0, delta=25, visibility=0.3);
    echo("TEST #9: cards == 0 <<<<<");
    echo("TEST #9: NOTHIG SHALL BE GENERATED! <<<<<");
}

if (test_no == 10) {
    cardholder(size=[85, 54, 10], thickness=30, spacing=-3, cards=1, delta=25, visibility=0.3);
    echo("TEST #10: spacing < 0 <<<<<");
}

if (test_no == 11) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=0, visibility=0.3);
    echo("TEST #11: delta == 0 <<<<<");
}

if (test_no == 12) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=-25, visibility=0.3);
    echo("TEST #12: delta = -delta <<<<<");
}

if (test_no == 13) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=-2);
    echo("TEST #13: visibility = -2 <<<<<");
}

if (test_no == 14) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=2);
    echo("TEST #14: visibility = 2 <<<<<");
}

if (test_no == 15) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=1, delta=25, visibility=0.3);
    echo("TEST #15: only 1 card <<<<<");
}

if (test_no == 16) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=10, delta=25, visibility=0.3);
    echo("TEST #16: 10 cards <<<<<");
}

if (test_no == 17) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=50, delta=25, visibility=0.3);
    echo("TEST #17: 50 cards <<<<<");
}

if (test_no == 18) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=2, delta=25, visibility=0.3);
    echo("TEST #18: 2 cards <<<<<");
}

    
    
    