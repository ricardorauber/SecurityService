import Foundation

public protocol SecurityServiceProtocol {
    
    func encrypt(data: Data) -> Data?
    func decrypt(data: Data) -> Data?
    func hash(password: String) -> Data?
}
