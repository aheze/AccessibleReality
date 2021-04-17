//
//  Utilities.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import UIKit

extension UIViewController {
    func addChildViewController(_ childViewController: UIViewController, in inView: UIView, atTop: Bool = false) {
        /// Add Child View Controller
        addChild(childViewController)
        
        if atTop {
            /// Add Child View as Subview
            inView.addSubview(childViewController.view)
        } else {
            inView.insertSubview(childViewController.view, at: 0)
        }
        
        /// Configure Child View
        childViewController.view.frame = inView.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        /// Notify Child View Controller
        childViewController.didMove(toParent: self)
    }
}


/// degrees to radians helper function
/// from https://stackoverflow.com/a/29179878/14351818
extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}



/// get intersection between rect and line
/// from https://stackoverflow.com/a/42144884/14351818
struct LineSegment {
    var point1: CGPoint
    var point2: CGPoint

    func intersection(with line: LineSegment) -> CGPoint? {
        // We'll use Gavin's interpretation of LeMothe:
        // https://stackoverflow.com/a/1968345/97337

        let p0_x = self.point1.x
        let p0_y = self.point1.y
        let p1_x = self.point2.x
        let p1_y = self.point2.y

        let p2_x = line.point1.x
        let p2_y = line.point1.y
        let p3_x = line.point2.x
        let p3_y = line.point2.y

        let s1_x = p1_x - p0_x
        let s1_y = p1_y - p0_y
        let s2_x = p3_x - p2_x
        let s2_y = p3_y - p2_y

        let denom = (-s2_x * s1_y + s1_x * s2_y)

        // Make sure the lines aren't parallel
        guard denom != 0 else { return nil } // parallel

        let s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / denom
        let t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / denom

        // We've parameterized these lines as "origin + scale*vector"
        // (s is the "scale" along one line, t is the "scale" along the other.
        // At scale=0, we're at the origin at scale=1, we're at the terminus.
        // Make sure we crossed between those. For more on what I mean by
        // "parameterized" and why we go from 0 to 1, look up Bezier curves.
        // We're just making a 1-dimentional Bezier here.
        guard (0...1).contains(s) && (0...1).contains(t) else { return nil }

        // Collision detected
        return CGPoint(x: p0_x + (t * s1_x), y: p0_y + (t * s1_y))
    }
}

extension CGRect {
    var edges: [LineSegment] {
        return [
            LineSegment(point1: CGPoint(x: minX, y: minY), point2: CGPoint(x: minX, y: maxY)),
            LineSegment(point1: CGPoint(x: minX, y: minY), point2: CGPoint(x: maxX, y: minY)),
            LineSegment(point1: CGPoint(x: minX, y: maxY), point2: CGPoint(x: maxX, y: maxY)),
            LineSegment(point1: CGPoint(x: maxX, y: minY), point2: CGPoint(x: maxX, y: maxY)),
        ]
    }

    func intersection(with line: LineSegment) -> CGPoint? {

    // Let's be super-simple here and require that one point be in the box and one point be outside,
    // then we can ignore lots of corner cases
        guard contains(line.point1) && !contains(line.point2) ||
            contains(line.point2) && !contains(line.point1) else { return nil }

        // There are four edges. We might intersect with any of them (we know
        // we intersect with exactly one, based on the previous guard.
        // We could do a little math and figure out which one it has to be,
        // but the `if` would be really tedious, so let's just check them all.
        for edge in edges {
            if let p = edge.intersection(with: line) {
                return p
            }
        }

        return nil
    }
}

/// distance formula
/// from https://www.hackingwithswift.com/example-code/core-graphics/how-to-calculate-the-distance-between-two-cgpoints
func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
}

func DistanceFormula(from: CGPoint, to: CGPoint) -> CGFloat {
    return sqrt(CGPointDistanceSquared(from: from, to: to))
}

/// get color with different brightness
/// from https://stackoverflow.com/a/42381754/14351818
extension UIColor {
  /**
   Create a lighter color
   */
  func lighter(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: abs(percentage))
  }

  /**
   Create a darker color
   */
  func darker(by percentage: CGFloat = 30.0) -> UIColor {
    return self.adjustBrightness(by: -abs(percentage))
  }

  /**
   Try to increase brightness or decrease saturation
   */
  func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
    var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
    if self.getHue(&h, saturation: &s, brightness: &b, alpha: &a) {
      if b < 1.0 {
        let newB: CGFloat = max(min(b + (percentage/100.0)*b, 1.0), 0.0)
        return UIColor(hue: h, saturation: s, brightness: newB, alpha: a)
      } else {
        let newS: CGFloat = min(max(s - (percentage/100.0)*s, 0.0), 1.0)
        return UIColor(hue: h, saturation: newS, brightness: b, alpha: a)
      }
    }
    return self
  }
}


public func pow(_ x: Number, _ y: Int) -> Number {
    let xDecimal = Decimal(Double(x))
    let result = pow(xDecimal, y)
    let doubleResult = Double(truncating: result as NSNumber)
    
    return Number(doubleResult)
}
//public s
public func sqrt(_ number: Number) -> Number {
    let result = sqrt(Double(number))
    return Number(result)
}

extension Number {
    static func + (left: Number, right: Number) -> Number {
        let result = Double(left) + Double(right)
        return Number(result)
    }
}
extension Number {
    static func * (left: Number, right: Number) -> Number {
        let result = Double(left) * Double(right)
        return Number(result)
    }
}
extension Number {
    static func / (left: Number, right: Number) -> Number {
        let result = Double(left) / Double(right)
        return Number(result)
    }
}

