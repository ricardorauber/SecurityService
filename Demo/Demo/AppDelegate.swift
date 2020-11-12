import UIKit
import SecurityService

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
    let service = SecurityService()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = UIViewController()
		window?.makeKeyAndVisible()
        
        testCipher()
        testHash()
		
		return true
	}
    
    func testCipher() {
        let name = "Ricardo Rauber"
        if let data = name.data(using: .utf8), let encrypted = service.encrypt(data: data) {
            print("encrypted", encrypted)
            if let decrypted = service.decrypt(data: encrypted) {
                print("decrypted", decrypted)
                if let result = String(data: decrypted, encoding: .utf8) {
                    print("result", result)
                } else {
                    print("failt to convert decrypted to String")
                }
            } else {
                print("decrypt fail")
            }
        } else {
            print("encrypt fail")
        }
    }
    
    func testHash() {
        let password = "balubalu"
        if let key = service.hash(password: password) {
            print("key", key)
            print("result", key.hexEncodedString)
        } else {
            print("hash fail")
        }
    }
}
