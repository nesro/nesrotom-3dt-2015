/* https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */
/* https://github.com/nesro/nesrotom-3dt-2015 */
/* nesrotom@fit.cvut.cz */

/* comment this out before submission! */
$fn = 10;

/******************************************************/

/* 1D offset wasn't a good idea */
/*
module line(x) {
    difference() {
    square([x,1],center=true);
    translate([0,0.5,0])
        square([x+0.5,2],center=true);
    }
}
offset(r=+3)
line(10);*/

/* rounded cube: square + offset + extrude */
/* tohle ale nemuzu pouzit, protoze to nefunguje kdyz je
   y = 0 */
module rcSOE(x,y,z,r) {
    echo("rcSOE x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    %cube([x+2*r,y+2*r,z], center=true);
    linear_extrude(height=z,center=true,convexity=0,twist=0)
    offset(r=+r)
    square([x,y],center=true);
}

/* rounded cube: 4 cylinders + hull */
module rc4CH(x,y,z,r) {
    echo("rc4CH x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    %cube([x+2*r,y+2*r,z], center=true);
    hull() {
        for (i=[-1,1])
            for (j=[-1,1])
                translate([(i*x/2),(j*y/2),0]) 
                    cylinder(r=r, h=z, center=true);
    }
}

/* rounded cube: 2 cylinders + cube (WIP!!!) */
module rc2CC(x,y,z,r) {
    echo("rc2CC x=",x,",\ty=",y,",\tz=",z,",\tr=",r);
    %cube([x+2*r,y+2*r,z], center=true);
    
    //d=z+r;
    //cylinder(r=d, h=z, center=true);
    
    cube([x+2*r,y,z], center=true);
    
    color("red")
    translate([0,x+2*r,0]) //FIXME
    cylinder(r=r, h=z, center=true);
    
}

module rc(x,y,z,r) {
    rc4CH(x,y,z,r);
}


/* one card holder */
module ch(x,y,z,s,t,down) {
    difference(){
        rc(z,x,y,s+t);
        rc(z,x,y,s);
    }
    translate([0,0,(-y/2) +t/2 - down/2])
    rc(z,x,t+down,s+t);
}

module draw_cardholder(x,y,z,t,s,c,d,v) {
    rotate([0,0,90]) //natoc aby  to bylo jako na eduxu
    translate([-(c*z+s+t+s+t),0,0]) //posun do prosted x
    for (a=[1:c]) { //pro kazdou kartu
        translate([a*t*2,0,a*d]) //pousun o delta
        translate([0,0,(y*v)/2]) //na osu z
        ch(x,y*v,z,s,t,a*d); //jeden drzacek na kartu
    }
}

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
    visibility = (visibility < 0) ? 0 : visibility;
    visibility = (1 < visibility) ? 1 : visibility;
    thickness = (thickness < 0) ? 0 : thickness;
    spacing = (spacing < 0) ? 0 : spacing;
    size = len(size) == 2 ? concat(size, 0) : size;
        
    /* i need shortcuts because i have a small screen */
    x = size[0];
    y = size[1];
    z = size[2];   
    s = spacing;
    t = thickness;
    c = cards;
    d = delta;
    v = 1 - visibility;
    
    if (draw) {
        draw_cardholder(x,y,z,t,s,c,d,v);
    }
}

/******************************************************/
/* tests */
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
    cardholder(size=[85, 54, 1], thickness=3, spacing=-3, cards=4, delta=25, visibility=0.3);
    echo("TEST #10: spacing < 0 <<<<<");
}

if (test_no == 11) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=0, visibility=0.3);
    echo("TEST #11: delta == 0 <<<<<");
}

if (test_no == 12) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=-5, visibility=0.3);
    echo("TEST #12: delta == -5 <<<<<");
    echo("TEST #12: FIXME: negeneruju dno <<<<<");
}

if (test_no == 13) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=-2);
    echo("TEST #13: visibility = -2 <<<<<");
    echo("TEST #13: FIXME: tohle ma mit maximalni diru, ja nemam zadnou :D <<<<<");
}

if (test_no == 14) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=4, delta=25, visibility=2);
    echo("TEST #14: visibility = 2 <<<<<");
    echo("TEST #14: FIXME: tohle ma mit malou dirku, ja mam docela velkou <<<<<");
}

if (test_no == 15) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=1, cards=1, delta=25, visibility=0.3);
    echo("TEST #15: only 1 card <<<<<");
}

if (test_no == 15) {
    cardholder(size=[85, 54, 1], thickness=3, spacing=10, cards=1, delta=25, visibility=0.3);
    echo("TEST #15: 10 cards <<<<<");
}
