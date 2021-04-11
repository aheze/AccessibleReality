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
                let distance = anchorPosition.distance(to: cameraPosition)
                let centimeters = Int(distance * 100)
                
                drawingView.bringSubviewToFront(infoView)
                
                var infoViewPoint = getMidOf(firstPoint: crosshairCenter, secondPoint: edgePoint)
                
                let distanceToCenter = DistanceFormula(from: crosshairCenter, to: infoViewPoint)
                if distanceToCenter < 100 {
                    
                    let yCutoff: CGFloat
                    
                    switch infoViewPosition {
                    case .aboveCenter:
                        yCutoff = crosshairCenter.y - 10
                    case .belowCenter:
                        yCutoff = crosshairCenter.y + 10
                    case .floating:
                        yCutoff = crosshairCenter.y
                    }
                    
                    if infoViewPoint.y < yCutoff {
                        infoViewPoint = CGPoint(x: crosshairCenter.x, y: crosshairCenter.y + 70)
                        self.infoViewPosition = .belowCenter
                    } else if infoViewPoint.y > yCutoff {
                        infoViewPoint = CGPoint(x: crosshairCenter.x, y: crosshairCenter.y - 70)
                        self.infoViewPosition = .aboveCenter
                    }
                } else {
                    self.infoViewPosition = .floating
                }
                
                UIView.animate(withDuration: 0.2) {
                    self.infoView.alpha = 1
                    self.infoView.center = infoViewPoint
                    self.infoView.transform = CGAffineTransform.identity
                }
                distanceLabel?.text = "\(centimeters) cm"
                
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


extension SCNVector3 {
     func distance(to vector: SCNVector3) -> Float {
         return simd_distance(simd_float3(self), simd_float3(vector))
     }
 }
