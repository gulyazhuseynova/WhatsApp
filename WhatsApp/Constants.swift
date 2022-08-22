//
//  Constants.swift
//  WhatsApp
//
//  Created by Gulyaz Huseynova on 21.08.22.
//

struct K {
    static let appName = "WhatsApp"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    
    struct Colors {
        static let green = "BackgroundMe"
        static let white = "BackgroundYou"
        static let textColor = "TextColor"
        static let topColor = "TopColor"
        static let register = "Register"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
