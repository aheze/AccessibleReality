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


/*
Hey there! Augmented Reality is a challenging topic, so let's break it down first.

As humans, we live in the real world: a place where we can walk around, see objects, and interact with them. The opposite of this would be the virtual world, which exists digitally and in our imagination. They are completely separate worlds, so it's impossible for a human to be in a video game, or a robot dragon to be in our backyard... at least, up until recently.

With the introduction of Apple's ARKit and similar frameworks, it's now very easy for anyone to make an AR experience. Want a backyard robot dragon? No problem. But besides for fun, ARKit is great for practical purposes. **In this playground, we'll be using ARKit to make a navigation guide for those the visually impaired.**

 */
//#-end-hidden-code

/*:
 **Lesson 1**
 # Positioning
 
Let's start by making sense of [ARKit](glossary://ARKit)'s coordinate system. At its core are the 3 axes: X, Y, and Z. Their directions depend on our perspective, but in general:
 
 - ![Red arrow pointing right](xArrow) X is right
 - ![Green arrow pointing up](yArrow) Y is up
 - ![Blue arrow pointing left](zArrow) Z is left
 
 Each object is called a `Node` and contains several properties, including `position`. We'll pass in a `Value` of (x, y, z) for this. For example, here's the code for the red cube in the live view:
 
     let cubeNode = Node()
     cubeNode.shape = .cube
     cubeNode.color = UIColor.red
     cubeNode.position = Value(x: 0, y: 0, z: 0)
     sceneView.scene?.addNode(cubeNode)
     
 
 Try adjusting the sliders!
 
 # Hit-Testing
 
 Sometimes we want to convert on-screen coordinates (x, y) into ARKit coordinates (x, y, z). This is especially useful when you want to position a node at where you tapped the screen. To do this, we can use "Hit-Testing."
 
 How does this work? Imagine an invisible beam of light that fires from your finger tap. This beam pierces through the screen, travels into the ARKit scene, and *hits* the 3D [coordinate plane](glossary://coordinate%20plane). ARKit will tell you the exact point (x, y, z) where the collision happened!
 
 Below, use the `hitTest(at:)` function's [return value](glossary://return%20value) to place a node at the crosshair's point.
*/
//#-hidden-code
PlaygroundPage.current.liveView = instantiateOneMainView { (sceneView, crosshairPoint) in
//#-end-hidden-code
if let hitPosition = sceneView.hitTest(at: crosshairPoint) {
    let newNode = Node()
//#-editable-code
    newNode.shape = .cube
    newNode.color = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    newNode.position = hitPosition
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
Tap **Run My Code**!
*/
