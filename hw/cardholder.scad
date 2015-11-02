/* nesrotom@fit.cvut.cz
https://github.com/nesro/nesrotom-3dt-2015
https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol */












module cardholder(
	size=[85, 54, 1],
	thickness=3,
	spacing=1,
	cards=4,
	delta=25,
	visibility=0.3) {

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
	rotate(a=[0,90,0]) cylinder(r=st, h=sx, center=true);
	rotate(a=[0,90,0]) cylinder(r=s, h=sx, center=true);
}

difference() {

	/* krabicka s dirou na kartu uprostred */
	difference() {
		cube([sxst,syst,szst], center=true);
		cube([sxs,sys,szs], center=true);
	}

	translate([
/* 1. nejdriv si to co rezu soupnu ze "stredu" "okrajem"
   na osu.
   2. posunu to jeste o "pulku na druhou stranu */
					((sxs*visibility)/2)-(sxs/2)	,0,0])
		cube(
				[(sx+spacing)*visibility,
				 (sy+spacing)*1,
				 sz+spacing],
				center=true);
	
}

}

cardholder(spacing=1);