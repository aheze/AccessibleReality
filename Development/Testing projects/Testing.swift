func angle3D(vertex: Value, position1: Value, position2: Value) -> Float {
    let vector1 = Value(
        x: position1.x - vertex.x,
        y: position1.y - vertex.y,
        z: position1.z - vertex.z
    )
    let vector2 = Value(
        x: <#position2#>.x - vertex.x,
        y: <#position2#>.y - vertex.y,
        z: <#position2#>.z - vertex.z
    )
    
    let xProduct = vector1.x * vector2.x
    let yProduct = vector1.y * vector2.y
    let zProduct = vector1.z * vector2.z

    let dotProduct = <#xProduct#> + <#yProduct#> + <#zProduct#>
    let vertexToPosition1 = distanceFormula3D(position1: vertex, position2: position1)
    let vertexToPosition2 = distanceFormula3D(position1: vertex, position2: position2)

    let cosineOfAngle = dotProduct / (vertexToPosition1 * vertexToPosition2)
    let angle = acos(<#cosineOfAngle#>)
    return angle
}