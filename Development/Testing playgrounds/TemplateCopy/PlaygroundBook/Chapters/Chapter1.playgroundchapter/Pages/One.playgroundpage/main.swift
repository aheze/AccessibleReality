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
 **Lesson 1**
 # Positioning and Hit-Tests
 
 Hey there! Before we do anything complicated, we need to understand how ARKit's coordinate system works.
 
 Everything is determined by 3 axes: X, Y, and Z.
 
 - X is right
 - Y is up
 - Z is left
 

 
Run this puzzle, and notice how your character stops after the first gem. The algorithm used here follows the [right-hand rule](glossary://right-hand%20rule) to move around walls. To solve the puzzle, you’ll need to tweak the algorithm, but first try using [pseudocode](glossary://pseudocode) to plan the action.

Pseudocode looks a bit like [Swift](glossary://Swift) code, but it’s worded and structured so humans can easily understand it.
 
    navigate around wall {
       if blocked to the right {
          move forward
       } else {
          turn right
          move forward
       }
    }
 
    while not on closed switch {
       navigate around wall
       if on gem {
          collect gem
          turn around
       }
    }
    toggle switch
 
 1. steps: Based on the pseudocode above, write out a solution in code for the puzzle.
 2. Run your code and tweak your algorithm, if necessary, to solve the puzzle.
 
 1. Based on the pseudocode above, write out a solution in code for the puzzle.
 2. Run your code and tweak your algorithm, if necessary, to solve the puzzle.
*/

let str = "Hello, playground"

//#-hidden-code
//PlaygroundPage.current.liveView = instantiateLiveView()
//PlaygroundPage.current.needsIndefiniteExecution = true
//#-end-hidden-code

