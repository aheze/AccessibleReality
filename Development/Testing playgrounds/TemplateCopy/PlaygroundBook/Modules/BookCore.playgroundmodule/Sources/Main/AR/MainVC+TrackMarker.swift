//
//  MainVC+TrackMarker.swift
//  BookCore
//
//  Created by Zheng on 4/6/21.
//

import SwiftUI
import ARKit

extension MainViewController {
    func trackCurrentMarker() {
        if let currentTrackingMarker = cvm.selectedCard?.marker {
            let anchorPosition = SCNVector3(
                currentTrackingMarker.anchor.transform.columns.3.x,
                currentTrackingMarker.anchor.transform.columns.3.y,
                currentTrackingMarker.anchor.transform.columns.3.z
            )
            let projectedVector = sceneView.projectPoint(anchorPosition)
            let projectedPoint = CGPoint(x: CGFloat(projectedVector.x), y: CGFloat(projectedVector.y))
            
            
            let path = UIBezierPath()
            path.move(to: crosshairCenter)
            path.addLine(to: projectedPoint)
            
            /// add lineLayer if nil
            if lineLayer == nil {
                path.lineCapStyle = .round
                let lineLayer = CAShapeLayer()
                lineLayer.path = path.cgPath
                lineLayer.lineWidth = 3
                
                drawingView.layer.addSublayer(lineLayer)
                self.lineLayer = lineLayer
            }
            
            self.lineLayer?.path = path.cgPath
            
            let edgePoint: CGPoint
            let edgePointFrame: CGRect
            if let intersection = drawingView.bounds.intersection(with: LineSegment(point1: crosshairCenter, point2: projectedPoint)) {
                edgePoint = intersection
                edgePointFrame = CGRect(origin: intersection, size: CGSize(width: 10, height: 10)).insetBy(dx: -5, dy: -5)
            } else {
                edgePoint = projectedPoint
                edgePointFrame = CGRect(origin: projectedPoint, size: CGSize(width: 10, height: 10)).insetBy(dx: -5, dy: -5)
            }
            
            
            if let edgePointView = edgePointView {
                UIView.animate(withDuration: 0.1) {
                    edgePointView.frame = edgePointFrame
                }
            } else {
                let edgePointView = UIView()
                edgePointView.backgroundColor = .blue
                edgePointView.layer.cornerRadius = 5
                edgePointView.frame = edgePointFrame
                drawingView.addSubview(edgePointView)
                self.edgePointView = edgePointView
            }
             
            /// get distance from camera to cube
            if let cameraPosition = sceneView.pointOfView?.position {
                
                
                let distanceToBoxCenter = DistanceFormula3d(firstPoint: anchorPosition, secondPoint: cameraPosition)
                let distanceToBoxEdge = distanceToBoxCenter - currentTrackingMarker.radius
                
                
                let edgeCentimeters = Int(distanceToBoxEdge * 100)
                let adjustedCentimeters = max(0, edgeCentimeters - 10) /// prevent going below 0
                
                drawingView.bringSubviewToFront(infoView)
                
                var infoViewPoint = getMidOf(firstPoint: crosshairCenter, secondPoint: edgePoint)
                
                let distanceToCenter = DistanceFormula(from: crosshairCenter, to: infoViewPoint)
                if distanceToCenter < 100 {
                    infoViewPoint = CGPoint(x: crosshairCenter.x, y: crosshairCenter.y - 70)
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.infoView.alpha = 1
                    self.infoView.center = infoViewPoint
                    self.infoView.transform = CGAffineTransform.identity
                }
                
                distanceLabel?.text = "\(adjustedCentimeters)cm"
                
                if let cameraTransform = sceneView.pointOfView?.transform {
                    let cameraProjectedPosition = projectedForwardsPosition(from: simd_float4x4(cameraTransform))
                    
                    let angle = Angle3d(vertex: cameraPosition, firstPoint: cameraProjectedPosition, secondPoint: anchorPosition)
                    let angleInDegrees = angle.radiansToDegrees
                    
                    let compassText = getAngleText(between: crosshairCenter, and: edgePoint)
                    degreesLabel.text = "\(Int(angleInDegrees))°\(compassText)"
                }
                
            }
        } else {
            /// remove line
            lineLayer?.removeFromSuperlayer()
            lineLayer = nil
            edgePointView?.removeFromSuperview()
            edgePointView = nil
            
            UIView.animate(withDuration: 0.2) {
                self.infoView.alpha = 0
                self.infoView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }
        }
    }
    
    func getMidOf(firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        let xCoordinate = (firstPoint.x + secondPoint.x) / 2
        let yCoordinate = (firstPoint.y + secondPoint.y) / 2
        return CGPoint(x: xCoordinate, y: yCoordinate)
    }
    
}

func DistanceFormula3d(firstPoint: SCNVector3, secondPoint: SCNVector3) -> Float {
    let xDifference = firstPoint.x - secondPoint.x
    let yDifference = firstPoint.y - secondPoint.y
    let zDifference = firstPoint.z - secondPoint.z
    let insideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    
    return sqrt(insideSquareRoot)
}


func Angle3d(vertex: SCNVector3, firstPoint: SCNVector3, secondPoint: SCNVector3) -> Float {
    let firstVector = SCNVector3(
        firstPoint.x - vertex.x,
        firstPoint.y - vertex.y,
        firstPoint.z - vertex.z
    )
    
    let secondVector = SCNVector3(
        secondPoint.x - vertex.x,
        secondPoint.y - vertex.y,
        secondPoint.z - vertex.z
    )
    
    let xProduct = firstVector.x * secondVector.x
    let yProduct = firstVector.y * secondVector.y
    let zProduct = firstVector.z * secondVector.z

    // a · b = ax · bx + ay · by + az · bz
    let dotProduct = xProduct + yProduct + zProduct

    let lengthToFirstPoint = DistanceFormula3d(firstPoint: vertex, secondPoint: firstPoint)
    let lengthToSecondPoint = DistanceFormula3d(firstPoint: vertex, secondPoint: secondPoint)
    // a · b = |a| · |b| · cos(θ)
    // dotProduct = lengthToFirstPoint * lengthToSecondPoint * cos(θ)
    let cosineOfAngle = dotProduct / (lengthToFirstPoint * lengthToSecondPoint)
    
    let angle = acos(cosineOfAngle)

    return angle
}

func updatePositionAndOrientationOf(_ node: SCNNode, withPosition position: SCNVector3, relativeTo referenceNode: SCNNode) {
    let referenceNodeTransform = matrix_float4x4(referenceNode.transform)
    
    /// Setup a translation matrix with the desired position
    var translationMatrix = matrix_identity_float4x4
    translationMatrix.columns.3.x = position.x
    translationMatrix.columns.3.y = position.y
    translationMatrix.columns.3.z = position.z
    
    /// Combine the configured translation matrix with the referenceNode's transform to get the desired position AND orientation
    let updatedTransform = matrix_multiply(referenceNodeTransform, translationMatrix)
    node.transform = SCNMatrix4(updatedTransform)
}

func projectedForwardsPosition(from transform: matrix_float4x4) -> SCNVector3 {
    
    var translationForwardsMatrix = matrix_identity_float4x4
    translationForwardsMatrix.columns.3.x = 0
    translationForwardsMatrix.columns.3.y = 0
    translationForwardsMatrix.columns.3.z = -1  /// 1 meter in front
    
    let combinedTransform = matrix_multiply(transform, translationForwardsMatrix)
    
    let newPosition = SCNVector3(
        x: combinedTransform.columns.3.x,
        y: combinedTransform.columns.3.y,
        z: combinedTransform.columns.3.z
    )
    
    return newPosition
    
}

func getAngleText(between center: CGPoint, and point: CGPoint) -> String {
    let xDifference = point.x - center.x
    let yDifference = point.y - center.y
    let angleInRadians = atan2(yDifference, xDifference)
    
    /// originally 0 is x axis, add 360 to prevent negatives
    let angleInDegrees = angleInRadians.radiansToDegrees + 90 + 360
    
    
    let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    let index = Int((angleInDegrees / 45).rounded()) % 8
    
    if directions.indices.contains(index) {
        let direction = directions[index]
        return direction
    }
    
    return "N"
}
