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
    init(dict: [String: Any]){
        if let w = dict["word"] as? String{
            word = w
        }
        else{
            word = "none"
        }
        if let d = dict["date"] as? String{
            date = d
        }
        else{
            date = "0/0/0000"
        }
        
    }
    func saveToFirebase(){
        let dict = ["Date":date, "word":word] as [String:Any]
        key = ref.child("todays").childByAutoId().key ?? ""
        ref.child("todays").child(key).setValue(dict)
    }
    
    func delete(){
        ref.child("todays").child(key).removeValue()
    }
    func equals(st: Store)-> Bool{
        if st.word == word && st.date == date{
            return true
        }
        else{
            return false
        }
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
    var  wd = Store(word: "", date: "")
    
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
        
        //when adding it will show on the other phone
        ref.child("todays").observe(.childAdded){ snapshot in
            var dict = snapshot.value as! [String: Any]
            var word = Store(dict: dict)
            word.key = snapshot.key
            if !(self.wd.equals(st: word)){
                self.words.append(word)
                self.tableViewOutlet.reloadData()
            }
        }
        //removing on one phone and show on the other
        ref.child("todays").observe(.childRemoved) { snapshot in
            for i in 0..<self.words.count{
                if self.words[i].key == snapshot.key{
                    self.words.remove(at: i)
                    self.tableViewOutlet.reloadData()
                    break
                }
            }
        }
        
        //when removing on one phone will show on the other phone
        ref.child("todays").observe(.childChanged) { snapshot in
            let value = snapshot.value as! [String: Any]
            for i in 0..<self.words.count{
                if self.words[i].key == snapshot.key{
                    self.words[i].word = value["word"] as! String
                    self.words[i].date = value["date"] as! String
                    self.tableViewOutlet.reloadData()
                    break
                }
            }
            
            
        }
        
        
        
        
        
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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            words[indexPath.row].delete()
            //remove from array
            words.remove(at: indexPath.row)
            tableViewOutlet.reloadData()
        }
    }

    
}



