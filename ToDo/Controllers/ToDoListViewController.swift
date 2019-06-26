//
//  ViewController.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 18/06/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let defaults = UserDefaults.standard //persistent local data storage

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Find Mike"
        itemArray.append(newItem)
        // Do any additional setup after loading the view, typically from a nib.
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
            itemArray = items
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        
        if item.done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
       
   
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Legg til nye items
    
    @IBAction func addButtonPressed(_ sender:
        UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Legg til ny ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Legg til Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            // hva skjer nå bruker trykker på add
            print(textField.text)
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Lag nytt item"
            print("")
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    

}

