import Foundation
import Quick
import Nimble
@testable import SecurityService

class DataExtensionsTests: QuickSpec {
    override func spec() {
        
        describe("DataExtensions") {
            
            context("hexEncodedString") {
                
                it("should build the right hex encoded string") {
                    let source = "some string"
                    let data = source.data(using: .utf8)!
                    let hexEncodedString = data.hexEncodedString
                    expect(hexEncodedString) == "736f6d6520737472696e67"
                }
            }
        }
    }
}
