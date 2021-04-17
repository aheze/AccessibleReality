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
 
For the last lesson in this playground, we'll visit the spectacular world of angles! While they might be hard to grasp, especially in 3 dimensions, we have Swift to help us out.
 
 The distance formula, which we covered in the last lesson, will be very valuable for informing the user about their surroundings. However, while they'll know how far they are from a node, they won't know its *direction*.
 
 This is where angles come in. If the app showed the *angle* between the device's direction and the node, the distance would be even more useful.
 
 ![Diagram showing the device 30 degrees 128 cm away from a node](AngleDiagram)
 
 Once again, we'll use `cameraNode` to represent the user's device, and `cubeNode` as the node. However, we have one more thing to consider: the camera's `rotation`. Just like `position`, this takes in a `Value`. Try playing with the sliders in the Live View!
 
 You'll notice a blue sphere that sticks a fixed distance to the camera (tap the ![Question mark icon](QuestionMark) to see the code that does this). The reason for this is because, well, angles are *hard*. It's already hard enough to wrap our heads 1 angle. But to calculate the camera's rotation (which is pretty much an angle relative to the origin) and also the angle to `cubeNode`... it can be overwhelming. Instead, we can think of the desired angle as the **angle between the sphere and node, with the vertex at the camera**.
 
 ![Diagram showing the camera (V), cube node (1), and sphere node (2)](AnglePositionsDiagram)
 
Once we got that down, let's use the Dot Product to find that angle! We can calculate this in 2 ways: by using the cosine and each ray's lengths, or with the `x` and `y` coordinates of the nodes (relative to the vertex).
 
 ![](DotProductsDiagram)
 
 We can then rearrange the terms to get the 3D angle equation:
 
 ![](AngleEquationDiagram)
 
 ... which we will now make in Swift!
 
 * callout(Built-in functions):
     We'll use Darwin's `acos(_:)` function, which takes the arccos of a number. For example:
     - `acos(0)` equals `0`
     - `acos(0.707)` equals `45`
 
*/
//#-hidden-code
PlaygroundPage.current.liveView = instantiateThreeMainView { (cameraNode, cubeNode, directionNode) in

//#-end-hidden-code
func angle3D(vertex: Value, position1: Value, position2: Value) -> Number {
    let vector1 = Value(
        x: position1.x - vertex.x,
        y: position1.y - vertex.y,
        z: position1.z - vertex.z
    )
    let vector2 = Value(
        x: /*#-editable-code X coordinate*/<#T##Value#>/*#-end-editable-code*/.x - vertex.x,
        y: /*#-editable-code Y coordinate*/<#T##Value#>/*#-end-editable-code*/.y - vertex.y,
        z: /*#-editable-code Z coordinate*/<#T##Value#>/*#-end-editable-code*/.z - vertex.z
    )
    
    let xProduct = vector1.x * vector2.x
    let yProduct = vector1.y * vector2.y
    let zProduct = vector1.z * vector2.z

    let dotProduct = /*#-editable-code Number*/<#Number#>/*#-end-editable-code*/ + /*#-editable-code Number*/<#Number#>/*#-end-editable-code*/ + /*#-editable-code Number*/<#Number#>/*#-end-editable-code*/
    let vertexToPosition1 = distanceFormula3D(position1: vertex, position2: position1) // using our own 3D Distance Formula!
    let vertexToPosition2 = distanceFormula3D(position1: vertex, position2: position2)

    let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
    let angle = acos(/*#-editable-code Number*/<#Number#>/*#-end-editable-code*/)
    return angle
}
    
// Call the function here!
let angle = angle3D(vertex: cameraNode.position, position1: cubeNode.position, position2: directionNode.position)
//#-hidden-code
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
/*:
Once you've filled in the placeholders, tap **Run My Code**!
*/
