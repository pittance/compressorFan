//naca();
//#nacaPad();

module naca() {
    translate([-104.9,0,-70])intersection() {
        translate([0,0,-50])linear_extrude(150){
            import("nacaDuctProfile.dxf",layer="ductPlan");
        }
        translate([53,-29,90])rotate([0,90,0])linear_extrude(150){
            import("nacaDuctProfile.dxf",layer="ductlipElev");
        }
    }
}

module nacaPad() {
    translate([-47,-30,-100])intersection() {
        linear_extrude(100){
            import("nacaDuctProfile.dxf",layer="ductPlanPad");
        }
        translate([-10,-0,116])rotate([0,90,0])linear_extrude(120){
            import("nacaDuctProfile.dxf",layer="ductLipElevPad");
        }
    }
}
