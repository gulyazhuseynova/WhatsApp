//
//  ChatViewController.swift
//  WhatsApp
//
//  Created by Gulyaz Huseynova on 21.08.22.
//

import UIKit
import Firebase
import IQKeyboardManager

class ChatViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "background"))
        messageTextfield.delegate = self
        
        title = K.appName
        navigationItem.hidesBackButton = true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
        
    }
    
    func loadMessages(){
        
        
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{ (querySnapshot, error) in
            
            self.messages = []
            
            if let e = error{
                print("There was an issue retrieving, error:\(e)")
            }else{
                if let snapshotDocuments = querySnapshot?.documents{
                    for doc in snapshotDocuments{
                        if let sender = doc.data()[K.FStore.senderField] as? String,
                           let body = doc.data()[K.FStore.bodyField] as? String {
                            
                            let newMessage = Message(sender: sender , body: body)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async { [self] in
                                self.tableView.reloadData()
                                
                                
                                let indexPath = IndexPath(row: messages.count - 1, section: 0)
                                
                                self.tableView.scrollToRow(at: indexPath, at: .bottom , animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if messageTextfield.text != "" {
            let timeSent = Date().timeIntervalSince1970
            if let messageBody = messageTextfield.text,
                let messageSender = Auth.auth().currentUser?.email{
                db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,K.FStore.bodyField: messageBody, K.FStore.dateField: timeSent]) { (error) in
                    if let e = error{
                        print("There was an issue in saving the data,error:\(e)")
                    }else{
                        print("Succesfully saved the data")
                        
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
            }
        }else{
            messageTextfield.placeholder = "Type a message here"
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        
    }
    
}

extension ChatViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        
        let message = messages[indexPath.row]
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.messageBubble.backgroundColor = UIColor(named: K.Colors.green)
            cell.label.textColor = UIColor(named: K.Colors.textColor)
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            
        } else {
            cell.messageBubble.backgroundColor = UIColor(named: K.Colors.white)
            cell.label.textColor = UIColor(named: K.Colors.textColor)
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
        }
        
        return cell
    }
    
    
}

extension ChatViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        messageTextfield.endEditing(true)
        return true
    }

    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if messageTextfield.text != "" {
            return true
        }else {
            messageTextfield.placeholder = "Type a message here"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
            let timeSent = Date().timeIntervalSince1970
            if let messageBody = messageTextfield.text,
                let messageSender = Auth.auth().currentUser?.email{
                db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField: messageSender,K.FStore.bodyField: messageBody, K.FStore.dateField: timeSent]) { (error) in
                    if let e = error{
                        print("There was an issue in saving the data,error:\(e)")
                    }else{
                        print("Succesfully saved the data")
                        
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
            }
        
        
}
}
