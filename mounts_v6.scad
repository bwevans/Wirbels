
$fn=60;
motor_d = 6;
motor_l = 15;
rod_d = 3.2;

*%circle(r=motor_d/2);
*motor_mount();
wall_bracket();
*loop_rod(length=4);

*rotate(90-18) wall_mount(y=76,z=18);
*wall_plate();

module motor_mount() union() {
	linear_extrude(height=motor_l*0.8) {
		difference() {
			circle(r=motor_d/2+1.5);
			circle(r=motor_d/2+0.5);
			translate([0,motor_d/2+1]) 
				square([2.5,1.5],center=true);
			

			rotate(60) 
			translate([motor_d/2+1,1.5]) 
				square([2.25,1.5],center=true);
			rotate(120) 
			translate([motor_d/2+1,-1.5]) 
				square([2.25,1.5],center=true);

		}
		for(i=[1:6]) rotate(i*60) translate([motor_d/2+0.55,0,0]) 
			square([1,1.5],center=true);
	}
	for(i=[0:8:8]) {
		translate([0,motor_d/2+i+0.1,rod_d/2+1.5]) rotate([-90,0])
			open_rod(length=4);
		translate([0,motor_d/2+4.1+i,rod_d/2+1.5]) rotate([-90,0])
			loop_rod(length=4);
	}
}

module wall_bracket() union(){
	translate([40,12,0]) wall_mount(y=85,z=20);
	translate([32,-80,0]) wall_mount(y=80,z=35);
	translate([-5,-30,0]) wall_mount(y=70,z=15);
	translate([-30,50,0]) wall_mount(y=75,z=355);
	translate([-80,-60,0]) wall_mount(y=72.5,z=30);
	translate([-98,10,0]) wall_mount(y=76,z=10);
}

module wall_plate() difference() {
	translate([-18,-20]) minkowski() {
		circle(r=4.5);
		square([140,120],center=true);
	}
	translate([20,12]) mounting_screws(y=85);
	*translate([12,-30]) mounting_screws(y=80);
	*translate([-5,-10]) mounting_screws(y=70);
	*translate([-30,30]) mounting_screws(y=75);
	*translate([-60,-20]) mounting_screws(y=72.5);
	*translate([-78,8]) mounting_screws(y=76);
}

module mounting_screws(y) rotate([0,y]) 
#rotate(270-(y-90)) translate([-10,-5]) {
	translate([5,5]) circle(r=1.6);
	translate([20/cos(90-y)+28-5,5]) circle(r=1.6);
}
	
module wall_mount(y,z) rotate([0,y,z]) difference() { // 
	union() {
		translate([-7,0,0]) {
			%linear_extrude(height=600) circle(r=rod_d/2);
			linear_extrude(height=2) circle(r=rod_d/2+1.5);
			closed_rod(length=4);
			translate([0,0,4]) for(i=[0:8:16]) {
				translate([0,0,i]) open_rod(length=4);
				translate([0,0,4+i]) closed_rod(length=4);
			}
		}
		difference() {
			translate([-4.5,-1.5,0]) cube([20,3,28]);
			rotate([0,90-y,0]) translate([0,-2,0]) cube([22,4,40]);
		}
		//rotate([0,270-(y-90),0]) 
		//translate([-3*sin(z)/cos(z),-1.5+tan(z)*3*sin(z)/cos(z),0]) rotate(-z) 
		//linear_extrude(height=1.5) 
		//minkowski() {
			//square([3*sin(z)+20*cos(z),20*sin(z)+3*cos(z)]);
			//circle(r=3);
		//}
		rotate([0,270-(y-90),0]) translate([-10,-5,0]) difference() {
			linear_extrude(height=4) minkowski() {
				translate([4.5,4.5]) square([20/cos(90-y)+28-9,10-9]);
				circle(r=4.5);
			}
			translate([5,5,-1]) cylinder(r=1.6,h=6);
			translate([20/cos(90-y)+28-5,5,-1]) cylinder(r=1.6,h=6);
			translate([5,5,2.5]) cylinder(r1=1.6,r2=5.7/2,h=1.55);
			translate([20/cos(90-y)+28-5,5,2.5]) cylinder(r1=1.6,r2=5.7/2,h=1.55);
		}
	}
}

module open_rod(length) {
	linear_extrude(height=length) difference() {
	circle(r=rod_d/2+1.5);
	circle(r=rod_d/2+0);
		for(x=[0,1]) mirror([0,x])
		for(y=[0,1]) mirror([y,0]) rotate(60) 
		translate([rod_d/2+1,1]) 
			square([2.5,2],center=true);
	}
}

module closed_rod(length) {
	linear_extrude(height=length) difference() {
	circle(r=rod_d/2+1.5);
	circle(r=rod_d/2);
	}
}

module loop_rod(length) 
linear_extrude(height=length,convexity=30) 
	difference() {
	union() {
		difference() {
			circle(r=rod_d/2+1.5);
			circle(r=rod_d/2);
			*mirror([0,1])
			for(y=[0,1]) mirror([y,0]) rotate(60) 
			translate([rod_d/2+1,2]) 
				square([2.5,2],center=true);
		}
		translate([0,-motor_d/2-0.5]) difference() {
			circle(r=2);
			circle(r=0.75);
		}
		for(i=[-1,1]) 
		translate([1.5*i,-motor_d/2+0.5]) square([1,2],center=true);
	}
	translate([0,-motor_d/2+1]) square([1.5,3],center=true);
}
