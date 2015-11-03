

$fn=99;



/*color("blue")
minkowski() {
     cube([20,10,5], center=true);
    cylinder(r=5, h=5, center=true);
}*/

module mcc(x,y,z,rr) {
    minkowski() {
        cube([x-2*rr,y-2*rr,z/2], center=true);
        cylinder(r=rr, h=z/2, center=true);
    }
}


r = 5;
x = 20;
y = 10;
z = 5;

color("red") cube([x,y,z], center=true);
color("blue") mcc(x,y,z,r);