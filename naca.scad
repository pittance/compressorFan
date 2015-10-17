
module naca() {
    translate([-104.9,0,-77])intersection() {
        linear_extrude(100){
            import("nacaDuctProfile.dxf",layer="ductPlan");
        }
        translate([53,-29,90])rotate([0,90,0])linear_extrude(100){
            import("nacaDuctProfile.dxf",layer="ductlipElev");
        }
    }
}
