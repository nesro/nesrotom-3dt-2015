/* https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */
/* https://github.com/nesro/nesrotom-3dt-2015 */
/* nesrotom@fit.cvut.cz */

/************************************************************/
/* GLOBAL VARIABLES *****************************************/
/************************************************************/

/* comment this out before submission! */
$fn = 20;

/* turn on non-rounded cubed in rcXXX */
debug = 0;

/************************************************************/
/* ROUNDED CUBES ********************************************/
/************************************************************/

/* rounded cube - 4 cylinder + hull */
/* FIXME: this is called only when y == 0
   so it can be optimized */
module rc4CH(x,y,z,r) {
    echo("rc4CH x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    if (debug) { %cube([x+2*r,y+2*r,z], center=true); }
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
    if (debug) { %cube([x+2*r,y+2*r,z], center=true); }
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    offset(r=+r)
    square([x,y],center=true);
}

/* rounded cube - 2 circles + hull + linear extrude */
module rc2CHLE(x, y, z, r) {
    
}

module rc(x,y,z,r) { 
    if (y == 0) {
        rc4CH(x,y,z,r);
    } else {
        rcLE(x,y,z,r);
    }
}

/************************************************************/
/* CARDHOLDER ***********************************************/
/************************************************************/

module one_card(x,y,z,t,s,c,d,v,i) {
    /* card height */
    c_height = y*(1-v);
    
    /* card holder height */
    ch_height = c_height + (2 * s);
    
    /* this is where the bottom starts */
    bottom_offset = 0 - (ch_height / 2) - (t / 2);
    
    /* ... */
    side_y = z + t + 2 * s;
    
    /* posun podle poradi karty a tak, aby 1 karta zacinala na
       y 0 */
    to_side = (i * (t + s + s + z)) + ((side_y + t)/2);
    
    /* posun o delta */
    to_up = i * d;
    
    to_z = (ch_height / 2) + t + s;
    
    translate([0,
        to_side, //y
        to_z + to_up //z
    ]) {
 
        difference() {
            color("white")
            rc(x, z, ch_height + (2 * s), t + s);
            
            color("black")
            rc(x, z, ch_height + (2 * s), s);
        }
        
        color("red")
        translate([0, 0, bottom_offset - s - (to_up / 2)])
            rc(x, z, t + to_up, t + s);
        
        /* draw the sides. not if this is the last card */
        if (i < c - 1) {
            color("green")
            for (mp = [-1, 1]) /* mp = minus 1, plus 1 */
                translate([
                        mp * ((x / 2) + s + (t / 2)), //x
                        side_y / 2, //y
                        0 - (t / 2) - (to_up / 2) //z
                ])
                    cube([
                        t,
                        side_y,
                        ch_height + 2*s + t + to_up
                    ], center=true);
        }
    }
}

module draw_cardholder(x,y,z,t,s,c,d,v) {
    /* |t|s|z|s|T|
       T is the t shared by the next cardholder
       so we're not mulitiplying this t by c
       but we add it only once for the last card */
    translate([0,
        -(((c * (t + s + z + s)) + t) / 2)
    ,0])
        /* the for cycle needs to be 1:c for the case
           when c is one. then we want to draw only
           one card. but we pass i - 1 to the
           one_card function because we want to compute
           the offset which starts with 0, not 1 */  
        for (i=[1:c]) {
            one_card(x,y,z,t,s,c,d,v, i - 1);
        }

}

/* if the delta is negative, make it positive and rotate
   the cardholder */
module draw_cardholder_deltacheck(x,y,z,t,s,c,d,v) {
    if (d >= 0) {
        draw_cardholder(x,y,z,t,s,c,d,v);
    } else {
        rotate([0, 0, 180])
            draw_cardholder(x,y,z,t,s,c,d,v);
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
    draw = (len(size) < 2 ||
           size[0] <= 0 ||
           size[1] <= 0 ||
           cards <= 0) ?
               false :
               true;
    
    visibility = visibility < 0 ?
                     0 :
                     visibility > 1 ?
                         1 :
                         visibility;
    
    thickness = thickness < 0 ?
                    0 :
                    thickness;
    
    spacing = spacing < 0 ?
                  0 :
                  spacing;
    
    size = len(size) == 2 ?
           concat(size, 0) :
           size;
    
    echo("draw",draw,"visibility",visibility,"thickness",thickness,
        "spacing",spacing,"size",size);
    
    /* i need shortcuts because i have a small screen */
    x = size[0];
    y = size[1];
    z = size[2];   
    s = spacing;
    t = thickness;
    c = cards;
    d = delta;
    v = visibility;
    
    if (draw) {       
        draw_cardholder_deltacheck(x,y,z,t,s,c,d,v);
    }
}

/************************************************************/
/* TESTS ****************************************************/
/************************************************************/

test_no = 1;

if (test_no == 666) {
    cardholder(size=[85, 64, 0], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #666: z = 0 <<<<<");
}

if (test_no == 665) {
    cardholder(size=[85, 1, 54], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #665: y = 1 <<<<<");
}

if (test_no == 667) {
    cardholder(size=[1, 85, 54], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #667: x = 1 <<<<<");
}


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
