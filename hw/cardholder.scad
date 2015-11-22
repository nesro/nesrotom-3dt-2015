/* https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */
/* https://github.com/nesro/nesrotom-3dt-2015 */
/* nesrotom@fit.cvut.cz */

/************************************************************/
/* GLOBAL VARIABLES + DEBUGGING *****************************/
/************************************************************/

/* comment this out before submission! */
// $fn = 42;

/* turn on non-rounded cubed in rcXXX */
debug = 0;

/* show the card. (this will draw the cardholder with % - so use F5 only! ) */
debug_show_card = 0;

/************************************************************/
/* ROUNDED CUBES ********************************************/
/************************************************************/

/* rounded cube - linear extrude - 4 rounded corners */
module r4cLE(x,y,z,r, dozadu) {
    echo("rcSOE x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    if (debug) { %cube([x+2*r,y+2*r,z], center=true); }
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    offset(r=+r)
    square([x,y],center=true);
}

/* rounded cube - linear extrude - 2 rounded corners */
module r2cLE(x,y,z,r,dozadu) {
    echo("rcSOE x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    if (debug) { %cube([x+2*r,y+2*r,z], center=true); }
    
    translate([0,-y/4,0])
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    offset(r=+r)
    square([x,y/2],center=true);
    
    translate([0,(y+(2*r))/4 + dozadu/2,0])
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    square([x+2*r,(y+2*r)/2 + dozadu],center=true);
}

/* rounded cube - 2 circles + hull + linear extrude */
module rc2CHLE(x, y, z, r) {
    /* TODO - this should replace rc4CH */
}

module rc(x,y,z,r,i,c, dozadu) {
    if (y == 0) {
        if (i == c - 1) {
            r4cLE(x,1e-4,z,r, dozadu);
        } else {
            r2cLE(x,1e-4,z,r, dozadu);
        }
    } else {
        if (i == c - 1) {
            r4cLE(x,y,z,r, dozadu);
        } else {
            r2cLE(x,y,z,r, dozadu);
        }
    }
}

/************************************************************/
/* CARDHOLDER ***********************************************/
/************************************************************/

module without_holes(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z) {
    
    translate([0,
        to_side, //y
        to_z + to_up //z
    ]) {
        rc(x, z, ch_height, t + s, i, c, z + s);                
        
        /* this is the "cork" */
        //color("blue")
        translate([0, 0, bottom_offset  - (to_up / 2)])
            rc(x, z, t + to_up, t + s, i, c, z + s);
    }    
}

module holes(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z) {
    
    translate([0,
        to_side, //y
        to_z + to_up //z
    ]) {
            rc(x, z, ch_height, s, c - 1, c, 0);              
    }
}




/* see module one_card how the args for this function are computed */ 
module one_card_draw(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z, holes) {
    
    if (holes) {
        holes(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z);
    } else {
        without_holes(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z);
    }
}

module one_card(x,y,z,t,s,c,d,v,i,holes) {
    /* card height */
    c_height = y * (1 - v);
    
    /* card holder height */
    ch_height = c_height + s;
    
    /* this is where the bottom starts */
    bottom_offset = 0 - (ch_height / 2) - (t / 2);
    
    /* size of side wall */
    side_y = z + t + (2 * s);
    
    /* how much we need to move the card so the first card
       have y equals to 0 */
    to_side = (i * (t + s + s + z)) + ((side_y + t) / 2);
    
    /* delta */
    to_up = i * d;
    
    /* move the one card holder so z == 0 */
    to_z = (ch_height / 2) + t;
    
    /* draw the card */
    if (debug_show_card) {
        to_z_card = (y / 2) + s + t;
        translate([0,
            to_side, //y
            to_z_card + to_up //z
        ])
            color("red")
            cube([x,z,y], center=true);
        
        %one_card_draw(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z, holes);
    } else {
        /* if we don't draw the card, draw cardholder normally */
        one_card_draw(x,y,z,t,s,c,d,v,i, c_height, ch_height, bottom_offset, side_y, to_side, to_up, to_z, holes);
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
    difference() {
        /* holder without holes */
        for (i=[1:c]) {
            one_card(x,y,z,t,s,c,d,v, i - 1, 0);
        }
        /* holes */
        for (i=[1:c]) {
            one_card(x,y,z,t,s,c,d,v, i - 1, 1);
        }
    }
}

/* if the delta is negative, make it positive and rotate
   the cardholder */
module draw_cardholder_deltacheck(x,y,z,t,s,c,d,v) {
    if (d >= 0) {
        draw_cardholder(x,y,z,t,s,c,d,v);
    } else {
        rotate([0, 0, 180])
            draw_cardholder(x,y,z,t,s,c,-d,v);
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
    /*
This is the complete list of what we need to test (in Czech).
See the references in the code.

[0] Pokud size není vektor s alespoň dvěma složkami, nic se nevykreslí.
    
[1] Pokud má size pouze dvě složky, případně pokud je třetí složka 0, předpokládejte kartu s nulovou tloušťkou, což je v pořádku.
    
[2] Pokud je první nebo druhá složka vektoru size ⇐ 0, nevykreslí se nic.
    
[3] Pokud je cards <= 0, nevykreslí se nic.
    
[4] Pokud je thickness <= 0, předpokládejte hodnotu 0 (toto nebudeme testovat).
    
[5] Pokud je spacing <= 0, předpokládejte hodnotu 0.
    
[6] Pokud je delta 0, k žádnému posunu nedojde, pokud je záporné, posune se každá „zadnější“ karta níže (celý objekt se de facto převrátí zády dopředu).
    
[7] Pokud je visibility mimo interval (0, 1), předpokládejte krajní hodnotu (0 pro < 0, 1 pro > 1).
    */
    
    draw = (!len(size) || /* [0] */
           len(size) < 2 ||
           size[0] <= 0 || /* [2] */
           size[1] <= 0 ||
           cards <= 0) ? /* [3] */
               false :
               true;
    
    size = len(size) == 2 ? /* [1] */
           concat(size, 0) :
           size;
    
    thickness = thickness < 0 ? /* [4] */
                    0 :
                    thickness;
    
    spacing = spacing < 0 ? /* [5] */
                  0 :
                  spacing;
    
    visibility = visibility < 0 ? /* [7] */
                     0 :
                     visibility > 1 ?
                         1 :
                         visibility;
    
    /* i need shortcuts because i have a small screen */
    x = size[0]; /* výška karty */
    y = size[1]; /* šířka karty */
    z = size[2]; /* tloušťka */
    s = spacing;
    t = thickness;
    c = cards;
    d = delta;
    v = visibility;
    
    echo(draw);
    
    if (draw) {
        /* [6] */
        draw_cardholder_deltacheck(y,x,z,t,s,c,d,v);
    }
}

/************************************************************/
/* TESTS ****************************************************/
/************************************************************/

test_no = 0;
test_no_str = "no";

if (test_no_str == "small") {
    cardholder(size=[8.5, 5.4, 0.1], thickness=0.3, spacing=0.1, cards=4, delta=2.5, visibility=0.3);
    echo("TEST small: very small <<<<<");
}

if (test_no_str == "big") {
    cardholder(size=[8500, 5400, 100], thickness=300, spacing=100, cards=4, delta=2500, visibility=0.3);
    echo("TEST big: very big <<<<<");
}

if (test_no_str == "edux") {
    cardholder(size=[1, 20, 20], thickness=30, spacing=10, cards=4, delta=25, visibility=0.3);
    echo("TEST #2: edux default copied <<<<<");
}

if (test_no == 42) {
    cardholder(size=5, thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #42: size is a number. <<<<<");
    echo("TEST #42: NOTHING SHALL BE GENERATED <<<<<");
}

if (test_no == 666) {
    cardholder(size=[85, 64, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=0.3);
    echo("TEST #666: satan's test <<<<<");
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

if (test_no == 2000) {
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
