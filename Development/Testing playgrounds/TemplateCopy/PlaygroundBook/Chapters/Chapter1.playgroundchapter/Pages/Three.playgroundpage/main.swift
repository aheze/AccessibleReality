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
 
Once we 
 
 
 `d` will equal the distance between 2 points `(x₁, y₁, z₁)` and `(x₂, y₂, z₂)`.
 
 In the completed project, we'll use this to show the user how far they are from a node. Coordinates in ARKit are *so accurate* that we can rely on them for real-life distances. For now, we'll use `cameraNode` to represent the user's device, and `cubeNode` as the node of interest.

 Let's make the 3D Distance Formula in Swift! We'll put it in a function so that we can reuse it easily. It will take in 2 parameters, one for the starting position and one for the ending, and `return` the resulting distance when done.
 
 * callout(Built-in functions):
     We'll use Foundation's `pow(_:_:)` function, which raises numbers to a power. For example:
     - `pow(3, 2)` raises `3` to the power of `2` — equals `9`
     - `pow(4, 3)` raises `4` to the power of `3` — equals `64`
 
     We also need Darwin's `sqrt(_:)` function, which takes the square root. For example:
     - `sqrt(9)` equals `3`
     - `sqrt(16)` equals `4`
*/
//#-hidden-code
PlaygroundPage.current.liveView = instantiateTwoMainView { (sceneView, slider1Value, slider2Value) in



let cubeNode = Node()
cubeNode.shape = .cube
cubeNode.color = UIColor.red
cubeNode.position = slider1Value
sceneView.scene?.addNode(cubeNode)

let cameraNode = Node()
cameraNode.shape = .pyramid
cameraNode.color = UIColor.darkGray
cameraNode.position = slider2Value
sceneView.scene?.addNode(cameraNode)
//#-end-hidden-code
func distanceFormula3D(position1: Value, position2: Value) -> Number {
    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, position1, position2)
    let xDifference = position1.x - /*#-editable-code X coordinate*/<#T##Value#>/*#-end-editable-code*/.x
    let yDifference = position1.y - /*#-editable-code Y coordinate*/<#T##Value#>/*#-end-editable-code*/.y
    let zDifference = position1.z - /*#-editable-code Z coordinate*/<#T##Value#>/*#-end-editable-code*/.z

    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, xDifference, yDifference, zDifference)
    let everythingInsideSquareRoot = pow(/*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/, 2) + pow(/*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/, 2) + pow(/*#-editable-code Number*/<#T##Number#>/*#-end-editable-code*/, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    print(distance)
    return distance
}
    
// Call the function here!
let distance = distanceFormula3D(position1: cubeNode.position, position2: cameraNode.position)
//#-hidden-code
    
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
/*:
Once you've filled in the placeholders, tap **Run My Code**!
*/
