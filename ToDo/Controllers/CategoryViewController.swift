//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 02/07/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    //
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories() //henter alle kategorirer
        tableView.separatorStyle = .none
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //hvis null kategorier returnerer 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "Ingen kategorier er lagt til" //hvis det kun er 1
        cell.backgroundColor = UIColor.randomFlat
        return cell
    }
    
    func save(category :  Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error \(error)")
        }
        tableView.reloadData()
        
        
    }
    func loadCategories(){
        
        categories = realm.objects(Category.self)
      //  let request : NSFetchRequest<Category> = Category.fetchRequest()
      //  do {
       //     categories =  try context.fetch(request)
       // } catch {
        //    print("Error \(error)")
       // }
        tableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        // sender oss gjennom seguen i storyboardet
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //vet hvilken kategori som er valgt og filtrerer i seguen deretter
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Legg til ny kategori", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Legg til", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory) //kaller på save metoden vår
            
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            
            textField = field
            textField.placeholder = "Legg til ny kategori"
            
            
        }
        
        present(alert, animated: true, completion: nil)
        
        
    }
}
