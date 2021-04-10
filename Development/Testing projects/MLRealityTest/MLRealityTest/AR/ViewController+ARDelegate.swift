//
//  ViewController+ARDelegate.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import ARKit

extension ViewController {
    func setupAR() {
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.session.delegate = self
    }
}


extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        if busyProcessingImage == false && coachingViewActive == false {
            busyProcessingImage = true
            
            
            /// get coordinates converted to screen
            /// from https://stackoverflow.com/a/58817480/14351818
            let imageBuffer = frame.capturedImage

            let imageSize = CGSize(width: CVPixelBufferGetWidth(imageBuffer), height: CVPixelBufferGetHeight(imageBuffer))
            let viewPort = CGRect(origin: .zero, size: sceneViewSize)


            let interfaceOrientation : UIInterfaceOrientation
            if #available(iOS 13.0, *) {
                interfaceOrientation = self.sceneView.window!.windowScene!.interfaceOrientation
            } else {
                interfaceOrientation = UIApplication.shared.statusBarOrientation
            }

            let image = CIImage(cvImageBuffer: imageBuffer)

            // The camera image doesn't match the view rotation and aspect ratio
            // Transform the image:

            // 1) Convert to "normalized image coordinates"
            let normalizeTransform = CGAffineTransform(scaleX: 1.0/imageSize.width, y: 1.0/imageSize.height)

            // 2) Flip the Y axis (for some mysterious reason this is only necessary in portrait mode)
            let flipTransform = (interfaceOrientation.isPortrait) ? CGAffineTransform(scaleX: -1, y: -1).translatedBy(x: -1, y: -1) : .identity

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

            processCurrentFrame(transformedImage)
            
        }
        
        if crosshairBusyCalculating == false {
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
