//
//  ViewController.swift
//  ToDoApp
//
//  Created by Aleksei Chudin on 27/02/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit
import RealmSwift
//import CoreData

class ToDoTableView: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray: Results<Item>?
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        // loadItems() method is set in the selectedCategory property
        
    }
    
    //MARK - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            //Ternary operator for checkmark
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    //MARK - TableView Delegate Method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = itemArray?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items

    @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let addItemAction = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            
            // saving item in the Realm DB
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
            
//            self.save(item: newItem)
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat new item"
            textField = alertTextField
        }
        
        alert.addAction(addItemAction)
        alert.addAction(cancelAlertAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK - Data Manipulation Methods
    
//    func save(item: Item) {
//
//        do {
//            try realm.write {
//                realm.add(item)
//            }
//        } catch {
//            print("Error saving items \(error)")
//        }
//
////        do {
////            try context.save()
////        } catch {
////            print("Error saving context \(error)")
////        }
//
//        tableView.reloadData()
//    }
    
    func loadItems(//with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil
        ) {
        
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate {
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        } else {
//            request.predicate = categoryPredicate
//        }
//
//            do {
//                itemArray = try context.fetch(request)
//            } catch {
//                print("Error fetching data from context \(error)")
//            }

        tableView.reloadData()
    }
    
}

//MARK - Search Bar Methods

extension ToDoTableView: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
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

