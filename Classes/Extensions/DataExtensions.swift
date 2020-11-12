import Foundation

public extension Data {

    var hexEncodedString: String {
        return map { String(format: "%02hhx", $0) }.joined()
    }
}
