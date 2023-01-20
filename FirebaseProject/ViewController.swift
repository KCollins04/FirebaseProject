//
//  ViewController.swift
//  FirebaseProject
//
//  Created by KELSEY COLLINS on 1/17/23.
//
class Store{
    var date = ""
    var word = ""
    
    var ref: DatabaseReference!
    
    init(word: String, date: String){
        self.word = word
        self.date = date
    }
    
    func saveToFirebase(){
        let dict = ["Date":date, "word":word] as [String:Any]
        ref.child("today").childByAutoId().setValue(dict)
    }
}


import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController {
    
    
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var nameOutlet: UITextField!
    var ref: DatabaseReference!
    var words = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //connects to Firebase
        ref = Database.database().reference()
        ref.child("today").observe(.childAdded){ snapshot in
           let word = snapshot.value as! String
           //self.words.append(word)
            self.tableViewOutlet.reloadData()
            
        }
    }

    
    @IBAction func addButton(_ sender: UIButton) {
        //set outlet to a value
        let word = nameOutlet.text!
        let date = dateOutlet.text!
        //send the word to firebase called todays
        ref.child("today").childByAutoId().setValue(word)
       let list = Store(word: word, date: date)
        list.saveToFirebase()
        words.append(list)
        tableViewOutlet.reloadData()
        
    }
    
}

