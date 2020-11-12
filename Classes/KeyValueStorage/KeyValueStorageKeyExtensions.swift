import Foundation
import KeyValueStorage

extension KeyValueStorageKey {
    
    static let securityServiceCipherKey = KeyValueStorageKey(type: .keychain, value: "securityServiceCipherKey")
    static let securityServiceCipherIv = KeyValueStorageKey(type: .keychain, value: "securityServiceCipherIv")
    static let securityServiceHashSalt = KeyValueStorageKey(type: .keychain, value: "securityServiceHashSalt")
}
