//
//  ViewController.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 18/06/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import CoreData
class ToDoListViewController: UITableViewController, UISearchBarDelegate {
    
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard //persistent local data storage
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
       
        self.saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Legg til nye items
    
    @IBAction func addButtonPressed(_ sender:
        UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Legg til ny ToDo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Legg til Item", style: .default) { (action) in
            
            
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            // hva skjer nå bruker trykker på add
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
           self.saveItems()
            
            
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
    
    func saveItems(){
        
        do {
           try context.save()
        } catch {
            
            print("Error, \(error)")
            
        }
        
        
        self.tableView.reloadData()
        
    }
    func loadItems(predicate: NSPredicate? = nil){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
            request.predicate = categoryPredicate
            
        }
        
        
        do {
          itemArray =  try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request :  NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        loadItems(predicate: predicate)
        
        do {
            itemArray =  try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
        
        
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

