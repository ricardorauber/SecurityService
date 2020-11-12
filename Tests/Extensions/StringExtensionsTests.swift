import Foundation
import Quick
import Nimble
@testable import SecurityService

class StringExtensionsTests: QuickSpec {
    override func spec() {
        
        describe("StringExtensions") {
            
            context("bytesArray") {
                
                it("should build the corrrect array") {
                    let source = "some string"
                    let bytesArray = source.bytesArray
                    let data = Data(bytesArray)
                    let result = String(data: data, encoding: .utf8)
                    expect(result) == source
                }
            }
            
            context("randomString") {
                
                it("should build a random string") {
                    let string = String.randomString(length: 10)
                    expect(string.count) == 10
                }
            }
        }
    }
}
