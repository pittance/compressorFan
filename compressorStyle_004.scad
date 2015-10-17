use <naca.scad>

detail=150;              //linitial mount printed at 40 detail
nSteps = 60;            //number of vertical steps in the rotor generator - 10
nStans = nSteps;             //number of stations along the blade - 5
nBlades = 11;            //number of blades in the rotor
rotorHeight = 65;       //height of the rotor (clipped by intersection with profile)
rotorBolts = 2;
rotorCropHeight = 22;   //height of the lower part of the rotor
twistMult = 0.5;        //increase twist on rotor (tweaks the value from twister())
twistTweak = rotorCropHeight/rotorHeight;       //to fix twist on cropped lower rotor blades
bladeThick = 1.0;       //thickness of rotor blades
bladeSpan = 80;         //blade span (axis to edge, clipped by profile)
cropped = 0;            //1=generate cropped blades, 0=don't

//rotate([90,180,0])motor(2,0);

//CHECK THE ROTATION DIRECTION FOR THE ROTOR NUMBNUTS
//drop the part down 193mm to match motor

//MOTOR HOUSING*************************************
//for final render uncomment next line:
translate([0,0,200])rotate([180,0,0])baseMotorHousing();

//BASE FAIRING**************************************
//for final render uncomment next line:
//translate([0,0,160])rotate([180,0,0])baseFairing();

//SHROUD********************************************
//for final render uncomment next line:
//translate([0,0,250])rotate([180,0,0])shroud();
//translate([0,0,-270])shroudLip();

//ROTOR*********************************************
//for final render uncomment next line:
//translate([0,0,-210])rotor();

//STAND*********************************************
//for final render uncomment next lines:
//translate([-80,-170,0])stand();                            //RHS
//mirror([1,0,0])translate([-80,-170,0])stand();             //LHS

//170mm diam test section for bed size
//translate([0,0,-5])cylinder(h=2,d=160);
//translate([0,0,95])cylinder(h=2,d=180);

//ASSEMBLY
//for assembly uncomment next lines:
//translate([0,0,-193])baseMotorHousing();
//translate([0,0,-193])baseFairing();
//translate([0,0,-193])shroud();
//translate([0,0,-193])shroudLip();
//translate([0,0,-193])rotor();
//translate([0,0,-193])rotate([90,0,-30])stand();
//mirror([0,1,0])translate([0,0,-193])rotate([90,0,-30])stand();

module stand() {
    difference() {
        difference() {
            translate([0,0,0])linear_extrude(height=12)translate([0,0,0])scale(1)import(file = "turboProfileConvNew.dxf",layer="stand");
            translate([0,0,3])linear_extrude(height=9)translate([0,0,0])scale(1)import(file = "turboProfileConvNew.dxf",layer="stand2");
            hull() {
                translate([44,115,12])rotate([-90,0,-21]){
                    translate([0,0,0])rotate([0,5,0])cylinder(d=9*2,h=40,$fn=50);
                    translate([35,0,0])rotate([0,-30,0])cylinder(d=9*2,h=40,$fn=50);
                }
            }
            //remove bolt holes
            //nb:   remember to allow a hole in the bottom of the web for the bolt to the shroud case,
            //      this will allow the allen key to access SCS head
//            translate([0,0,0])rotate([-90,30,0])shroud();
            rotate([-90,30,0])rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="shroud");
//            translate([0,0,0])rotate([-90,30,0])baseFairing();
            rotate([-90,30,0])rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="base");
        }
        //bolting holes for stand
        translate([36,137,7.5])rotate([0,90,152])boltHole(29,5.5,12,2.1); //fairing end
        translate([65,227,7.5])rotate([0,90,220])boltHole(29,5.5,12,2.1);  //shroud end
    }
}

module baseMotorHousing() {
    difference() {
        union() {
            //clip away the lower part with a cut at 15mm down
            difference() {
                union() {
                    //form the base
                    rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="base");
                }
                //remove the bottom half
                translate([0,0,-12])cylinder(h=170,d=170);
                //remove the padded motor
//                translate([0,0,193])rotate([90,180,0])motor(5,0);
                //scoop out the inside (cylinder)
                translate([0,0,55])cylinder(h=150,d=130,$fn=detail);
            }
            //add the motor mounting sections - 193 down @ 19mm ht (clipped)
            translate([-5+24,-5+23,191.0])cube([11,11,19]);
            translate([-5-24,-5+23,191.0])cube([11,11,19]);
            //add the fairing mounting sections
            for (i=[0:2]) {
    translate([0,0,158.1])rotate([0,0,30+i*360/3])translate([61,0,0])cylinder(h=48,d=9,$fn=detail);
            }
        }
        //scoop out padded motor from housing (includes motor bolt holes)
        translate([0,0,192])rotate([90,180,0])motor(5,0);
        //cable routing
        rotate([0,0,0])translate([59.2,0,200])cylinder(h=80,d=6,$fn=detail);
        //mounting holes for the motor housing to be bolted to the shroud
        for(i=[0:4]){
            //five mounting holes
            translate([0,0,207])rotate([0,0,63.5+i*360/5])translate([61,0,0])boltHole(15,6.5,15,2.5);
        }
        //mounting holes for the fairing
        for(i=[0:2]){
            //three mounting holes
            translate([0,0,155])rotate([0,0,30+i*360/3])translate([61,0,0])boltHole(15,6.5,25,2.5);
        }
        //naca duct ventilation
        for(i=[0:2]){
            //five mounting holes
            translate([0,0,207])rotate([0,0,75+i*360/3])translate([69,0,-38])rotate([95,0,90])scale(0.2)naca();
        }
    }
    //cable strain relief
    rotate([90,0,-30])linear_extrude(height=2,scale=1)translate([0,0,0])import(file = "turboProfileConvNew.dxf",layer="strainRelief");
    rotate([90,0,-120])linear_extrude(height=2,scale=1)translate([0,0,0])import(file = "turboProfileConvNew.dxf",layer="strainRelief");
    rotate([90,0,180])linear_extrude(height=2,scale=1)translate([0,0,0])import(file = "turboProfileConvNew.dxf",layer="strainRelief");
    
}

module baseFairing() {
    difference() {
        //form the base
        rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="base");
        //remove the bottom half
        translate([0,0,-12+170])cylinder(h=170,d=170);
        //scoop out the inside
        translate([0,0,90])cylinder(d2=80,d1=0,h=80,$fn=detail);
        //mounting holes for the fairing
        for(i=[0:2]){
            //three mounting holes
            #translate([0,0,155])rotate([0,0,30+i*360/3])translate([61,0,0])boltHole(15,6.5,25,2.5);
        }
        //remove stand bolt hole
        rotate([90,0,-30]) {
            translate([36,137,7.5])rotate([0,90,152])boltHole(29,5.5,11,2.1); //fairing end
        }
        mirror([0,1,0])rotate([90,0,-30]) {
            translate([36,137,7.5])rotate([0,90,152])boltHole(29,5.5,11,2.1); //fairing end
        }
    }
}
module shroudLip() {
    difference() {
        union() {
            rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="shroud");
            //guard
            translate([0,75/2,0])rotate([90,0,0])linear_extrude(height=75,scale=1)translate([0,0,0])import(file = "turboProfileConvNew.dxf",layer="guard");
            rotate([0,0,90])translate([0,75/2,0])rotate([90,0,0])linear_extrude(height=75,scale=1)translate([0,0,0])import(file = "turboProfileConvNew.dxf",layer="guard");
        }
        //remove bottom part (in shroud)
        translate([0,0,270-100])cylinder(h=100,d=180);
        //remove bolt holes
        for(i=[0:3]){
            //three mounting holes
            translate([0,0,280])rotate([0,180,45+i*360/4])translate([35,0,0])boltHole(15,7,20,3.1);
        }
    }
    
}
module shroud() {
    difference() {
        union() {
            rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="shroud");
            //guide vanes
            translate([0,0,0]) {
                for(i=[0:4]){
                    translate([0,0,204])rotate([0,0,4+i*(360/5)])linear_extrude(height=15,scale=1)translate([9.3,-248,0])scale(0.9)import(file = "turboProfileConvNew.dxf",layer="guideVane");
                }
            }
        }
        //cable routing
        rotate([0,0,0])translate([59.2,0,200])cylinder(h=80,d=6,$fn=detail);
        //mounting holes for the motor housing to be bolted to the shroud
        for(i=[0:4]){
            //five mounting holes
            translate([0,0,210])rotate([0,0,63.5+i*360/5])translate([61,0,0])boltHole(15,6.5,15,2.5);
        }
        //remove motor housing
//        baseMotorHousing();
        rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="base");
        //remove stand bolt holes
        //bolting holes for stand - don't reverse rotation - mirror the second
        rotate([90,0,-30])translate([65,227,7.5])rotate([0,90,220])boltHole(29,5.5,12,2.1);  //shroud end
        mirror([0,1,0])rotate([90,0,-30])translate([65,227,7.5])rotate([0,90,220])boltHole(29,5.5,12,2.1);  //shroud end
        //remove top part (in shroudLip)
        translate([0,0,270])cylinder(h=100,d=180);
        //remove bolt holes
        for(i=[0:3]){
            //three mounting holes
            translate([0,0,280])rotate([0,180,45+i*360/4])translate([35,0,0])boltHole(15,7,20,2.1);
        }
    }
}

module motor(pad, depth) {
	translate([-61/2,0,-45.3]) {
		//main body
		cube([61,16.22,61.55]);
		//bearings
		translate([61/2,35,45.3])rotate([90,0,0])cylinder(h=48,d=24.82,$fn=detail);
		//shaft
		translate([61/2,68,45.3])rotate([90,0,0])cylinder(h=122,d=6,$fn=detail);
		//windings
		translate([(61/2-33/2),-14,-10.4])cube([33,40.6,35.7]);
		//mountings
		difference() {
			translate([(61/2+47.862/2-9.46/2),(16.22),51.6])cube([9.46,13.3,2.46]);
			translate([(61/2+47.862/2),(16.22+9.66),51.6])rotate([])cylinder(h=5,d=3.5,$fn=detail);
		}
		difference() {
			translate([(61/2-47.862/2-9.46/2),(16.22),51.6])cube([9.46,13.3,2.46]);
			translate([(61/2-47.862/2),(16.22+9.66),51.6])rotate([])cylinder(h=5,d=3.5,$fn=detail);
		}
                // bolts 23mm from shaft (towards coils - Y), 48mm tween holes (across coil - X), 4mm diam
                translate([61/2,68,45.3])rotate([90,0,0])translate([24,-24,30])cylinder(h=50,d=2.1,$fn=7);
                translate([61/2,68,45.3])rotate([90,0,0])translate([-24,-24,30])cylinder(h=50,d=2.1,$fn=7);
		if (pad>0) {
                    //add padding for clearance space inside housing
                    //iron laminates
//                    translate([-pad/2,-pad/2,-pad/2])cube([61+pad,16.22+pad,61.55+pad]);
                    translate([-pad/2,0,-pad/2])cube([61+pad,16.22+pad,61.55+pad]);
                    if (depth>0) translate([-pad/2,-pad/2-depth,-pad/2])cube([61+pad,16.22+pad+depth,61.55+pad]);
                    //bearings
                    translate([61/2,35+pad/2,45.3])rotate([90,0,0])cylinder(h=48+pad,d=24.82+pad,$fn=detail);
                    translate([0,-12,45.3-5])cube([60,12,10]);
                    //windings
                    translate([(61/2-33/2)-pad/2,-14-pad/2,-10.4-pad/2])cube([33+pad,40.6+pad,35.7+pad]);
                    if (depth>0) translate([(61/2-33/2)-pad/2,-14-pad/2-depth,-10.4-pad/2])cube([33+pad,depth+40.6+pad,35.7+pad]);
                    //top section
                    translate()cube([61,35,54.05]);
                    //shaft
                    translate([61/2,68,45.3])rotate([90,0,0])cylinder(h=122,d=6+pad,$fn=detail);
		}
	}
}

module rotor() {
    mountBoltLen = 8;
    difference() {
        union(){
            intersection() {
//                union() {
                    //full height blades
                    for (i=[0:(nBlades-1)]) {
                        translate([0,0,212]) {
                            rotate([0,0,i*360/(nBlades)]) {
                                rotorBlade(rotorHeight,1.0);
                            }
                        }
//                    }
                }
                rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file="turboProfileConvNew.dxf",layer="turboBlades");
            }
            rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConvNew.dxf",layer="turboCore");
        }
        //shaft hole >=6mm diam, >=40mm depth
        rotate()translate([0,0,211.4])cylinder(h=42,d=7,$fn=detail);
        //upper bolt holes for mount/clamp - m3x12
//        rotate([0,0,3*(360/nBlades)+0.405*(360/rotorBolts)]) {
//            for (i=[0:rotorBolts-1]){
//                rotate([0,0,(i/rotorBolts)*360])translate([-(mountBoltLen+6/2)+1,0,240])rotate([0,90,0])boltHole(50,7,mountBoltLen+2,2.1); //14mm to ensure complete intersectn
//            }
//        }
        //lower bolt holes for mount/clamp - m3x12
        rotate([0,0,0.43*(360/rotorBolts)]) {
            for (i=[0:rotorBolts-1]){
                rotate([0,0,(i/rotorBolts)*360])translate([-(mountBoltLen+6/2)+1,0,220])rotate([0,90,0])boltHole(50,7,mountBoltLen+2,2.1); //14mm to ensure complete intersectn
            }
        }
        rotate([0,0,3*(360/nBlades)+0.43*(360/rotorBolts)]) {
            for (i=[0:rotorBolts-1]){
                rotate([0,0,(i/rotorBolts)*360])translate([-(mountBoltLen+6/2)+1,0,220])rotate([0,90,0])boltHole(50,7,mountBoltLen+2,2.1); //14mm to ensure complete intersectn
            }
        }
        
    }
    //balance? might need additional bolts for balance...
}

//following functions used in rotorBlade
function flatten(l) = [for (a=l) for (b=a) b];    //seriously, how the f%@k does this work?
function pointRow(row,twist,maxHt) = concat(out(row,-twist,maxHt),back(row,-twist,maxHt));
function out(ht,tw,maxHt)= [for(i=[0:nStans-1])[(x(i/nStans)*cos(tw)+yp()*sin(tw)),(-x(i/nStans)*sin(tw)+yp()*cos(tw)),maxHt*ht/nSteps]];
function back(ht,tw,maxHt)= [for(j=[nStans-1:-1:0])[(x(j/nStans)*cos(tw)+yn()*sin(tw)),(-x(j/nStans)*sin(tw)+yn()*cos(tw)),maxHt*ht/nSteps]];
function x(p) = (p*bladeSpan);
function yp() = (bladeThick/2);
function yn() = -(bladeThick/2);

module rotorBlade(maxHt,twFix) {
    pts = flatten([for(k=[0:nSteps-1])pointRow(k,twisty(twFix*k/nSteps),maxHt)]);

    roundFace = concat(
        [for(j=[0:nSteps-2])for(i=[0:(nStans*2)-2])[i+(nStans*2)*j,(i+1)+(nStans*2)*j,(i+(2*nStans+1))+(nStans*2)*j]],
        [for(j=[0:nSteps-2])for(i=[0:(nStans*2)-2])[i+(nStans*2)*j,(i+(2*nStans+1))+(nStans*2)*j,(i+(2*nStans))+(nStans*2)*j]]
        );
//    echo(roundFace);
    
    endFace = concat(
        [for(j=[0:nSteps-2])[(2*nStans-1)+(nStans*2)*j,0+(nStans*2)*j,(2*nStans)+(nStans*2)*j]],
        [for(j=[0:nSteps-2])[(2*nStans-1)+(nStans*2)*j,(2*nStans)+(nStans*2)*j,(4*nStans-1)+(nStans*2)*j]]
        );
//    echo(endFace);
        
    btmFace = concat(
        [for(i=[0:(nStans)-2])[(nStans+1)+i,nStans+i,nStans-1-i]],
        [for(i=[0:(nStans)-2])[(nStans+1)+i,nStans-1-i,nStans-2-i]]
        );
//        echo(btmFace); 
        
    topFace = concat(
        [for(i=[0:(nStans)-2])[(2*nStans*nSteps)-(2*nStans)+i,(2*nStans*nSteps)-(2*nStans)+1+i,(2*nStans*nSteps)-2-i]],
        [for(i=[0:(nStans)-2])[(2*nStans*nSteps)-(2*nStans)+i,(2*nStans*nSteps)-2-i,(2*nStans*nSteps)-1-i]]
         );
//        echo(topFace);
        
    polyhedron(points=pts,faces=concat(roundFace,endFace,btmFace,topFace));

}

//function defines the twist on the blades of the rotor
function twister(frac) = [0,0,-twistMult*exp(frac)*exp(frac)*exp(frac)*exp(frac)*exp(frac)];
//function twisty(frac) = -twistMult*exp(frac)*exp(frac)*exp(frac)*exp(frac)*exp(frac);
function twisty(frac) = tw1(frac)+tw2(frac);
function tw1(frac) = -twistMult*exp(frac)*exp(frac)*exp(frac)*exp(frac)*exp(frac);
function tw2(frac) = twistMult/8*exp(-frac+1)*exp(-frac+1)*exp(-frac+1)*exp(-frac+1)*exp(-frac+1);
//function tw2(frac) = -twistMult*20*(cos((-frac+1)*180)+1);

module boltHole(headLength, headDiam, shaftLength, shaftDiam) {
 	//(M3)
	//head length std = 3mm
	//head diameter std = 5.5mm
        //length defined
	//shaft diameter std = 3mm
        //3,5.5,12,2.1 
	union() {
		cylinder(h=shaftLength,d=shaftDiam,$fn=detail);
		translate([0,0,-headLength]) cylinder(h=headLength,d=headDiam,$fn=detail); //h=2.9
	}
}

module boltHoleNut(headLength, headDiam, shaftLength, shaftDiam) {
 	//(M3)
	//head length std = 3mm
	//head diameter std = 5.5mm
	//shaft diameter std = 3mm
	//length defined
	union() {
		cylinder(h=shaftLength,d=shaftDiam,$fn=detail);
		translate([0,0,-headLength]) cylinder(h=headLength,d=headDiam,$fn=detail); //h=2.9
		translate([0,0,shaftLength-2.4])cylinder(h=2.4,d=6.5,$fn=6);
	}
}