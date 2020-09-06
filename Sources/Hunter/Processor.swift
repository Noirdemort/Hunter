//
//  Processor.swift
//  
//
//  Created by Noirdemort on 06/09/20.
//

import Foundation
import CryptoSwift

func authenticateUser(password: String) -> String? {
	if password.sha3(.sha512) == "bd15782afeaf950d94231b0e10770ebea76fa587499ca25024c5b5f3ffe76c4071a6b1ef67752dd026003775572cff689611606a6df526e43468f8fbfb33826b" {
		return password
	}
	
	return nil
}


func listHunt(translator: Translate) -> [Hunt] {
	return translator.HuntingParty
}


func setHunt(translator: Translate, codename: String) -> Bool {
	let hunt = translator.HuntingParty.first(where: { $0.codename == codename })
	guard let h = hunt else { return false }
	selectedHunt = h
	return true
}


func saveHunt(translator: inout Translate, hunt: Hunt) {
	translator.addHunt(hunt: hunt)
}


func deleteHunt(translator: inout Translate, hunt: Hunt) {
	translator.deleteHunt(hunt: hunt)
}


func updateHunt(translator: inout Translate, hunt: Hunt, name: String, quickNotes: String, specialNotes: String){
	
	let finalName = name.isEmpty ? hunt.name : name
	let finalQuickNotes = quickNotes.isEmpty ? hunt.quickNotes : quickNotes
	let finalSpecialNotes = specialNotes.isEmpty ? hunt.specialNotes : specialNotes
	
	let hunted = Hunt(id: hunt.id, codename: hunt.codename, name: finalName, quickNotes: finalQuickNotes, specialNotes: finalSpecialNotes)
	
	translator.updateHunt(hunt: hunted)
}

