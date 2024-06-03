//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Yun Ni on 2024-05-29.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import SwipeCellKit

class CategoryTableViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadItems()
        loadCategories()
    }
    
    // MARK: - Table view Datasource Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        
        
        return cell
        
    }
    //MARK: - Table view Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let desVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            desVC.selelctedCategory = categories?[indexPath.row] 
        }
    }
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            (action) in
//            let newCategory = Category(context: self.context)
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //for realm, no need to update the results, it will update itself.
//
//            self.categories.append(newCategory)
            
            self.saveCategory(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            field.placeholder = "Add a new category"
            textField = field
        }
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    func saveCategory(category: Category) {
        do {
//            try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()
        
    }
    
//    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
//                
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        
//        tableView.reloadData()
//        
//        
//    }
    
    func loadCategories() {
        //fetch data from realm
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //delete data from swip
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}

