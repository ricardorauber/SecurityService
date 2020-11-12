import Foundation
import Quick
import Nimble
import KeyValueStorage
@testable import SecurityService

class SecurityServiceTests: QuickSpec {
    override func spec() {
        
        let storage = KeyValueStorage()
        var service: SecurityService!
        
        describe("SecurityService") {
            
            context("init") {
                
                context("clean state") {
                    
                    beforeEach {
                        storage.cleanAll()
                        service = SecurityService(storage: storage)
                    }
                    
                    it("should generate a cipher key and save it in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceCipherKey)
                        expect(result).toNot(beNil())
                    }
                    
                    it("should generate a cipher iv and save it in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceCipherIv)
                        expect(result).toNot(beNil())
                    }
                    
                    it("should generate a hash salt and save it in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceHashSalt)
                        expect(result).toNot(beNil())
                    }
                }
                
                context("existing values on keychain") {
                    
                    let cipherKey = "cipherKey"
                    let cipherIv = "cipherIv"
                    let hashSalt = "hashSalt"
                    
                    beforeEach {
                        storage.set(value: cipherKey, for: .securityServiceCipherKey)
                        storage.set(value: cipherIv, for: .securityServiceCipherIv)
                        storage.set(value: hashSalt, for: .securityServiceHashSalt)
                        service = SecurityService(storage: storage)
                    }
                    
                    it("should get the cipher key in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceCipherKey)
                        expect(result) == cipherKey
                    }
                    
                    it("should get the cipher iv in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceCipherIv)
                        expect(result) == cipherIv
                    }
                    
                    it("should get the hash salt in the keychain") {
                        let result: String? = service.storage.get(key: .securityServiceHashSalt)
                        expect(result) == hashSalt
                    }
                }
                
                context("sending parameters") {
                    
                    it("should get the cipher key in the keychain") {
                        let cipherKey = "cipherKey"
                        service = SecurityService(cipherKey: cipherKey)
                        let result: String? = service.storage.get(key: .securityServiceCipherKey)
                        expect(result) == cipherKey
                    }
                    
                    it("should get the cipher iv in the keychain") {
                        let cipherIv = "cipherIv"
                        service = SecurityService(cipherIv: cipherIv)
                        let result: String? = service.storage.get(key: .securityServiceCipherIv)
                        expect(result) == cipherIv
                    }
                    
                    it("should get the hash salt in the keychain") {
                        let hashSalt = "hashSalt"
                        service = SecurityService(hashSalt: hashSalt)
                        let result: String? = service.storage.get(key: .securityServiceHashSalt)
                        expect(result) == hashSalt
                    }
                }
            }
            
            context("SecurityServiceProtocol") {
                
                beforeEach {
                    storage.cleanAll()
                    service = SecurityService(storage: storage)
                }
                
                context("encrypt") {
                    
                    it("should encrypt a valid Data") {
                        let source = "some string"
                        let data = source.data(using: .utf8)!
                        let encrypted = service.encrypt(data: data)
                        expect(encrypted).toNot(beNil())
                    }
                    
                    it("should not encrypt an invalid cipher key") {
                        service = SecurityService(storage: storage, cipherKey: "")
                        let source = "some string"
                        let data = source.data(using: .utf8)!
                        let encrypted = service.encrypt(data: data)
                        expect(encrypted).to(beNil())
                    }
                }
                
                context("decrypt") {
                    
                    it("should decrypt a valid Data") {
                        let source = "some string"
                        let data = source.data(using: .utf8)!
                        let encrypted = service.encrypt(data: data)
                        expect(encrypted).toNot(beNil())
                        let decrypted = service.decrypt(data: encrypted!)
                        expect(decrypted).toNot(beNil())
                        let result = String(data: decrypted!, encoding: .utf8)
                        expect(result) == source
                    }
                    
                    it("should not encrypt an invalid cipher key") {
                        let source = "some string"
                        let data = source.data(using: .utf8)!
                        let encrypted = service.encrypt(data: data)
                        expect(encrypted).toNot(beNil())
                        service = SecurityService(storage: storage, cipherKey: "")
                        let decrypted = service.decrypt(data: encrypted!)
                        expect(decrypted).to(beNil())
                    }
                }
                
                context("hash") {
                    
                    it("should build a hash from a password") {
                        let password = "something"
                        let result = service.hash(password: password)
                        expect(result).toNot(beNil())
                        expect(result?.count) > 0
                    }
                    
                    it("should not build a has with an invalid salt") {
                        service = SecurityService(storage: storage, hashSalt: "")
                        let password = "something"
                        let result = service.hash(password: password)
                        expect(result).to(beNil())
                    }
                }
            }
        }
    }
}
