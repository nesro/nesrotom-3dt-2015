==== semestralka ====

=== tohle je: ===
- ./readme.txt

=== scad soubor s moduley crystal a random_crystal ===
- ./crystal.scad

=== scad soubor volající modul crystal s vašimi vybranými daty (který jste si stáhli z Eduxu) ===
./crystal_data/11X/crystal114_full.scad

=== STL soubor s vaším vybraným krystalem z Eduxu ===
./crystal_data/11X/crystal114_full.stl

=== Tiskové STL soubory ===
./crystal_data/11X/crystal114_slic3r.stl

=== Tiskové GCODE soubory ===
./crystal_data/11X/crystal114.gcode

=== Profil pro slicovací program (co jsem zmenil je napsany nahore) ===
./nesrotom_Slic3r_config_bundle.ini

=== Případné další potřebné soubory ===
pripravil jsem k tisku vsechny 3 krystaly

=== rezani: ===
- v openscadu jsem to riznul na pul podle osy x na 2 casti

=== slic3r: ===
- http://dl.slic3r.org/linux/slic3r-linux-x86_64-1-2-9-stable.tar.gz

- smazat ~/.Slic3r (protoze jinak to pak dela kraviny)

- defaulni config bundle z: https://edux.fit.cvut.cz/courses/BI-3DT/_media/tutorials/tisk/slic3r_config_bundle.ini.zip

- Filament: 1.75 ABS, Printer: 3dráty

- horizontal shells, solid layers, top: 4

- infill: honeycomb

- generate support material: yes

- pattern spacing: 1.5mm

=== pronterface: ===
== crystal 112: ==
<code>
Loaded /home/n/Dropbox/g/nesrotom-3dt-2015/sw/crystals_data/112/crystal112.gcode, 232336 lines
23430.48mm of filament used in this print
The print goes:
- from 56.85 mm to 142.60 mm in X and is 85.75 mm wide
- from 12.65 mm to 186.46 mm in Y and is 173.81 mm deep
- from 0.00 mm to 35.75 mm in Z and is 35.75 mm high
Estimated duration: 119 layers, 4:04:36
</code>

== crystal 113: ==
<code>
Loaded /home/n/Dropbox/g/nesrotom-3dt-2015/sw/crystals_data/113/crystal113.gcode, 234239 lines
23912.02mm of filament used in this print
The print goes:
The print goes:
- from 15.96 mm to 185.85 mm in X and is 169.89 mm wide
- from 56.41 mm to 143.62 mm in Y and is 87.22 mm deep
- from 0.00 mm to 37.25 mm in Z and is 37.25 mm high
Estimated duration: 124 layers, 4:04:47
</code>

== crystal 114: ==
<code>
Loaded /home/n/Dropbox/g/nesrotom-3dt-2015/sw/crystals_data/114/crystal114.gcode, 238981 lines
23019.24mm of filament used in this print
The print goes:
- from 56.44 mm to 143.39 mm in X and is 86.95 mm wide
- from 16.38 mm to 183.25 mm in Y and is 166.87 mm deep
- from 0.00 mm to 37.85 mm in Z and is 37.85 mm high
Estimated duration: 126 layers, 3:59:25
</code>
--------------------------------------------------------------------------------

# edux
https://edux.fit.cvut.cz/courses/BI-3DT/classification/semestralka


# my crystals

https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal112.scad
https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal112.stl

https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal113.scad
https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal113.stl

https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal114.scad
https://edux.fit.cvut.cz/courses/BI-3DT/_media/classification/crystals151/crystal114.stl


# generate stl's
time openscad -o crystal112_full.stl crystal112_full.scad
time openscad -o crystal112_cut_top.stl crystal112_cut_top.scad
time openscad -o crystal112_cut_bottom.stl crystal112_cut_bottom.scad

time openscad -o crystal113_full.stl crystal113_full.scad
time openscad -o crystal113_cut_bottom.stl crystal113_cut_bottom.scad
time openscad -o crystal113_cut_top.stl crystal113_cut_top.scad

time openscad -o crystal114_full.stl crystal114_full.scad
time openscad -o crystal114_cut_top.stl crystal114_cut_top.scad
time openscad -o crystal114_cut_bottom.stl crystal114_cut_bottom.scad


