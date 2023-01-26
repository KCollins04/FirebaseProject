//
//  ViewController.swift
//  FirebaseProject
//
//  Created by KELSEY COLLINS on 1/17/23.
//
class Store{
    var date = ""
    var word = ""
    var key = ""
    
    var ref = Database.database().reference()
    init(word: String, date: String){
        self.word = word
        self.date = date
    }
    
    func saveToFirebase(){
        let dict = ["Date":date, "word":word] as [String:Any]
        key = ref.child("todays").childByAutoId().key ?? ""
        ref.child("todays").child(key).setValue(dict)
    }
}


import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var nameOutlet: UITextField!
    var ref: DatabaseReference!
    var words = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //connects to Firebase
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        
        ref = Database.database().reference()
        ref.child("todays").observe(.childAdded){ snapshot in
           let dict = snapshot.value as! [String: String]
           let at = Store(word: dict["word"]!, date: dict["Date"]!)
           self.words.append(at)
         self.tableViewOutlet.reloadData()
        }
        
    ref.child("todays")
    }

    
    @IBAction func addButton(_ sender: UIButton) {
        //set outlet to a value
       /* let word = nameOutlet.text!
        let date = dateOutlet.text!
        //send the word to firebase called todays
        ref.child("today").childByAutoId().setValue(word)
       let list = Store(word: word, date: date)
        list.saveToFirebase()
        words.append(list)
        tableViewOutlet.reloadData()
        */
        
        let todo = nameOutlet.text!
        let date = dateOutlet.text!
        let save = Store(word: todo, date: date)
        save.saveToFirebase()
        words.append(save)
        tableViewOutlet.reloadData()
    }
 
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return words.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = words[indexPath.row].word
        cell.textLabel?.text = words[indexPath.row].date
        
        return cell
    }
}

