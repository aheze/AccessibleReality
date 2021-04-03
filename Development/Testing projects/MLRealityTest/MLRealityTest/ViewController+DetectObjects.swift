//
//  ViewController+DetectObjects.swift
//  MLRealityTest
//
//  Created by Zheng on 4/2/21.
//

import UIKit
import Vision

extension ViewController {
    func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        
        if pixelBufferSize == .zero {
            
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            self.pixelBufferSize = CGSize(width: ciImage.extent.height, height: ciImage.extent.width) /// flip
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                
                let configuration = MLModelConfiguration()
                let detectionModel = try YOLOv3TinyInt8LUT(configuration: configuration)
                let mlModel = try VNCoreMLModel(for: detectionModel.model)
                
                
                let objectDetectionRequest = VNCoreMLRequest(model: mlModel) { [weak self] request, error in
                    self?.processResults(for: request, error: error)
                }
                
                let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
                try requestHandler.perform([objectDetectionRequest])
            } catch {
                print("Error making model: \(error)")
            }
        }
    }
    
    func processResults(for request: VNRequest, error: Error?) {
        
        var detectedObjects = [DetectedObject]()
        
        if
            error == nil,
            let results = request.results
        {
            for observation in results  {
                if
                    let objectObservation = observation as? VNRecognizedObjectObservation,
                    let objectLabel = objectObservation.labels.first,
                    objectLabel.confidence > 0.9
                {
                    
                    let name = objectLabel.identifier
                    let convertedRect = getConvertedRect(boundingBox: objectObservation.boundingBox, withImageSize: pixelBufferSize, containedIn: arViewSize)
                    
                    let detectedObject = DetectedObject(name: name, convertedBoundingBox: convertedRect)
                    detectedObjects.append(detectedObject)

                    print("Detected: \(detectedObject), rect: \(convertedRect)")
                }
                
            }
            
        }
        
        print("current: \(detectedObjects)")
        self.currentDetectedObjects = detectedObjects
        
        DispatchQueue.main.async {
            for subView in self.drawingView.subviews {
                subView.removeFromSuperview()
            }
            
            for object in detectedObjects {
                let newView = UIView()
                newView.frame = object.convertedBoundingBox
                newView.backgroundColor = UIColor.green.withAlphaComponent(0.2)
                newView.layer.borderWidth = 4
                newView.layer.borderColor = UIColor.green.cgColor
                
                self.drawingView.addSubview(newView)
            }
        }
        
        busyProcessingImage = false
    }
    
    func getConvertedRect(boundingBox: CGRect, withImageSize imageSize: CGSize, containedIn containerSize: CGSize) -> CGRect {
        
        let rectOfImage: CGRect
        
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height
        
        if imageAspect > containerAspect { /// image extends left and right
            let newImageWidth = containerSize.height * imageAspect /// the width of the overflowing image
            let newX = -(newImageWidth - containerSize.width) / 2
            rectOfImage = CGRect(x: newX, y: 0, width: newImageWidth, height: containerSize.height)
            
        } else { /// image extends top and bottom
            let newImageHeight = containerSize.width * (1 / imageAspect) /// the width of the overflowing image
            let newY = -(newImageHeight - containerSize.height) / 2
            rectOfImage = CGRect(x: 0, y: newY, width: containerSize.width, height: newImageHeight)
        }
        
        let newOriginBoundingBox = CGRect(
            x: boundingBox.origin.x,
            y: 1 - boundingBox.origin.y - boundingBox.height,
            width: boundingBox.width,
            height: boundingBox.height
        )
        
        var convertedRect = VNImageRectForNormalizedRect(newOriginBoundingBox, Int(rectOfImage.width), Int(rectOfImage.height))
        
        /// add the margins
        convertedRect.origin.x += rectOfImage.origin.x
        convertedRect.origin.y += rectOfImage.origin.y
        
        return convertedRect
    }
}
