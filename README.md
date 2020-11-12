# SecurityService - An easy way to encrypt/decrypt and hash Data

[![Build Status](https://travis-ci.com/ricardorauber/SecurityService.svg?branch=master)](http://travis-ci.com/)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/SecurityService.svg?style=flat)](http://cocoadocs.org/docsets/SecurityService)
[![License](https://img.shields.io/cocoapods/l/SecurityService.svg?style=flat)](http://cocoadocs.org/docsets/SecurityService)
[![Platform](https://img.shields.io/cocoapods/p/SecurityService.svg?style=flat)](http://cocoadocs.org/docsets/SecurityService)

## SecurityService

Do you always have trouble trying to implement cryptografy? Well, you don't need to worry anymore! In this framework I have created a wrapper on top of one of the most beloved crypto frame. All works out there, the [CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift). 

Why? Just because I wanted to repeat this setup in many projects and so I have created the `SecurityService`.

## Setup

#### CocoaPods

If you are using CocoaPods, add this to your Podfile and run `pod install`.

```Ruby
target 'Your target name' do
    pod 'SecurityService', '~> 1.0'
end
```

#### Manual Installation

If you want to add it manually to your project, without a package manager, just copy all files from the `Classes` folder to your project.

## Usage

#### Creating the Service

To create an instance of the service, you only need to import the framework and instantiate the `SecurityService`:

```swift
import SecurityService
let service = SecurityService()
```

If you want to have some specific configuration, you can create it like this:

```swift
import KeyValueStorage
import SecurityService

service = SecurityService(storage: KeyValueStorage(),
                          cipherKey: "keykeykeykeykeyk",
                          cipherIv: "drowssapdrowssap",
                          hashSalt: "nacllcan",
                          hashIterations: 4096,
                          hashKeyLength: 32,
                          hashVariant: .sha256)
```

#### Encrypt/Decrypt

With `SecurityService` it is very easy to encrypt/decrypt `Data`, it uses the `AES-GCM` algorithm and you just need to call it like this:

```swift
let source = "some string"
let data = source.data(using: .utf8)!
let encrypted = service.encrypt(data: data)
let decrypted = service.decrypt(data: encrypted!)
let result = String(data: decrypted!, encoding: .utf8)
```

#### Hash passwords

You can also has passwords in order to protect the user's data using the `PBKDF2` algorithm:

```swift
let password = "something"
let hashPassword = service.hash(password: password)
```

## Cryptography Notice

This distribution includes cryptographic software. The country in which you currently reside may have restrictions on the import, possession, use, and/or re-export to another country, of encryption software. BEFORE using any encryption software, please check your country's laws, regulations and policies concerning the import, possession, or use, and re-export of encryption software, to see if this is permitted. See http://www.wassenaar.org/ for more information.

## Thanks 👍

The creation of this framework was possible thanks to these awesome people:

* CryptoSwift: [https://github.com/krzyzanowskim/CryptoSwift](https://github.com/krzyzanowskim/CryptoSwift)
* Gray Company: [https://www.graycompany.com.br/](https://www.graycompany.com.br/)
* Swift by Sundell: [https://www.swiftbysundell.com/](https://www.swiftbysundell.com/)
* Hacking with Swift: [https://www.hackingwithswift.com/](https://www.hackingwithswift.com/)
* Ricardo Rauber: [http://ricardorauber.com/](http://ricardorauber.com/)

## Feedback is welcome

If you notice any issue, got stuck or just want to chat feel free to create an issue. We will be happy to help you.

## License

SecurityService is released under the [MIT License](LICENSE).
