/*
nesrotom@fit.cvut.cz
https://github.com/nesro/nesrotom-3dt-2015
https://edux.fit.cvut.cz/courses/BI-3DT/classification/openscad-ukol
*/



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


difference() {
	difference() {
		cube([sx+spacing,sy+spacing,sz+spacing], center=true);
		cube([sx,sy,sz], center=true);
	}

	translate([
/* 1. nejdriv si to co rezu soupnu ze "stredu" "okrajem"
   na osu.
   2. posunu to jeste o "pulku na druhou stranu */
					(((sx+spacing)*visibility)/2)-
						((sx+spacing)/2)
					,0,0])
		cube(
				[(sx+spacing)*visibility,
				 (sy+spacing)*1,
				 sz+spacing],
				center=true);
	
}

}

cardholder(spacing=1);