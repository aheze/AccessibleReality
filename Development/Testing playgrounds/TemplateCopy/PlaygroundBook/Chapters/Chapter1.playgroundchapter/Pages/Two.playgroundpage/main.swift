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
 **Lesson 2**
 # The Distance Formula (but 3D)
 
Ah, the old algebra days! Remember the Distance Formula? Hopefully... but anyway, it lets you find the distance between two points. Here's what it looks like:
 
 P:
 
 ![](Position)
 
 
That was for 2D points. But guess what? It works great for 3D points too!
 
 ![](Position)
 
 
 
 
 Each object is called a `Node` and contains several properties, including `position`. You'll pass in a `Value` of (x, y, z) for this. For example, here's the code for the red cube in the live view:
 
     let cubeNode = Node()
     cubeNode.shape = .cube
     cubeNode.color = UIColor.red
     cubeNode.position = Value(x: 0, y: 0, z: 0)
     sceneView.scene?.addNode(cubeNode)
     
 
 Try adjusting the sliders!
 
 # Hit-Testing
 
 Sometimes we want to convert on-screen coordinates (x, y) into ARKit coordinates (x, y, z). This is especially useful when you want to position a node at where you tapped the screen. To do this, we can use "Hit-Testing."
 
 How does this work? Imagine an invisible beam of light that fires from your finger tap. This beam pierces through screen, travels into the ARKit scene, and *hits* the 3D coordinate plane. ARKit will tell you the exact point (x, y, z) where the collision happened!
 
 Below, use the `hitTest(at:)` function's return value to place a node at the crosshair's point.
*/
//#-hidden-code
PlaygroundPage.current.liveView = instantiateTwoMainView { (sceneView) in
//#-end-hidden-code
func distanceFormula3D(position1: Value, position2: Value) {
let cubeNode = Node()
cubeNode.shape = .cube
cubeNode.color = UIColor.red
cubeNode.position = Value(x: 0, y: 0, z: 0)
sceneView.scene?.addNode(cubeNode)

let cameraNode = Node()
cameraNode.shape = .pyramid
cameraNode.color = UIColor.black
cameraNode.position = Value(x: 50, y: 25, z: 25)
sceneView.scene?.addNode(cameraNode)
    
func distanceFormula3D(position1: Value, position2: Value) {
    let xDifference = position1.x - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.x
    let yDifference = position1.y - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.y
    let zDifference = position1.z - /*#-editable-code cameraNode x coordinate*/<#T##Value#>/*#-end-editable-code*/.z

    let everythingInsideSquareRoot = pow(/*#-editable-code */<#T##Number#>/*#-end-editable-code*/, 2) + pow(<#T##Number#>, 2) + pow(<#T##Number#>, 2)
    let distance = sqrt(everythingInsideSquareRoot)
}
    

//#-hidden-code
return distance
}
func DistanceFormula3d(firstPoint: SCNVector3, secondPoint: SCNVector3) -> Float {
    let xDifference = firstPoint.x - secondPoint.x
    let yDifference = firstPoint.y - secondPoint.y
    let zDifference = firstPoint.z - secondPoint.z
    let insideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    
    return sqrt(insideSquareRoot)
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
/*:
Once you've filled in the placeholder, tap **Run My Code**!
*/
