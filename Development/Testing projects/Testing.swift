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

func distanceFormula3D(position1: Value, position2: Value) -> Number {
    let xDifference = position1.x - position2.x
    let yDifference = position1.y - position2.y
    let zDifference = position1.z - position2.z

    let everythingInsideSquareRoot = pow(xDifference, 2) + pow(yDifference, 2) + pow(zDifference, 2)
    let distance = sqrt(everythingInsideSquareRoot)
    
    return Number(distance)
}
