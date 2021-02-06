//////////////////////////////////////////////////////////////////////////////////////
///
///  Double Hinged Frame for Smart LCD 2004 and Full Graphic 12864 Controller
///
///  This file constructs a double hinged frame for the Smart LCD Controller for mounting
///  on a box-frame Prusa i3 3D printer.  The hinge mechanism allows the controller
///  to be stowed away behind the frame when it's not being used.
///  
///  The project consists of the LCD frame as such and a strong double hinge mechanism.
///  Both frame and hinge mechanism can also be used independently, i.e. if the
///  Smart LCD Controller is to be mounted in a fixed position, the hinge is not
///  needed, and the hinge mechanism alone could well also be useful for flexible
///  mounting devices other than that particular controller.
///
///  The Smart LCD Controller is inserted into frame part and fastened on it by
///  means of four M3x10 screws.  
///
///  The hinge axes are M4 screws which are tightened with a spring and a Nyloc nut,
///  as to allow rotation while maintaining enough pressure to keep the frame solidly
///  in place.  The printer-side hinge also has a locking mechanism to restrict the
///  rotation between 0 and 90 degrees.  Also grooves at 0 and 90 degrees cause
///  the hinge to snap precisely into place at the two end positions.
///
///  The provided SCAD file is fully parametrized, so that it can be easily modified
///  to particular needs, if necessary.  Separate STL files are provided for the frame
///  and the hinge parts.
///
//////////////////////////////////////////////////////////////////////////////////////
///
///  2015-01-08 Heinz Spiess, Switzerland
///
///  released under Creative Commons - Attribution - Share Alike licence (CC BY-SA)
//////////////////////////////////////////////////////////////////////////////////////

eh=0.25;  // extrusion layer height
ew=0.55;  // extrusion width

// build a cube with chamfered edges
module chamfered_cube(size,d=1){
   hull(){
     translate([d,d,0])cube(size-2*[d,d,0]);
     translate([0,d,d])cube(size-2*[0,d,d]);
     translate([d,0,d])cube(size-2*[d,0,d]);
   }
}


// build a cylinder with chamfered edges
module chamfered_cylinder(r=0,r1=0,r2=0,h=0,d=1){
   hull(){
      translate([0,0,d])cylinder(r1=(r?r:r1),r2=(r>0?r:r2),h=h-2*d);
      cylinder(r1=(r?r:r1)-d,r2=(r>0?r:r2)-d,h=h);
   }
}

//////////////////////////////////////////////////////////////////////
// build an arbitrary object from a list of blocks and cavities
//////////////////////////////////////////////////////////////////////
module object(blocks,cavities,eps=[0,0,0]){
   difference(){
      union()for(i=[0:len(blocks)-1])assign(b=blocks[i])
         translate(b[0])
	    if(b[1][0]>0)
	       if(len(b[1])>3)
	          chamfered_cube([b[1][0],b[1][1],b[1][2]],b[1][3]);
	       else
	          cube(b[1]);
	    else
	       rotate(90*[b[1][0]==-1?1:0,b[1][0]==-2?1:0,0])
	       cylinder(r=b[1][1],h=b[1][2],$fn=(len(b)>2?b[2]:0));
      for(i=[0:len(cavities)-1])assign(c=cavities[i])
         translate(c[0])
	    if(c[1][0]>0)
	       translate([-eps])cube(c[1]+2*eps);
	    else
	       rotate(90*[c[1][0]==-1?1:0,c[1][0]==-2?1:0,0])
	       cylinder(r=c[1][1],h=c[1][2],$fn=(len(c)>2?c[2]:0));
   }
}


//////////////////////////////////////////////////////////////////////
// Frame for Smart Full Graphic 12864 LCD Controller 
//////////////////////////////////////////////////////////////////////
module smartlcd12864(
w=4,              // wall thickness
s=[4,7.2,5],      // screw [screw diameter,nut size, nut height]
eps=[0.1,0.1,0] // gap for cavities
){

  blocks=[
      [[-w,-w,0],[94+2*w,88+2*w,17,1]],  // just one outer block
  ];
   cavities=[
      [[7.75,28,-2],[78.5,51.2,19]],    // LCD cutout
      [[7.5,28,3],[78.5,60,19]],        // LCD cutout
      [[0,26,3],[94,52,9+10]],          // LCD side insulation
      [[0,0,12.5],[94,88,5+14]],        // Main PCB
      [[0,16,8],[94,72,5+14]],          // Main PCB
      [[83.5,8.8,-2],[0,8/2,19]],       // Switch axis
      [[83.5-7,8.8-6,5],[14,14,19]],    // Switch block
      [[66,9.5,1],[0,13.5/2,19]],       // buzzer
      [[66,9.5,-1],[0,5/2,19]],         // buzzer
      [[50.2,9.2,-2],[0,2,19]],         // reset switch
      [[9.5,13,-2],[0,2.4,19]],         // contrast trimpot
      [[5,8,3],[73,20.5,16]],           // buzzer/switch/reset
      [[40,0,3],[38,18.5,16]],          // buzzer/switch/reset
      [[12,15,3],[55,15,9]],            // LCD pin header
      [[-w-1,39.5,13],[w+2,27,10]],     // SD slot
      [[-w-1,s[0]/2,8],[-2,s[0]/2,41+2*w+2],7],     // hinge hole
      [[w,s[0]/2,8],[-2,s[1]/2/cos(30),s[2]],6],    // hinge nut trap
      [[w,s[0]/2,12],[-2,s[1]/2/cos(30),s[2]],6],   // hinge nut trap
      [[w,s[0]/2,16],[-2,s[1]/2/cos(30),s[2]],6],   // hinge nut trap
      [[30-w,s[0]/2,8],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[30-w,s[0]/2,12],[-2,s[1]/2/cos(30),s[2]],6],// hinge nut trap
      [[30-w,s[0]/2,16],[-2,s[1]/2/cos(30),s[2]],6],// hinge nut trap
      [[94/2-89/2+1,53.2-65/2,3],[0,2.5/2,6],6],    // Screw hole for PCB
      [[94/2+89/2,53.2-65/2,3],[0,2.5/2,6],6],      // Screw hole for PCB
      [[94/2+89/2,53.2+65/2,3],[0,2.5/2,6],6],      // Screw hole for PCB
      [[94/2-89/2+1,53.2+65/2,3],[0,2.5/2,6],6],    // Screw hole for PCB
      [[13,-w/2,2],[2,88+w,14.5]],              // Anti-Warping
      [[76.5,-w/2,2],[2,88+w,14.5]],              // Anti-Warping
      [[-w/2,77,2],[94+w,2,15]],              // Anti-Warping
      [[-w/2,15,2],[94+w,2,15]],              // Anti-Warping
  ];

    
  scale([1,-1, 1])object(blocks,cavities,eps);
}

//////////////////////////////////////////////////////////////////////
// Frame for Smart 2004 LCD Controller 
//////////////////////////////////////////////////////////////////////
module smartlcd2004(
w=4,              // wall thickness
s=[4,7.2,5],      // screw [screw diameter,nut size, nut height]
eps=[0.1,0.1,0] // gap for cavities
){

  blocks=[
      [[-w,-w,0],[151+2*w,63.5+2*w,16,1]]  // just one outer block
  ];
   cavities=[
      [[14.5,10,-2],[97,40,19]],    // LCD cutout
      [[14,-0.25,4],[98.5,60.5,9+10]],  // LCD PCB
      [[0,7.75,8],[151,56,5+14]],    // Main PCB
      [[137,35,-2],[0,8/2,19]],     // Switch axis
      [[130+12.5/2,8+39+12.5/2,-2],[0,12.5/2,19]],     // buzzer
      [[137,16,-2],[0,2,19]],      // reset switch
      [[116,8,2],[29,55.5,10]],     // buzzer/switch/reset
      [[118,18,2],[33,35.5,10]],    // buzzer/switch/reset
      [[0,18,2],[11,35.5,10]],    // buzzer/switch/reset
      [[-w-1,17,9],[w+2,27,10]],    // SD slot
      [[-w-1,s[0]/2,8],[-2,s[0]/2,151+2*w+2],7], // hinge hole
      [[w,s[0]/2,8],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[w,s[0]/2,12],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[w,s[0]/2,16],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[151-w-s[2],s[0]/2,8],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[151-w-s[2],s[0]/2,12],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[151-w-s[2],s[0]/2,16],[-2,s[1]/2/cos(30),s[2]],6], // hinge nut trap
      [[0+2.9,8+2.5,3],[0,2.5/2,6],6],    // Screw hole for PCB
      [[151-2.7,8+2.5,3],[0,2.5/2,6],6],  // Screw hole for PCB
      [[0+2.9,8+55.5-2.5,3],[0,2.5/2,6],6],    // Screw hole for PCB
      [[151-2.7,8+55.5-2.5,3],[0,2.5/2,6],6],    // Screw hole for PCB
      [[14.5+8,60-5,2],[42,8.5,9]],              // LCD pin header
      [[50,-w/2,2],[2,55.5+8+w,11]],              // Anti-Warping
      [[90,-w/2,2],[2,55.5+8+w,11]],              // Anti-Warping
  ];

    
  scale([1,-1, 1])object(blocks,cavities,eps);
}

//////////////////////////////////////////////////////////////////////
// Frame hinge for Smart 2004 LCD Controller 
//////////////////////////////////////////////////////////////////////

module hinge(
fix=false,          // construct fixed part of hinge
move=false,         // construct moving part of hinge
draw=false,         // put movable part at end position for drawing (not for printing!)
off=[36,32],        // center offset in X/Y direction
l=25,               // length of LCD hinge
s=[4,7,5,8,5],      // LCD mounting screw [screw diameter,nut diameter,nut height,spring diameter, spring length]
h=16,               // hight 
w=8,                // wall thickness
m3r=3.5/2,          // screw radius for mounting frame hinge
eps=0               // gap between fitting fixed and moving part
){

//  moving part
if(move){
   // drawing or printing position?
   translate([0,0,w])rotate([draw?180:0,0,0])translate([0,0,-w])

   difference(){
      union(){
         hull(){
	    // construct basic form of moving part
	    chamfered_cylinder(r=off[1]-h+eps,h=w);
            translate([-off[0]-eps,-off[1]+h-2+eps,0])chamfered_cube([off[0]+3,4,w]);
	 }
	 // lock for 90 degrees max angle
	 rotate(-45)intersection(){
	    chamfered_cylinder(r=off[1]-h+5+eps,h=w);
	    cube([off[1]+6,off[1]+6,w]);
	 }
	 // smooth out locking part at negative end
	 rotate(45)translate([0,-7,0])chamfered_cylinder(r=off[1]-h-2,h=w);
	 // block for LCD-side hinge
         translate([-off[0],-off[1],0])chamfered_cube([l,h,h]);
      }
      // hole for LCD mounting spring
      translate([-off[0],-off[1]+h/2,h/2])rotate([0,90,0])
         translate([0,0,l-s[4]])rotate(30)cylinder(r=s[3]/2/cos(30),h=s[4]+1,$fn=6);
      // hole for LCD mounting screw 
      translate([-off[0]-1,-off[1]+h/2,h/2])rotate([0,90,0])
         rotate(30)cylinder(r=s[0]/2,h=l+2,$fn=6);
      // clip grooves at 0 and 90 degrees
      for(a=[0,90])rotate(a)translate([-off[0],0,w+1])rotate([0,90,0])cylinder(r=2,h=2*off[0],$fn=6);
      // hole for frame side pivot screw
      translate([0,0,w/2+eh])cylinder(r=s[0]/2,h=w+2);
      // hole for frame side pivot spring
      translate([0,0,-1])cylinder(r=s[3]/cos(30)/2,h=1+w/2,$fn=6);
   }

}

// fixed part for mounting on printer frame
if(fix){
   difference(){
      // main body of fixed part is a
      // rectangular block with rounded corners
      hull()
         translate([-off[1]+h/2+off[0],-off[1]/2+h/2,0])
            for(sx=[-1,1])for(sy=[-1,1])
               translate([sx*(off[0]-h/2-s[1]),sy*(off[1]-h/2-s[1]),0])
	          chamfered_cylinder(r=s[1],h=h-w+3);

      // hole for pivoting screw
      translate([0,0,s[2]+eh])cylinder(r=s[0]/2,h=h,$fn=12);
      // nut cavity for pivot screw
      translate([0,0,-1])cylinder(r=s[1]/cos(30)/2,h=1+s[2],$fn=6);
      // subract moving part in 0 and 90 degrees position and with adequate gap
      for(a=[0,90])rotate(a)hinge(move=true,draw=true,eps=0.3);

      // holes for the 4 frame mounting screws
      translate([-off[1]+h/2+off[0],-off[1]/2+h/2,0])
         for(sx=[-1,1])for(sy=[-1,1])
            translate([sx*(off[0]-h/2-s[1]),sy*(off[1]-h/2-s[1]),-1]){
	       cylinder(r=m3r,h=h+2);
	       translate([0,0,4+0.01])cylinder(r1=m3r,r2=2*m3r,h=2*m3r);
	       translate([0,0,4+2*m3r])cylinder(r=2*m3r,h=h);
	    }
      }
   }

}

// draw the LCD frame and the hinge in operating position with give
// rotation angles for both hinges
module drawAll(a1=90,a2=30,graph=false){
   hinge(fix=true);
   rotate(a1){
      color("green")for(a=[0])rotate(a)hinge(move=true,draw=true);
      translate([-40,30,0])rotate([0,0,180])translate(-[8,-7,-8])
         rotate([a2,0,0])
           translate([8,2,-8]) color("red"){
	      if(graph) smartlcd12864();
	      if(!graph)smartlcd2004();
           }
   }
}

//  Automatic generation of STL files by Makefile
module Frame_SmartLCD2004(){  // AUTO_MAKE_STL
   smartlcd2004();
}

module Frame_SmartLCD12864(){  // AUTO_MAKE_STL
   smartlcd12864();
}

module Hinge_SmartLCD2004_Right(){  // AUTO_MAKE_STL
   translate([80,0,0])hinge(move=true);
   hinge(fix=true);
}

module Hinge_SmartLCD2004_Left(){  // AUTO_MAKE_STL
   scale([1,-1,1]){
     translate([80,0,0])hinge(move=true);
     hinge(fix=true);
   }
}

//////////////////////////////////////////////////////////////////////////////////////
// For interactive use of OpenScad uncomment and modify the following lines as needed:
//////////////////////////////////////////////////////////////////////////////////////

//smartlcd2004();
smartlcd12864();

//drawAll(a1=90,a2=-90);
//drawAll(a1=60,a2=-75);
//drawAll(a1=30,a2=-45);
//drawAll(a1=0,a2=-15);
translate([80,50,0])hinge(move=true);
translate([0,50,0])hinge(fix=true);
//color("green")for(a=[0])rotate(a)hinge(move=true,draw=true);

// tf=200;drawAll(a1=max(0,90-$t*tf),a2=-90+(($t*tf)>90?$t*tf-90:0),graph=true); // animation!!!
