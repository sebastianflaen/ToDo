//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 02/07/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categories = [Category]()
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    func saveCategories(){
        do {
            try context.save()
        } catch {
            print("error \(error)")
        }
        tableView.reloadData()
        
        
    }
    func loadCategories(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categories =  try context.fetch(request)
        } catch {
            print("Error \(error)")
        }
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Legg til ny kategori", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Legg til", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categories.append(newCategory)
            self.saveCategories()
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Legg til ny kategori"
            
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
}
