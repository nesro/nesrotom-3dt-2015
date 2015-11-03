
$fn = 99;



module cardholder(
    size=[85, 54, 1],
    thickness=3,
    spacing=1,
    cards=4,
    delta=25,
    visibility=0.3) { 
        s = spacing;
        t = thickness;
        xo = size[0];
        yo = size[1];
        zo = size[2];
        x = size[0] + s;
        y = size[1] + s;
        z = size[2] + s;
        xt = x + t;
        yt = y + t;
        zt = z + t;
        
   difference(){    
    color("blue")
    minkowski() {
        cube([x,y,z/2], center=true);
        cylinder(r=t, h=zt/2, center=true);
    }

    color("red")
    minkowski() {
        cube([xo,yo,zo], center=true);
        cylinder(r=s, h=size[2]/2, center=true);
    }
}

}

cardholder();