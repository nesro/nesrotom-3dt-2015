

/* The next line represents the width of my editor
   in OpenSCAD. Yes. I have a small 13" monitor.
/**************************************************/

zero=0.0001;

/* WARNING:
   comment out this line before submisson! */
$fn = 100;

/**************************************************/

/* minkowski of cube + cylinder */
module mcc(x,y,z,r) {
    echo("mcc x=",x,", y=",y,",z=",z,",r=",r);
    
    if (z > x || z > y) {
        echo("WARNING: MCC needs both x and y < z",
        "this is bullthis probabaly");
    }
    
    /* ten nejmensi necham nakonec? */
    cux = x-2*r;
    cuz = y-2*r;
    cuy = z/2;
    cyr = r;
    cyh = y/2;
    echo("mcc cux=",cux,", cuy=",cuy,",cuz=",cuz,",cyr=",cyr,",cyh=",cyh);
    
    //%cube([x,y,z], center=true);
    minkowski() {
        cube([cux, cuy, cuz], center=true); 
        cylinder(r=cyr, h=cyh, center=true);
    }
}

module card(x,y,z,t,s) {
    difference() {
        mcc(x,y,z,t+s);
        mcc(x-z-s,y,z,t);
    }
}

/**************************************************/
module cardholder(
    size=[85, 54, 1],
    thickness=3,
    spacing=1,
    cards=4,
    delta=25,
    visibility=0.3)
{
    x = size[0];
    y = size[1];
    z = size[2];
    s = spacing;
    t = thickness;
    c = cards;
    v = visibility;
    X = x + s;
    Y = y + s;
    Z = z + s;
   
    color("red")
        translate([0,0,(y-(y*v))/2])
            card(x,y-(y*v),z,t,s);
    
    
    mh=t+s;
    minkowski() {
        cube([x - 2*t, z, mh/2], center=true); 
        cylinder(r=t, h=mh/2, center=true);
    }
    
    //card(x,z,y-(y*v),t,s);
    
    //translate([30,30,30])
    //mcc(x,1,x,t+s);
    
    /*difference() {
        color("red") card(x,y,z,t,s);
    
        translate([0,0,y*v/2-(y/2)])
        color("blue") card(x,y*v+0.1,z,t,s);
    }*/
}

cardholder();