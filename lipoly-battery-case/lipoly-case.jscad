// Adafruit LiPoly Battery For Feathers (Protective Case)
var battLen     = 38;
var battWidth   = 17;
var battHeight  = 8;

var offset = 2;
var centerSetting = true;

function main() {
    var batteryBox = union(
        difference(
            difference(
                // LiPoly battery size, hollow container
                cube({size: [battLen+offset, 
                    battWidth+offset, battHeight+offset], center: centerSetting}),
                cube({size: [battLen, 
                    battWidth, battHeight], center: centerSetting})
            ),
            color("blue", cube({size: [2, battWidth+offset, 
                battHeight+offset], center: centerSetting}).translate([battLen/2,0,0])))
    );
    
    var layFlat = batteryBox.getTransformationToFlatLying();
    return batteryBox.transform(layFlat);
}