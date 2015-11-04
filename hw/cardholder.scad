
/* comment this out before submission */
$fn = 50;

/* rounded cube */
module rc(x,y,z,r) {
    //echo("rc x=",x,", y=",y,",z=",z,",r=",r);
    //%cube([x+2*r,y+2*r,z], center=true);
    hull() {
        translate([(x/2),(y/2),0]) 
            cylinder(r=r, h=z, center=true);
        translate([(-x/2),(y/2),0]) 
            cylinder(r=r, h=z, center=true);
        translate([(x/2),(-y/2),0]) 
            cylinder(r=r, h=z, center=true);
        translate([(-x/2),(-y/2),0]) 
            cylinder(r=r, h=z, center=true);
    }
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

module cardholder(
    size=[85, 54, 1],
    thickness=3,
    spacing=1,
    cards=4,
    delta=25,
    visibility=0.3)
{
    /* validate arguments */
    will_it_draw = true;
        
    if (len(size) < 2 || size[0] <= 0 || size[1] <= 0 ||
        cards <= 0) {
        will_it_draw = false;
    }
    
    if (len(size) == 2) {
        concat(size, 0);
    }
    
    if (spacing < 0) {
		spacing = 0;
	}

	if (thickness < 0) {
		thickness = 0;
	}

	if (visibility < 0) {
		visibility = 0;
	}

	if (visibility > 1) {
		visibility = 1;
	}
    
    /* i need shortcuts because i have a small screen */
    x = size[0];
    y = size[1];
    z = size[2];
    s = spacing;
    t = thickness;
    c = cards;
    d = delta;
    v = visibility;
    X = x + s;
    Y = y + s;
    Z = z + s;
    
    /* draw it! */
    if (will_it_draw) {
    rotate([0,0,270])
    translate([-(c*z+s+t+s+t),0,0])
    for (a =[0:c]) {
        translate([a*t*2,0,a*d]) //pousun o delta
        translate([0,0,(y*v)/2]) //na osu z
        ch(x,y*v,z,s,t,a*d);
    }
    }
}

cardholder();