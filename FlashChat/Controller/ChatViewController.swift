//
//  ChatViewController.swift
//  FlashChat
//
//  Created by Anjali on 5/23/20.
//  Copyright © 2020 Anjali. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        navigationItem.title = K.appName
        tableView.reloadData()
        registerCell()
        readData()
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
          
    }
    
    
    func readData() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, err) in
            self.messages = []
            if let err = err {
                print("Error getting data: \(err)")
            } else {
                if let snapShotDocument = querySnapshot?.documents {
                    for doc in snapShotDocument {
                       let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let body = data[K.FStore.bodyField] as? String {
                            let message = Message(sender: sender, body: body)
                            self.messages.append(message)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indesPath =
                                    IndexPath(row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indesPath, at: .top, animated: true)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            
            db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField : sender , K.FStore.bodyField : messageBody,
                                                                      K.FStore.dateField : Date().timeIntervalSince1970])
            { (error) in
                if let e = error {
                    print("faild to store Data in database \(e)")
                } else {
                    print("Data store successfully in database")
                    self.messageTextfield.text = ""
                }
            }
        }
    }
    
    func registerCell() {
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellNibName)
    }
}

extension ChatViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellNibName, for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        cell.messageLabel.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.purple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.messageLabel.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
}

