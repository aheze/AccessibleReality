//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//

import UIKit
import BookCore
import PlaygroundSupport

//#-end-hidden-code

/*:
 **Lesson 3**
 # Amazing Angles
 
For the last lesson in this playground, we'll visit the world of angles! The distance formula that we covered in the previous lesson lets the user know how far away they are from a node, but not their direction.
 
 This is where angles come in. If the app showed the *angle* between the device's direction and the node, the distance would be even more useful.
 
 ![Diagram showing the device 30 degrees 128 cm away from a node](AngleDiagram)
 
Try playing with the sliders in the Live View! You'll notice a blue sphere that sticks to the camera at a fixed distance (tap ![Question mark icon](QuestionMark) to see the code that does this). We can think of the desired angle as the angle between the cube and sphere, with the [vertex](glossary://vertex) at the camera.
 
 ![Diagram showing the camera (V), cube node (1), and sphere node (2)](AnglePositionsDiagram)
 
Now, let's use the [dot product](glossary://dot%20product) to find that angle! We can calculate this in 2 ways: by using the cosine and line segment lengths, or with the `x` and `y` coordinates of the nodes (relative to the vertex).
 
 ![](DotProductsDiagram)
 
 We can then rearrange the terms to get the 3D angle equation:
 
 ![](AngleEquationDiagram)
 
 …which we'll now make in Swift!
 
 * Note:
     We'll use [vForce](glossary://vForce)'s `acos(_:)` function, which gets the [arccos](glossary://arccos) of a number. For example:
     - `acos(0)` equals `1.57` radians (90°)
     - `acos(-1)` equals `3.14` radians (180°)
 
 Once you've filled in the placeholders, tap **Run My Code**!
*/
//#-hidden-code
PlaygroundPage.current.liveView = instantiateThreeMainView { (cameraNode, cubeNode, directionNode) in
func distance3D(position1: Value, position2: Value) -> Number {
    let xDifference = position1.x - position2.x
    let yDifference = position1.y - position2.y
    let zDifference = position1.z - position2.z

    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    
    return Number(distance)
}
//#-end-hidden-code
func angle3D(vertex: Value, position1: Value, position2: Value) -> Number {
    let vector1 = Value(
        x: position1.x - vertex.x,
        y: position1.y - vertex.y,
        z: position1.z - vertex.z
    )
    let vector2 = Value(
        x: position2.x - vertex.x,
        y: position2.y - vertex.y,
        z: position2.z - vertex.z
    )
    
    let xProduct = vector1.x * vector2.x
    let yProduct = vector1.y * vector2.y
    let zProduct = vector1.z * vector2.z
    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, xProduct, yProduct, zProduct)
    let dotProduct = /*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/ + /*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/ + /*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/ // X + Y + Z
    
    let vertexToPosition1 = distance3D(position1: vertex, position2: position1) // using our own 3D Distance Formula!
    let vertexToPosition2 = distance3D(position1: vertex, position2: position2)

    let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
    //#-code-completion(identifier, show, cosineOfAngle)
    let angle = acos(cosineOfAngle)
    let degrees = angle * 180 / .pi
    return degrees
}
    
// Call the function here!
let angle = angle3D(vertex: cameraNode.position, position1: cubeNode.position, position2: directionNode.position)
//#-hidden-code
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
