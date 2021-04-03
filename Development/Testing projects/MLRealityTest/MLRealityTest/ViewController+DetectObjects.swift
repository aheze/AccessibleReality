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
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                
                let configuration = MLModelConfiguration()
                let detectionModel = try YOLOv3TinyInt8LUT(configuration: configuration)
                let mlModel = try VNCoreMLModel(for: detectionModel.model)
                
                
                let objectDetectionRequest = VNCoreMLRequest(model: mlModel) { [weak self] request, error in
                    self?.processResults(for: request, error: error)
                }
                
                let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .leftMirrored, options: [:])
                try requestHandler.perform([objectDetectionRequest])
            } catch {
                print("Error making model: \(error)")
            }
        }
    }
    
    func processResults(for request: VNRequest, error: Error?) {
        
        if
            error == nil,
            let results = request.results
        {
            for observation in results  {
                if
                    let objectObservation = observation as? VNRecognizedObjectObservation,
                    let topLabelObservation = objectObservation.labels.first,
                    topLabelObservation.confidence > 0.9
                {
                    
                    print("Detected: \(topLabelObservation.identifier)")
                    
                    busyProcessingImage = false
                    return
                }
                
            }
            
        }
        
        print("nothing detected")
        busyProcessingImage = false
    }
}
