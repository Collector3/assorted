// Techspray Brush Tail Cap
// Two cylinders at 45 degree offset angles from center (mirroed)
// with a block in the middle splitting them down
//
// Paste this into https://openjscad.org/ for viewing / STL export

function main() {
  brush_cap = difference(
    union(
      // Left
      difference(
        cylinder({d: 6, h: 8, center: false }),
        cylinder({d: 6, h: 8, center: false }).translate([-1, 0, 0])
      ).rotateY(15).translate([0, 0, 1.5]),
      // Right
      difference(
        cylinder({d: 6, h: 8, center: false }),
        cylinder({d: 6, h: 8, center: false }).translate([1, 0, 0])
      ).rotateY(-15).translate([0, 0, 1.5]),
      // Base cap
      cylinder({d: 10.0, h: 3.0, center: false })
    ),
    // Center clearing pin
    cylinder({d: 5.5, h: 10, center: false}).translate([0 ,0 ,2])
  );

  return brush_cap;
}
