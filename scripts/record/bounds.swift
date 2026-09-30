import CoreGraphics
import Foundation

let title = CommandLine.arguments[1]
let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID) as? [[String: Any]] ?? []
for w in list {
    guard (w[kCGWindowOwnerName as String] as? String) == "Ghostty",
          (w[kCGWindowName as String] as? String) == title,
          let b = w[kCGWindowBounds as String] as? [String: Double] else { continue }
    print("\(Int(b["X"]!)),\(Int(b["Y"]!)),\(Int(b["Width"]!)),\(Int(b["Height"]!))")
    exit(0)
}
exit(1)
