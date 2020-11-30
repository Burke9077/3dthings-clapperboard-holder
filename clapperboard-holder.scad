// Define the dimensions of the clapperboard holder
boxLength = 340;
boxDepthFromWall = 25;
boxHeight = 80;

/* Create the 2 clapperboard pieces! This design can be 
 * printed on a printer with a build area of 170mm like
 * the prusa mini. */
clapperboardHolderPieces(boxLength, boxDepthFromWall, boxHeight);

/* If your printer can print 340 mm on the x axis, you 
 * could uncomment this line instead: */
//clapperboardHolder(boxLength, boxDepthFromWall, boxHeight);

module clapperboardHolderPieces(boxLength, boxDepthFromWall, boxHeight) {
    // Create the left half of the clapperboard
    translate([boxLength/4,boxDepthFromWall*1,0]) {
        difference() {
            clapperboardHolder(boxLength, boxDepthFromWall, boxHeight);
            translate([boxLength/4,0,0]) {
                cube([boxLength/2,boxDepthFromWall,boxHeight], true);
            }
        }
    }

    // Create the right half of the clapperboard
    translate([boxLength/4*-1,boxDepthFromWall*-1,0]) {
        difference() {
            clapperboardHolder(boxLength, boxDepthFromWall, boxHeight);
            translate([boxLength/4*-1,0,0]) {
                color("Red", 1.0) cube([boxLength/2,boxDepthFromWall,boxHeight], true);
            }        
        }
    }
}

/* This is the main module that creates a full clapperboard object.
 * if your printer has a build area that can support 340mm then
 * you could call this module directly instead of cutting it in 2 */
module clapperboardHolder(boxLength, boxDepthFromWall, boxHeight) {
    // Clapperboard holder params

    /* How many screw holes do we want to add? Probably 3 if
     * you've got a big printer, but I don't... So I'll be splitting
     * this object into 2 and want 4 screw holes -- 2 for each side. */
    numberOfScrewHoles = 4;

    difference() {
        // Create main outer box (clapperboard holder)
        cube([boxLength,boxDepthFromWall,boxHeight], true);

        // Create cut out box that represents the clapperboard
        color("Chartreuse", 1.0) { // Add color so it's easier to debug
            translate([0,5,13]) {
                cube([320,4,boxHeight-25], true);
            }
        }

        // Add screw holes!

        // How much space should be between screw holes (center to center)?
        screwHoleSpacingBetweenCenters = boxLength/(1+numberOfScrewHoles);

        // Loop through and create screw holes
        for (i = [1 : numberOfScrewHoles]) {
            translate([(boxLength/2*-1) + (i*screwHoleSpacingBetweenCenters),0,-32]) {
                screwhole(boxDepthFromWall);
            }
        }

        /* Finally, this thing is too big for my printer so I'll need
         * to split it up. Add dowels to the center so we can easilly
         * align the seperate parts. */
        dowelYPosition = -5;
        translate([0,dowelYPosition,boxHeight*(1/4)]) {
            dowel();
        }
        translate([0,dowelYPosition,boxHeight*(1/4)*-1]) {
            dowel();
        }
    }
}
module dowel() {
    dowelMargin = 0.15;
    dowelLength = 30 + dowelMargin;
    dowelDiameter = 8.15 + dowelMargin;

    rotate([0,90,0]) {
        cylinder(h=dowelLength, d1=dowelDiameter, d2=dowelDiameter, center=true, $fn=10);
    }
}

module screwhole(screwLength) {
    // How long is just the head of the screw?
    // Note I'm using a standard drywall screw, most should work...
    screwHeadDepressionSize = 4;

    union() {
        rotate([90,0,0]) {
            cylinder(h=screwLength, d1=4, d2=4, center=true, $fn=10);
        }
        translate([0,(screwLength/2)-(screwHeadDepressionSize/2),0]) {
            rotate([270,0,0]) {
                cylinder(h=screwHeadDepressionSize, d1=4, d2=8.5, center=true, $fn=100);
            }
        }
    }
}
