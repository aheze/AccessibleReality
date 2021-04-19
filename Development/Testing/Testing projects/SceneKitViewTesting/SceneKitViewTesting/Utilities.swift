//
//  Utilities.swift
//  SceneKitViewTesting
//
//  Created by Zheng on 4/16/21.
//

import SceneKit

func combine(_ transform: SCNMatrix4, with position: Value) -> Value {
    var positionForwardsMatrix = matrix_identity_float4x4
    positionForwardsMatrix.columns.3.x = position.x / 100
    positionForwardsMatrix.columns.3.y = position.y / 100
    positionForwardsMatrix.columns.3.z = position.z / 100
    
    let transformMatrix = simd_float4x4(transform)
    let combinedTransform = matrix_multiply(transformMatrix, positionForwardsMatrix)

    let combinedPosition = Value(
        x: combinedTransform.columns.3.x * 100,
        y: combinedTransform.columns.3.y * 100,
        z: combinedTransform.columns.3.z * 100
    )
    
    return combinedPosition
}
