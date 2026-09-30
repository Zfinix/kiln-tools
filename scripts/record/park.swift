import CoreGraphics
let bounds = CGDisplayBounds(CGMainDisplayID())
CGWarpMouseCursorPosition(CGPoint(x: bounds.maxX - 2, y: bounds.maxY - 2))
