/*
nesrotom@fit.cvut.cz
http://www.openscad.org/cheatsheet/
https://github.com/nesro/nesrotom-3dt-2015
https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */



/****************************************************************/





/****************************************************************/

/* krabicka s dirou na kartu uprostred */
module k(x,y,z,t) {
	xt = x + t;
	yt = y + t;
	zt = z + t;

	difference() {
		cube([xt,yt,zt], center=true);
		cube([x,y,z], center=true);
	}
}

/****************************************************************/

/* 1. nejdriv si to co rezu soupnu ze "stredu" "okrajem"
   na osu.
   2. posunu to jeste o "pulku na druhou stranu
*/
module kd(x,y,z,t,v) {
	xt = x + t;
	yt = y + t;
	zt = z + t;
	difference() {
		k(x,y,z,t);
		translate([((xt*v)/2)-(xt/2),0,0])
			cube([xt*v + 0.001,yt,zt],center=true);
	}
}


/****************************************************************/

module cardholder(
	size=[85, 54, 1],
	thickness=3,
	spacing=1,
	cards=4,
	delta=25,
	visibility=0.3) {

        
        
        
        
        
        
/*
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
*/

x = size[0];
y = size[1];
z = size[2];
t = thickness;
s = spacing;
c = cards;
d = delta;
v = visibility;

st = s + t;
xs = x + s;
ys = y + s;
zs = z + s;


 union() {

translate([0, ys/2, zs/2])
	rotate(a=[0,90,0])
		color("red") cylinder(d=s+t, h=xs+t, center=true,$fn=99);
     
     
     
     
     k(xs,ys,zs,t);
}

/*
translate([0, ys/2, 0]) difference() {
	rotate(a=[0,90,0]) cylinder(r=st, h=xs+t, center=true);
	rotate(a=[0,90,0]) cylinder(r=s, h=xs+t, center=true);
}*/

//kd(xs,ys,zs,t,v);

/*

sx = size[0];
sy = size[1];
sz = size[2];
sxs = sx + spacing;
sys = sy + spacing;
szs = sz + spacing;
sxst = sxs + thickness;
syst = sys + thickness;
szst = szs + thickness;
s  = spacing;
st = spacing + thickness;



difference() {
	k(x,y,z,s,t);


	translate([((sxs*visibility)/2)-(sxs/2),0,0])
		cube([(sxs)*visibility,sys,szs],center=true);
	
}
*/

}

cardholder();






/*


translate([0, ys/2, 0]) difference() {
	rotate(a=[0,90,0]) cylinder(r=st, h=xs*v, center=true);
	rotate(a=[0,90,0]) cylinder(r=s, h=xs*v, center=true);
}

*/