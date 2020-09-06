import Foundation

print("\n\tTask Force 141\n")
print("\tProject [REDACTED]\n")

func consoleInput(express: String) -> String {
	print(express, terminator: ": ")
	let input = readLine(strippingNewline: true)
	return input ?? ""
}


func getPassword(_ phrase: String) -> String {
	var buf = [CChar](repeating: 0, count: 8192)
	if let passphrase = readpassphrase("", &buf, buf.count, 0),
		let passphraseStr = String(validatingUTF8: passphrase) {
			return passphraseStr
	}
	
	return ""
}


func getNewHunt() -> Hunt? {
	let codename = consoleInput(express: "Enter codename")
	let name = consoleInput(express: "Enter name")
	let quickNotes = consoleInput(express: "Enter quick notes")
	let specialNotes = consoleInput(express: "Enter special notes")
	
	if codename.isEmpty || name.isEmpty {
		return nil
	}
	
	return Hunt(codename: codename,
				name: name,
				quickNotes: quickNotes,
				specialNotes: specialNotes)
	
}

func showHunted(hunt: Hunt){
	print("\tCodename: \(hunt.codename)")
	print("\tName: \(hunt.name)")
	print("\tQuick Notes: \(hunt.quickNotes)")
	print("\tSpecial Notes: \(hunt.specialNotes)")
}

print("EXEC_CODE: PRIVAC\n")
let password = getPassword("passphrase")

if authenticateUser(password: password) == nil {
	print("[!] Invalid Credentials!!\n")
	exit(EXIT_FAILURE)
}

let salt = getPassword("crypto salt")
let iv = getPassword("crypto iv")

var translatorEngine: Translate = Translator(cryptoKey: password, plainSalt: salt, initVector: iv)
translatorEngine.loadAndDraft(filePath: translatorEngine.filePath)

print("\n\t\t  HUNTER: [REDACTED] Intelligence Grid\n")


var command = ""

print("\n[i] Commands: select (s) | elaborate (a) | show (l) | create (n) | delete (d) | edit (e) | exit (q)\n ")

while true {
	
	command = consoleInput(express: "Command").lowercased()
	
	switch (command) {
	
	case "select", "s":
		let codename = consoleInput(express: ">> Codename")
		if (setHunt(translator: translatorEngine, codename: codename)){
			print("[+] Selected Hunt.\n")
		} else {
			print("[-] No Corresponding record found!\n")
		}
		
	case "elaborate", "a":
		if let hunt = selectedHunt {
			showHunted(hunt: hunt)
		} else {
			print("[-] No selected record!!")
		}
		
	case "show", "l":
		for hunter in listHunt(translator: translatorEngine){
			print("\t\(hunter.codename)")
		}
		print()
		
		
	case "create", "n":
		if let hunt = getNewHunt() {
			saveHunt(translator: &translatorEngine, hunt: hunt)
			print("[+] Saved New Hunt instance.\n")
		} else {
			print("[!] Can not create the instance. Codename and name are mandatory.\n")
		}
	
		
	case "delete", "d":
		if let hunt = selectedHunt  {
			deleteHunt(translator: &translatorEngine, hunt: hunt)
		} else {
			print("[-] No selected record!!")
		}
	
		
	case "edit", "e":
		if let hunt = selectedHunt {
			let name = consoleInput(express: "Enter new name ['']")
			let quickNotes = consoleInput(express: "Enter new quick notes ['']")
			let specialNotes = consoleInput(express: "Enter new special notes ['']")
			updateHunt(translator: &translatorEngine, hunt: hunt, name: name, quickNotes: quickNotes, specialNotes: specialNotes)
		} else{
			print("[-] No selected record!!")
		}
		
	
	case "exit", "q":
		print("[+] Exiting...")
		let cls = Process()
		let out = Pipe()
		cls.launchPath = "/usr/bin/clear"
		cls.standardOutput = out
		cls.launch()
		cls.waitUntilExit()
        print (String(data: out.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8) ?? "")
		translatorEngine.saveAndDeploy(hunts: translatorEngine.HuntingParty, filePath: translatorEngine.filePath)
		exit(EXIT_SUCCESS)
	
	default:
		print("[-] No such commands found!!\n")
	
	}
	
}
