import Foundation

public func printDebug(_ message: Any..., file: String = #fileID, function: String = #function, line: Int = #line) {
    #if DEBUG
        print("🔍 [\(file):\(line)] \(function) - \(message)")
    #endif
}
