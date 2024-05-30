//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    

    //    var itemArray = ["Find Mike", "Bye Eggos", "Destory Demogorgon"]
    var itemArray = [Item]()
    
    var selelctedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
//    let defaults = UserDefaults.standard
    let dataFilePath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // save cx's local device
//        
//        
        print(dataFilePath)
    
//
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        //        newItem.done = true
//        itemArray.append(newItem)
//        
//        let newItem2 = Item()
//        newItem2.title = "Bye Eggos"
//        itemArray.append(newItem2)
//        
//        let newItem3 = Item()
//        newItem3.title = "Destory Demogorgon"
//        itemArray.append(newItem3)
//        
        //
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        //        }
//        loadItems()
    }
    
    // table view datasource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //for each of the cells, display the related content
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        item.done == true ? (cell.accessoryType = .checkmark) :  (cell.accessoryType = .none)
        
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
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        //        if(tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark) {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //        } else {
        //            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //        }
        saveItems()
        //        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //            print(textField.text)
            
            //(UIApplication.shared = get current app as an object
            
        
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selelctedCategory
            
            self.itemArray.append(newItem)
            
            //            self.itemArray.append(textField.text!)
            //            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            self.saveItems()
            
//            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            //            print(alertTextField.text)
            //            print("Hii")
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func saveItems() {
//        let encoder = PropertyListEncoder()
//        
        do {
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
            
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
//        let requrst: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selelctedCategory!.name!)
        
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
//
//        let compuondPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
//        
//        request.predicate = compuondPredicate
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
  
}

//MARK: - Search bar method
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
//        print(searchBar.text!)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptr = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptr]
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        loadItems(with: request, predicate: predicate)
        
      
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
