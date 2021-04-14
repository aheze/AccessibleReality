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
 # The Distance Formula
 

 
 - X is right
 - Y is up
 - Z is left
 
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
PlaygroundPage.current.liveView = instantiateOneMainView { (sceneView, crosshairPoint) in
//#-end-hidden-code
if let hitPosition = sceneView.hitTest(at: crosshairPoint) {
    let newNode = Node()
//#-editable-code
    newNode.shape = .cube
    newNode.color = UIColor.red
    newNode.position = <#Value#>
//#-end-editable-code
    sceneView.scene?.addNode(newNode)
//#-hidden-code
return hitPosition
//#-end-hidden-code
} else {
    print("Out of bounds!")
}
//#-hidden-code
return nil
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code
/*:
Once you've filled in the placeholder, tap **Run My Code**!
*/
