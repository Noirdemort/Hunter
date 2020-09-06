//
//  Model.swift
//  
//
//  Created by Noirdemort on 06/09/20.
//

import Foundation

struct Hunt: Codable, Identifiable {
	
	var id = UUID().uuidString
	var codename: String
	var name: String
	var quickNotes: String
	var specialNotes: String

}


