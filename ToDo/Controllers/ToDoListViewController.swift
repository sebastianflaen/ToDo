//
//  ViewController.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 18/06/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import RealmSwift
class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    var toDoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard //persistent local data storage
    
   
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            
            if item.done == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
        } else {
            cell.textLabel?.text = "Ingen items"
        }
        
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("error, \(error)")
            }
            
            
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("error")
                }
                
                
            }
           
            
            
          
            
            
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
    
    
    func loadItems(predicate: NSPredicate? = nil){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
        
        
    
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text! ).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
      
        
        
        /*  let request :  NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(predicate: predicate)
        
        do {
            toDoItems =  try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
        */
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            //loadItems() //funker dette? fjern disse og legg til predicate: predicate
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
            
            
            
        }
    }
    
    func deleteItems(){
        
    }
 
 

}


