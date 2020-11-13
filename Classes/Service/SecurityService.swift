import Foundation
import CryptoSwift
import KeyValueStorage

public class SecurityService {
    
    // MARK: - Dependencies
    
    let storage: KeyValueStorageProtocol
    
    // MARK: - Cipher Properties
    
    let cipherKey: String
    let cipherIv: String
    
    // MARK: - Hash Properties
    
    let hashSalt: String
    let hashIterations: Int
    let hashKeyLength: Int
    let hashVariant: HMAC.Variant
    
    // MARK: - Initialization
    
    public init(storage: KeyValueStorageProtocol = KeyValueStorage(),
                cipherKey: String? = nil,
                cipherIv: String? = nil,
                hashSalt: String? = nil,
                hashIterations: Int = 4096,
                hashKeyLength: Int = 32,
                hashVariant: HMAC.Variant = .sha256,
                saveKeys: Bool = true) {
        
        self.storage = storage
        
        if let key = cipherKey {
            self.cipherKey = key
        } else if let key: String = storage.get(key: .securityServiceCipherKey) {
            self.cipherKey = key
        } else {
            self.cipherKey = .randomString(length: 16)
        }
        
        if let iv = cipherIv {
            self.cipherIv = iv
        } else if let iv: String = storage.get(key: .securityServiceCipherIv) {
            self.cipherIv = iv
        } else {
            self.cipherIv = .randomString(length: 16)
        }
        
        if let salt = hashSalt {
            self.hashSalt = salt
        } else if let salt: String = self.storage.get(key: .securityServiceHashSalt) {
            self.hashSalt = salt
        } else {
            self.hashSalt = .randomString(length: 8)
        }
        
        if saveKeys {
            storage.set(value: self.cipherKey, for: .securityServiceCipherKey)
            storage.set(value: self.cipherIv, for: .securityServiceCipherIv)
            storage.set(value: self.hashSalt, for: .securityServiceHashSalt)
        }
        
        self.hashIterations = hashIterations
        self.hashKeyLength = hashKeyLength
        self.hashVariant = hashVariant
    }
}

// MARK: - SecurityServiceProtocol
extension SecurityService: SecurityServiceProtocol {
    
    public func encrypt(data: Data) -> Data? {
        do {
            let gcm = GCM(iv: cipherIv.bytesArray, mode: .combined)
            let aes = try AES(key: cipherKey.bytesArray, blockMode: gcm, padding: .noPadding)
            let encrypted = try aes.encrypt(data.bytes)
            return Data(encrypted)
        } catch {
            return nil
        }
    }
    
    public func decrypt(data: Data) -> Data? {
        do {
            let gcm = GCM(iv: cipherIv.bytesArray, mode: .combined)
            let aes = try AES(key: cipherKey.bytesArray, blockMode: gcm, padding: .noPadding)
            return try Data(aes.decrypt(data.bytes))
        } catch {
            return nil
        }
    }
    
    public func hash(password: String) -> Data? {
        do {
            let key = try PKCS5.PBKDF2(password: password.bytesArray,
                                       salt: hashSalt.bytesArray,
                                       iterations: hashIterations,
                                       keyLength: hashKeyLength,
                                       variant: hashVariant).calculate()
            return Data(key)
        } catch {
            return nil
        }
    }
}
