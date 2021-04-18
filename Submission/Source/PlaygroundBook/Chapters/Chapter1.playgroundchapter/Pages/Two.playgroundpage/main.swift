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
 
Ah, the good old algebra days! Remember the Distance Formula? It lets us find the distance between two points:
 
 
 ![d=√((x₂-x₁)²+(y₂-y₁)²)](DistanceFormula2D)
 
 
To make it work for 3D points, all we need to do is add a section for the `z` coordinates.
 
 ![d=√((x₂-x₁)²+(y₂-y₁)²+(z₂-z₁)²)](DistanceFormula3D)
 
 In the completed project, we'll use this to show the user how far they are from a node — coordinates in ARKit are so accurate that we can rely on them for real-life distances.

 Let's code the 3D Distance Formula in Swift! We'll put it in a [function](glossary://function) so that we can reuse it easily. It will take in 2 [parameters](glossary://parameter), one for the starting position and one for the ending, and `return` the resulting distance when done.
 
 * Note:
     We'll use [Foundation](glossary://Foundation)'s `pow(_:_:)` function, which raises numbers to a power. For example:
     - `pow(3, 2)` raises `3` to the power of `2` — equals `9`
     - `pow(4, 3)` raises `4` to the power of `3` — equals `64`
 
     We also need [Darwin](glossary://Darwin)'s `sqrt(_:)` function, which gets the square root. For example:
     - `sqrt(9)` equals `3`
     - `sqrt(16)` equals `4`
 
 Once you've filled in the placeholders, tap **Run My Code**!
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
func distance3D(position1: Value, position2: Value) -> Number {
    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, position1, position2)
    // position2 - position1
    let xDifference = position2.x - /*#-editable-code X coordinate*/<#T##Value#>/*#-end-editable-code*/.x
    let yDifference = position2.y - /*#-editable-code Y coordinate*/<#T##Value#>/*#-end-editable-code*/.y
    let zDifference = position2.z - /*#-editable-code Z coordinate*/<#T##Value#>/*#-end-editable-code*/.z

    //#-code-completion(everything, hide)
    //#-code-completion(identifier, show, xDifference, yDifference, zDifference)
    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    print(distance)
    return distance
}
    
// Call the function here!
let distance = distance3D(position1: cubeNode.position, position2: cameraNode.position)
//#-hidden-code
return (cubeNode, cameraNode)
}

PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

