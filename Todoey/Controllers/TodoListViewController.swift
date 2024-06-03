//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: SwipeTableViewController {
    
    
    //    var itemArray = ["Find Mike", "Bye Eggos", "Destory Demogorgon"]
    var todoItems : Results<Item>?
    let realm = try! Realm()
    var selelctedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    //    let defaults = UserDefaults.standard
    //    let dataFilePath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.lightGray
        // save cx's local device
        //
        //
        //        print(dataFilePath)
        
        //
        //        let newItem = Item()
        //        newItem.title = "Find Mike"
        //        //        newItem.done = true
        //        itemArray.append(newItem)
        //
        //        let newItem2 = Item()
        //        newItem2.title = "Bye Eggos"sfas
        //        itemArray.append(newItem2)
        //
        //        let newItem3 = Item()
        //        newItem3.title = "Destory Demogorgon"
        //
        //
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
        //        loadItems()
    }
    
    // table view datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //for each of the cells, display the related content
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            item.done == true ? (cell.accessoryType = .checkmark) :  (cell.accessoryType = .none)
        } else {
            cell.textLabel?.text = "No iteams added"
        }
        
        
        
        //        if item.done == true {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        return cell
        
    }
    
    //tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //the indexPath refering to the row that selected
        //
        
        /*
         Delete an item from the context, the order matters
         
         1. should delete the ones in context
         context.delete(itemArray[indexPath.row])
         2. remove it from the array
         itemArray.remove(at: indexPath.row)
         */
        //add a checkmark if there is no checkmark, otherwise add it
        // checkmark should go with data instead of cells
        
        //        if itemArray[indexPath.row].done == false {
        //            itemArray[indexPath.row].done = true
        //        } else {
        //            itemArray[indexPath.row].done = false
        //        }
        //
        //        todoItems[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                    // realm.delete(item)
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    //add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selelctedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    //Mark - Model Manipulation Methods
    func loadItems() {
        todoItems = selelctedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            }catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}
    
    
    //MARK: - Search bar method
    extension TodoListViewController: UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            
//            //        print(searchBar.text!)
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            
//            let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
//            
//            request.sortDescriptors = [sortDescriptr]
            
            //        do {
            //            itemArray = try context.fetch(request)
            //        } catch {
            //            print("Error fetching data from context \(error)")
            //        }
//            loadItems(with: request, predicate: predicate)
//            
            todoItems = todoItems?.filter( "title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchBar.text?.count == 0 {
                loadItems()
                DispatchQueue.main.async {
                    searchBar.resignFirstResponder()
                }
                
            }
        }
        
        
    }
