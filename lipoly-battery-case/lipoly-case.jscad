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
    
    // lieFlat() proritizes minimal Z height and is not always optimal for 3D printing 
    //flattenedBox = batteryBox.transform(batteryBox.getTransformationToFlatLying());
    //return flattenedBox.rotateY(-90);
    
    // Rotate into position for FDM printing, and move the distance from Z origin
    finalBox = batteryBox.rotateY(-90);
    deltaZ = finalBox.getBounds()[0].z
    
    return finalBox.translate([0, 0, -deltaZ]);
}
