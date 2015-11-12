
/************************************************************/

$fn = 20;

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
    to_side = i * (t + s + s + z);
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
        side_y = z + t + 2 * s;
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
    
    translate([0,
        -(c*(z+s+s+t))/2
    ,0])
    for (i=[1:c]) {
        one_card(x,y,z,t,s,c,d,v, i - 1);
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
    /* i wrote this code after a lot of updog */
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

cardholder();