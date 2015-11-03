

/* The next line represents the width of my editor
   in OpenSCAD. Yes. I have a small 13" monitor.
/**************************************************/

/* WARNING:
   comment out this line before submisson! */
$fn = 500;

/**************************************************/

/* minkowski of cube + cylinder */
module mcc(x,y,z,r) {
    echo("mcc x=",x,", y=",y,",z=",z,",r=",r);
    
    if (z > x || z > y) {
        echo("WARNING: MCC needs both x and y < z",
        "this is bullthis probabaly");
    }
    
    cux = x-2*r;
    cuz = y-2*r;
    cuy = z/2;
    cyr = r;
    cyh = z/2;
    echo("mcc cux=",cux,", cuyy=",cuy,",cuz=",z,",cyr=",cyr,",cyh=",cyh);
    
    //%cube([x,y,z], center=true);
    minkowski() {
        cube([cux, cuy, cuz], center=true);
        cylinder(r=cyr, h=cyh, center=true);
    }
    
    /*
    minkowski() {
        cube([x-2*r, y-2*r, (z/2)], center=true);
        cylinder(r=r, h=(z/2), center=true);
    }
    
    */
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
          
difference() {
mcc(x,y,z,t+s);
mcc(x-z-s,y,z,t);
}


}

cardholder();