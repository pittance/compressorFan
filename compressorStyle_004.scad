detail=40;              //leave at 40 - initial mount printed at 40 detail
nSteps = 5;            //number of vertical steps in the rotor generator
nStans = 10;             //number of stations along the blade
nBlades = 7;            //number of blades in the rotor
rotorHeight = 55;       //height of the rotor (clipped by intersection with profile)
twistMult = 0.5;        //increase twist on rotor (tweaks the value from twister())
bladeThick = 1.1;       //thickness of rotor blades
bladeSpan = 70;         //blade span (axis to edge, clipped by profile)

//rotate([90,180,0])motor(0,0);

//CHECK THE ROTATION DIRECTION FOR THE ROTOR NUMBNUTS
//drop the part down 193mm to match motor

//MOTOR HOUSING*************************************
//for assembly uncomment next line:
//translate([0,0,-193])baseMotorHousing();
//for final render uncomment next line:
//translate([0,0,200])rotate([180,0,0])baseMotorHousing();

//BASE FAIRING**************************************
//for assembly uncomment next line:
//translate([0,0,-193])baseFairing();
//for final render uncomment next line:
//translate([0,0,160])rotate([180,0,0])baseFairing();

//SHROUD********************************************
//for assembly uncomment next line:
//translate([0,0,-193])shroud();
//for final render uncomment next line:
//translate([0,0,250])rotate([180,0,0])shroud();

//ROTOR*********************************************
//for assembly uncomment next line:
//translate([0,0,-193])rotor();
//for final render uncomment next line:
//translate([0,0,-210])rotor();






rotorBlade();



//170mm diam test section for bed size
//translate([0,0,90])cylinder(h=2,d=170);
//translate([0,0,95])cylinder(h=2,d=180);

module baseMotorHousing() {
    difference() {
        union() {
            //clip away the lower part with a cut at 15mm down
            difference() {
                //form the base
                rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConv.dxf",layer="base");
                //remove the bottom half
                translate([0,0,-12])cylinder(h=170,d=170);
                //remove the padded motor
//                translate([0,0,193])rotate([90,180,0])motor(5,0);
                //scoop out the inside (cylinder)
                translate([0,0,55])cylinder(h=150,d=130,$fn=detail);
            }
            //add the motor mounting sections - 193 down @ 17mm ht
            translate([-5+24,-5+23,193.0])cube([10,10,17]);
            translate([-5-24,-5+23,193.0])cube([10,10,17]);
        }
        //scoop out padded motor from housing (includes motor bolt holes)
        translate([0,0,193])rotate([90,180,0])motor(5,0);
        //cable routing
        rotate([0,0,-4])translate([59.2,0,200])cylinder(h=80,d=6,$fn=detail);
        //mounting holes for the motor housing to be bolted to the shroud
        for(i=[0:2]){
            //three mounting holes
            translate([0,0,206])rotate([0,0,55+i*360/3])translate([60,0,0])boltHole(15,6.5,25,2.5);
        }
        //mounting holes for the fairing
        for(i=[0:2]){
            //three mounting holes
            translate([0,0,155])rotate([0,0,55+i*360/3])translate([68,0,0])boltHole(15,6.5,25,2.5);
        }
    }
}

module baseFairing() {
    difference() {
        //form the base
        rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConv.dxf",layer="base");
        //remove the bottom half
        translate([0,0,-12+170])cylinder(h=170,d=170);
        //scoop out the inside
        #translate([0,0,90])cylinder(d2=100,d1=0,h=80,$fn=detail);
        //mounting holes for the fairing
        for(i=[0:2]){
            //three mounting holes
            #translate([0,0,155])rotate([0,0,55+i*360/3])translate([68,0,0])boltHole(15,6.5,25,2.5);
        }
    }
}
module shroud() {
    difference() {
        union() {
            rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConv.dxf",layer="shroud");
            //guide vanes
            for(i=[0:5]){
                translate([0,0,210])rotate([0,0,i*(360/6)])linear_extrude(10)translate([5,-250,0])scale(0.9)import(file = "turboProfileConv.dxf",layer="guideVane");
            }
        }
        //cable routing
        #rotate([0,0,-4])translate([59.2,0,200])cylinder(h=80,d=6,$fn=detail);
        //mounting holes for the motor housing to be bolted to the shroud
        for(i=[0:2]){
            //three mounting holes
            #translate([0,0,206])rotate([0,0,55+i*360/3])translate([60,0,0])boltHole(15,6.5,25,2.5);
        }
        //remove motor housing
        baseMotorHousing();
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
                translate([61/2,68,45.3])rotate([90,0,0])translate([24,-23,25])cylinder(h=50,d=3);
                translate([61/2,68,45.3])rotate([90,0,0])translate([-24,-23,25])cylinder(h=50,d=3);
		if (pad>0) {
                    //add padding for clearance space inside housing
                    //iron laminates
                    translate([-pad/2,-pad/2,-pad/2])cube([61+pad,16.22+pad,61.55+pad]);
                    if (depth>0) translate([-pad/2,-pad/2-depth,-pad/2])cube([61+pad,16.22+pad+depth,61.55+pad]);
                    //bearings
                    translate([61/2,35+pad/2,45.3])rotate([90,0,0])cylinder(h=48+pad,d=24.82+pad,$fn=detail);
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
//    intersection() {
//        union() {
//            for (i=[0:(nBlades-1)]) {
//                translate([0,0,210]) {
//                    rotate([0,0,i*360/(nBlades)]) {
//                        rotorBlade();
//                    }
//                }
//            }
//        }
//        rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConv.dxf",layer="turboBlades");
//    }
//    rotate_extrude($fn=detail)translate([0,0,0])rotate([0,0,0])import (file = "turboProfileConv.dxf",layer="turboCore");
    //assemble points for use in generation of the blade
    //0:nStans is station range along the blade
    //0:nSteps is steps up the blade
//    points = [for(k=[0:nSteps])pointRow(k)];
//    bladePoints = concat(
//            [for(k=[0:nSteps])for(j=[0:nStans])[j/nStans*bladeSpan,bladeThick/2,rotorHeight*k/nSteps]],
//                [for(n=[nStans:-1:0])[n/nStans*bladeSpan,-bladeThick/2,rotorHeight*n/nSteps]]);
//    bladePoints = flatten(points);
//    echo(bladePoints);
//    bladeFaces = [[0,5,6],[0,6,11]];
//    echo(flatten([for(k=[0:nSteps])pointRow(k)]));
//    polyhedron(points=flatten([for(k=[0:nSteps])pointRow(k)]),faces=bladeFaces);
}

//following functions used in rotorBlade
//function flatten(l) = [for (a=l) for (b=a) b];    //seriously, how the f%@k does this work?
//function pointRow(row,twist) = concat(out(row),back(row,twist));
//function out(ht)= [for(i=[0:nStans])[(i/nStans*bladeSpan),(bladeThick/2),rotorHeight*ht/nSteps]];
//function back(ht)= [for(j=[nStans:-1:0])[j/nStans*bladeSpan,-bladeThick/2,rotorHeight*ht/nSteps]];

function flatten(l) = [for (a=l) for (b=a) b];    //seriously, how the f%@k does this work?
function pointRow(row,twist) = concat(out(row,twist),back(row,twist));
function out(ht,tw)= [for(i=[0:nStans])[(x(i/nStans)*cos(tw)+yp()*sin(tw)),(-x(i/nStans)*sin(tw)+yp()*cos(tw)),rotorHeight*ht/nSteps]];
function back(ht,tw)= [for(j=[nStans:-1:0])[(x(j/nStans)*cos(tw)+yn()*sin(tw)),(-x(j/nStans)*sin(tw)+yn()*cos(tw)),rotorHeight*ht/nSteps]];
function x(p) = (p*bladeSpan);
function yp() = (bladeThick/2);
function yn() = -(bladeThick/2);

module rotorBlade() {
//    for (j=[0:(nSteps-2)]) {
//        hull() {
//            rotate(twister(j/nSteps))translate([0,0,(j/nSteps)*rotorHeight])rotate([90,0,0]){
////                cylinder(d=bladeThick,h=bladeSpan,$fn=8);
//                translate([0,0,-bladeThick/2])cube([bladeSpan,bladeThick,bladeThick],$fn=detail);
//            }
//            rotate(twister((j+1)/nSteps))translate([0,0,((j+1)/nSteps)*rotorHeight])rotate([90,0,0]){
////                cylinder(d=bladeThick,h=bladeSpan,$fn=8);
//                translate([0,0,-bladeThick/2])cube([bladeSpan,bladeThick,bladeThick],$fn=detail);
//            }
//        }
//    }
//    twistInputList = [ for (i = [0 : (1/nSteps) : 1]) i ];
//    twistOutputList = [for (a = [ 0 : len(twistInputList) - 1 ]) twisty(twistInputList[a]) ];
//    
////    linear_extrude(height=50,slices=20)rotate(twistListOutput)square([50,1.5]);
////    echo(twistInputList);
////    echo(twistOutputList);
//    //0  1  2  3  4  5
//    //6  7  8  9  10 11
//    //0   1   2
//    //5   4   3
//    //---------
//    //6   7   8
//    //11  10  9
//    pointList = [[0,0,0],[0,25,0],[0,50,0],[2,50,0],[2,25,0],[2,0,0],
//                [0,0,2],[0,25,2],[0,50,2],[2,50,2],[2,25,2],[2,0,2]];
//    faceList = [[0,1,2,3,4,5],[11,10,9,8,7,6],[5,4,3,9,10,11],[0,1,2,8,7,6],[2,3,9,8],[0,5,11,6]];
//    pointList = []; 
//    polyhedron(
//        points=pointList,
//        faces=faceList);
    
    btmFace = [for(i=[0:(2*nStans)+1]) i];
        
    topFace = [for(i=[nSteps*((2*nStans)+2):(nSteps*(2*nStans+2))+(2*nStans+1)]) i];
        
    endFaceOne = concat([for(i=[0:(2*nStans+2):(2*nStans+2)*nSteps])i],[for(i=[(2*nStans+1)+(2*nStans+2)*nSteps:-(2*nStans+2):(2*nStans+1)]) i]);
        
    endFaceTwo = concat([for(i=[nStans:(2*nStans+2):nStans+(2*nStans+2)*nSteps])i],[for(i=[nStans+1+(2*nStans+2)*nSteps:-(2*nStans+2):nStans+1])i]);
        
    sideFaceOne = [for(j=[0:nSteps-1])concat([for(i=[(j*(2*nStans+2)):nStans+(j*(2*nStans+2))])i],[for(i=[nStans+((j+1)*(2*nStans+2)):-1:((j+1)*(2*nStans+2))])i])];  
        
    sideFaceTwo = [for(j=[0:nSteps-1])concat([for(i=[(j*(2*nStans+2))+nStans+1:2*nStans+1+(j*(2*nStans+2))])i],[for(i=[2*nStans+((j+1)*(2*nStans+2))+1:-1:((j+1)*(2*nStans+2))+nStans+1])i])]; 
        
//    allFace = concat([btmFace],[topFace],[endFaceOne],[endFaceTwo],sideFaceOne,sideFaceTwo);
    allFace = concat([btmFace],[topFace],sideFaceOne,sideFaceTwo);

    polyhedron(points=flatten([for(k=[0:nSteps])pointRow(k,twisty(k/nSteps))]),faces=allFace);
    
}

//function defines the twist on the blades of the rotor
function twister(frac) = [0,0,-twistMult*exp(frac)*exp(frac)*exp(frac)*exp(frac)*exp(frac)];
function twisty(frac) = -twistMult*exp(frac)*exp(frac)*exp(frac)*exp(frac)*exp(frac);

module boltHole(headLength, headDiam, shaftLength, shaftDiam) {
 	//(M3)
	//head length std = 3mm
	//head diameter std = 5.5mm
        //length defined
	//shaft diameter std = 3mm
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