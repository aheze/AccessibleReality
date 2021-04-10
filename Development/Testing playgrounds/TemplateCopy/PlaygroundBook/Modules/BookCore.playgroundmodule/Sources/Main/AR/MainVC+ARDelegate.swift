//
//  MainVC+ARDelegate.swift
//  BookCore
//
//  Created by Zheng on 4/4/21.
//

import UIKit
import ARKit

extension MainViewController: ARCoachingOverlayViewDelegate {
    func addCoaching() {
        
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.delegate = self
        coachingOverlay.session = sceneView.session
        coachingOverlay.goal = .anyPlane
        
        coachingReferenceView.addSubview(coachingOverlay)
        coachingReferenceView.isUserInteractionEnabled = false
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            coachingOverlay.topAnchor.constraint(equalTo: coachingReferenceView.topAnchor),
            coachingOverlay.rightAnchor.constraint(equalTo: coachingReferenceView.rightAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: coachingReferenceView.bottomAnchor),
            coachingOverlay.leftAnchor.constraint(equalTo: coachingReferenceView.leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        
        cardsReferenceView.isUserInteractionEnabled = false
        cardsReferenceView.alpha = 0
    }
    
    public func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = true
        cardsReferenceView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.4) {
            self.cardsReferenceView.alpha = 0
        }
    }
    public func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
        coachingViewActive = false
        cardsReferenceView.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 0.4) {
            self.cardsReferenceView.alpha = 1
        }
    }
}

extension MainViewController: ARSessionDelegate, ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if let marker = placedMarkers.first(where: {$0.anchor == anchor }) {
            let node = SCNNode(geometry: marker.box)
            return node
        }
        return nil
    }
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if busyProcessingImage == false && coachingViewActive == false {
            busyProcessingImage = true
            
            
            /// get coordinates converted to screen
            /// from https://stackoverflow.com/a/58817480/14351818
            let imageBuffer = frame.capturedImage

            let imageSize = CGSize(width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
            let viewPort = CGRect(origin: .zero, size: sceneViewSize)


            let interfaceOrientation = UIInterfaceOrientation.landscapeLeft

            let image = CIImage(cvImageBuffer: imageBuffer)

            // The camera image doesn't match the view rotation and aspect ratio
            // Transform the image:

            // 1) Convert to "normalized image coordinates"
            let normalizeTransform = CGAffineTransform(scaleX: 1.0/imageSize.width, y: 1.0/imageSize.height)

            // 2) Flip the Y axis (for some mysterious reason this is only necessary in portrait mode)
            let flipTransform = (interfaceOrientation.isPortrait) ? CGAffineTransform(scaleX: -1, y: -1).translatedBy(x: -1, y: -1) : .identity
//
            // 3) Apply the transformation provided by ARFrame
            // This transformation converts:
            // - From Normalized image coordinates (Normalized image coordinates range from (0,0) in the upper left corner of the image to (1,1) in the lower right corner)
            // - To view coordinates ("a coordinate space appropriate for rendering the camera image onscreen")
            // See also: https://developer.apple.com/documentation/arkit/arframe/2923543-displaytransform

            let displayTransform = frame.displayTransform(for: interfaceOrientation, viewportSize: sceneViewSize)

            // 4) Convert to view size
            let toViewPortTransform = CGAffineTransform(scaleX: sceneViewSize.width, y: sceneViewSize.height)

            // Transform the image and crop it to the viewport
            let transformedImage = image.transformed(by: normalizeTransform.concatenating(flipTransform).concatenating(displayTransform).concatenating(toViewPortTransform)).cropped(to: viewPort)

            processCurren`tFrame(transformedImage)
//            
        }
        
        if crosshairBusyCalculating == false {
            print("cackng..")
            checkOverlap(at: crosshairCenter) { detectedObject in
                
                self.currentTargetedObject = detectedObject
                self.crosshairView.backgroundColor = (detectedObject == nil) ? UIColor.clear : UIColor.red.withAlphaComponent(0.5)
                
            }
        }
        
        framesSinceLastTrack += 1
        if framesSinceLastTrack >= 5 {
            framesSinceLastTrack = 0
            
            trackCurrentMarker()
        }
    }
}
