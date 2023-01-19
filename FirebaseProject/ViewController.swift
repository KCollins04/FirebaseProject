//
//  ViewController.swift
//  FirebaseProject
//
//  Created by KELSEY COLLINS on 1/17/23.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var nameOutlet: UITextField!
    var ref: DatabaseReference!
    var words = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //connects to Firebase
        ref = Database.database().reference()
        ref.child("today").observe(.childAdded){ snapshot in
           let word = snapshot.value as! String
           self.words.append(word)
           
            
        }
    }

    
    @IBAction func addButton(_ sender: UIButton) {
        //set outlet to a value
        let word = nameOutlet.text!
        //send the word to firebase called todays
        ref.child("today").childByAutoId().setValue(word)
        
    }
    
}

