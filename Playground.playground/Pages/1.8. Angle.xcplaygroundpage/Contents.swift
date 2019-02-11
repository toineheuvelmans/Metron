import CoreGraphics
import Metron

/*: Angle
 # Angle
 An `Angle` in two-dimensional space, either expressed
 in radians or degrees.
 */

/// The default initializer uses radians to represent the angle
let angle1 = Angle(.pi / 2.0)

angle1.value
angle1.unit

/// You can also use degrees. The angle value is only converted
/// to radians when needed (e.g. when calling a trigonometric function).
let angle2 = Angle(90, unit: .degrees)

angle2.value
angle2.unit

angle1.radians
angle1.degrees
angle1.asUnit(.radians)
angle1.asUnit(.degrees)

angle1.inversed

let angle3 = Angle(.pi * -5)
angle3.normalized
angle3.inversed

//  Equatable / Comparable
angle1 == angle2    //  value is the same, regardless of unit
angle1 === angle2   //  value and unit must be the same

angle3 > angle1
angle3.normalized > angle1

//  Arithmetic functions

angle1 + angle2
angle1 - angle2
angle1 * 3
angle1 / 2

//  Trigonomtric functions

sin(angle1)
cos(angle1)
tan(angle1)

let a1: Angle = asin(1)
let a2: Angle = acos(1)
let a3: Angle = atan(1)
let a4: Angle = atan2(10, 2)

//  Convenience

Angle.fullRotation(unit: .radians)
Angle.fullRotation(unit: .degrees)

let t = CGAffineTransform(rotationAngle: angle1)

//: ---

//: [BACK: Corner](@previous)     |     [NEXT: CoordinateSystem](@next)
