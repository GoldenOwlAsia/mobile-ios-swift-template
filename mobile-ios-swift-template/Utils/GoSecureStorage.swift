//
//  GoSecureStorage.swift
//  mobile-ios-swift-template
//
//  Created by Ping9 on 23/03/2023.
//

import Foundation

#if canImport(CryptoKit)
  import CryptoKit
#endif


public class XSecureStorage {
  
    //MARK: - Properties
    private let key: SymmetricKey!
    private let nonce: AES.GCM.Nonce!
    private let tag: Data!
    public var isProduction: Bool = false
    
    //MARK: - Life cycle
    public init(){
        let secret = "go-app-hyj97cdm-yek-ios-k"
        self.key = SymmetricKey(data: secret.data(using: .utf8)!)
        self.nonce = try! AES.GCM.Nonce(data: Data(base64Encoded: "go67bhjdsudskj")!)
        self.tag = Data(base64Encoded: "go+app+45fk9rfghr")!
        self.isProduction = false
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - User action functions
    public func saveString(key: String, message: String) {
        let keyHash = convertTextToHash(key: key)
        var encryptedData: Data? = nil
        
        if let messageData = message.data(using: .utf8) {
            encryptedData = encryptData(data: messageData)
        }
        
        UserDefaults.standard.set(encryptedData, forKey: keyHash)
    }
    
    public func retrieveString(key: String) -> String? {
        let keyHash = convertTextToHash(key: key)
        guard let retrievedData = UserDefaults.standard.value(forKey: keyHash) as? Data, let decryptedData = decryptData(encryptedData: retrievedData) else { return nil }
        
        let decryptedMessage = String(data: decryptedData, encoding: .utf8)
        return decryptedMessage
    }
                                       
    public func saveObject<T: Encodable>(value: T, key: String) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        
        saveData(key: key, data: data)
    }
   
    public func retrieveObject<T: Decodable>(withType type: T.Type, key: String) -> T? {
        guard let retrievedData = retrieveData(key: key) else { return nil }
        
        let value = try? JSONDecoder().decode(T.self, from: retrievedData)
        return value
    }
    
    public func saveData(key: String, data: Data) {
        let keyHash = convertTextToHash(key: key)
        let encryptedData = encryptData(data: data)
        
        UserDefaults.standard.set(encryptedData, forKey: keyHash)
    }
    
    public func retrieveData(key: String) -> Data? {
        let keyHash = convertTextToHash(key: key)
        guard let retrievedData = UserDefaults.standard.value(forKey: keyHash) as? Data else { return nil }
        let decryptedData = decryptData(encryptedData: retrievedData)
        return decryptedData
    }
    
    public func removeValue(key: String) {
        let keyHash = convertTextToHash(key: key)
        UserDefaults.standard.removeObject(forKey: keyHash)
    }
    
    public func clearStorage(){
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
         }
    }
    
    //MARK: - Helper functions
    private func encryptData(data: Data) -> Data? {
        let sealedBox = try! AES.GCM.seal(data, using: key, nonce: nonce, authenticating: tag)
        guard let combinedData =  sealedBox.combined else { return nil }
        
        if !isProduction{
            print("\n•••••••••••••• Encryption ••••••••••••••••••••••\n")
            print("Combined:\n\(combinedData.base64EncodedString())\n")
            print("Cipher:\n\(sealedBox.ciphertext.base64EncodedString())\n")
            print("Nonce:\n\(nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")
            print("Tag:\n\(tag.base64EncodedString())\n")
        }
        return combinedData
    }
    
    private func decryptData(encryptedData: Data) -> Data? {
        guard
            let sealedBoxRestored = try? AES.GCM.SealedBox(combined: encryptedData),
            let decrypted = try? AES.GCM.open(sealedBoxRestored, using: key, authenticating: tag)
        else { return nil }
        
        if !isProduction {
            print("\n•••••••••••••• Decryption ••••••••••••••••••••••\n")
            print("Nonce:\n\(nonce.withUnsafeBytes { Data(Array($0)).base64EncodedString() })\n")
            print("Tag:\n\(tag.base64EncodedString())\n")
            print("Decrypted:\n\(String(data: decrypted, encoding: .utf8) ?? "")\n")
        }
        
        return decrypted
    }
    
    private func convertTextToHash(key: String) -> String {
        let dataTohash : Data = key.data(using: .utf8) ?? Data()
        let digest = SHA256.hash(data: dataTohash)
        let encryptedKey = digest.compactMap { String(format: "%02x", $0)}.joined()
        
        if !isProduction {
            print("Key Hash: \(encryptedKey)")
        }
        
        return encryptedKey
    }
}
