 
$fn = 20;

/* rc = rounded corners
   x, y, z = size
   r = radius of the corners
   h = height of the edge cube */
module rc(x, y, z, r, h) {
    echo("rc2CC x=", x, ", y=", y,", z=", z, ", r=", r);
    //%cube([x + (2 * r), y + (2 * r), z], center=true);

    cube([x, y + (2 * r), z], center=true);
    
    for (i = [-1, 1])
        translate([i * (x/2 - y/2), 0, 0])
            cylinder(r=((y / 2) + r), h=z, center=true);
    
    if (0 < h) {
        cd = 2 * ((y / 2) + r); /* cube diameter */
        for (i = [-1, 1])
            translate([i * (x/2 - y/2), 0, -(z / 2) + (h / 2)])
                cube([cd, cd, h], center=true);
        
    }
}

//rc(10, 1, 10, 1, 0);
rc(10, 5, 10, 1, 0);



/* FIXME: tady ji musim rict, kolikata karta to je */
module one_card(x, y, z, t, s, c, d, v, i) {
    difference() {
        rc(x, z, y*(1 - v), s + t, y*v);
        rc(x, z, y*(1 - v), s, 0);
    }
    
    /* cube to ground */
    tg = i*d;
    echo("i",i,"tg",tg);
    
    color("red")
    translate([0, 0, -(y * (1 - v) / 2) - (t/2) - tg/2])
        cube([
            x + 2 * (s + t),
            z + (s + t) * 2,
            t + tg
            ], center=true);
}

module draw_cardholder(x, y, z, t, s, c, d, v) {
    /* 0 - poradi karty, abych si dopocital jak moc bude vysoko */
    
    for (i=[1:c]) { //pro kazdou kartu
        translate([0,
            i*(t + 2*s + z), //y
            (i-1)*d + (y*(1-v))/2 + t //z
            ]) //pousun o delta
        one_card(x, y, z, t, s, c, d, v, (i - 1));
    }
    
}


module cardholder(
    size=[85, 54, 1],
    thickness=3,
    spacing=1,
    cards=2,//4,
    delta=25,
    visibility=0.3)
{
    draw = (len(size) < 2 || size[0] <= 0 ||
            size[1] <= 0 || cards <= 0) ? false : true;
    visibility = (visibility < 0) ? 0 : (1 < visibility) ? 1 : visibility;
    thickness = (thickness < 0) ? 0 : thickness;
    spacing = (spacing < 0) ? 0 : spacing;
    size = len(size) == 2 ? concat(size, 0) : size;
    
    echo("CARDHOLDER","draw",draw,"visibility",visibility,"thickness",thickness,
        "spacing",spacing,"size",size);

    x = size[0];
    y = size[1];
    z = size[2];   
    s = spacing;
    t = thickness;
    c = cards;
    d = delta;
    v = visibility;
    
    if (draw) {
        draw_cardholder(x,y,z,t,s,c,d,v);
    }
}

//cardholder();
