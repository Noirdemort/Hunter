//
//  Translator.swift
//  
//
//  Created by Noirdemort on 06/09/20.
//

import Foundation
import CryptoSwift


protocol Translate {
	var HuntingParty: [Hunt] { get set }
	var filePath: String { get }
	
	mutating func loadAndDraft(filePath: String)
	func saveAndDeploy(hunts: [Hunt], filePath: String)
	mutating func addHunt(hunt: Hunt)
	mutating func deleteHunt(hunt: Hunt)
	mutating func updateHunt(hunt: Hunt)
	func encryptText(plainText: String) -> String
	mutating func decryptText(cipherText: String) -> String
}


struct Translator: Translate {
	
	var HuntingParty: [Hunt] = []
	
	internal var cryptoKey: String
	internal var plainSalt: String
	internal var initVector: String
	internal var cipherKey: [UInt8]? = nil
	
	var filePath = NSHomeDirectory() + "/hunter.dat"
	
	mutating func loadAndDraft(filePath: String) {
		do  {
			let str = try String.init(contentsOfFile: filePath, encoding: .utf8)
			let decoder = JSONDecoder()
			decoder.dataDecodingStrategy = .deferredToData
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			let plainText = self.decryptText(cipherText: str)
			guard let data = plainText.data(using: .utf8) else { return }
			self.HuntingParty = try decoder.decode([Hunt].self, from: data)
		} catch {
			print(error.localizedDescription)
		}
	}
	
	func saveAndDeploy(hunts: [Hunt], filePath: String) {
		do  {
			let encoder = JSONEncoder()
			encoder.dataEncodingStrategy = .deferredToData
			encoder.keyEncodingStrategy = .convertToSnakeCase
			
			let encodedData = try encoder.encode(hunts)
			let str = String(data: encodedData, encoding: .utf8)
			if let s = str {
				let cipherText = self.encryptText(plainText: s)
				try cipherText.write(toFile: filePath, atomically: true, encoding: .utf8)
			}
		} catch {
			print(error)
		}
	}
	
	
	mutating func addHunt(hunt: Hunt){
		self.HuntingParty.append(hunt)
	}
	
	mutating func deleteHunt(hunt: Hunt){
		self.HuntingParty.removeAll(where: { $0.id == hunt.id })
	}
	
	mutating func updateHunt(hunt: Hunt){
		self.deleteHunt(hunt: hunt)
		self.addHunt(hunt: hunt)
	}

	func encryptText(plainText: String)  -> String {
		
		do {
			let password: Array<UInt8> = Array(self.cryptoKey.utf8)
			let salt: Array<UInt8> = Array(self.plainSalt.utf8)

			let key = try (self.cipherKey ?? PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, keyLength: 32, variant: .sha512).calculate())
			
			let gcm = GCM(iv: Array(self.initVector.utf8), mode: .combined)
			let aes = try AES(key: key, blockMode: gcm, padding: .pkcs7)
			return try plainText.encryptToBase64(cipher: aes) ?? ""
		} catch {
			// failed
			print(error)
			exit(EXIT_FAILURE)
		}
	}


	mutating func decryptText(cipherText: String) -> String {

		do {
			let password: Array<UInt8> = Array(self.cryptoKey.utf8)
			let salt: Array<UInt8> = Array(self.plainSalt.utf8)
			
			let key = try PKCS5.PBKDF2(password: password, salt: salt, iterations: 2048, keyLength: 32, variant: .sha512).calculate()
			
			self.cipherKey = key
			
			let gcm = GCM(iv: Array(self.initVector.utf8), mode: .combined)
			let aes = try AES(key: key, blockMode: gcm, padding: .pkcs7)
			return try cipherText.decryptBase64ToString(cipher: aes)
		} catch {
			// failed
			print(error)
			exit(EXIT_FAILURE)
		}
		
	}

	
}
