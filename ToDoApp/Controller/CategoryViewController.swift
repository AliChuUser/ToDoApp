//
//  CategoryViewController.swift
//  ToDoApp
//
//  Created by Aleksei Chudin on 02/03/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
//import CoreData

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
        
        tableView.separatorStyle = .none
    }

    //MARK: - TableView Datasource Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // nil coalescing operator
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            
            let colour = UIColor(hexString: category.colorCategory)
            cell.backgroundColor = colour
            cell.textLabel?.textColor = ContrastColorOf(colour ?? FlatWhite(), returnFlat: true)
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Method
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let dvc = segue.destination as! ToDoTableView
        
        if let indexPath = tableView.indexPathForSelectedRow {
            dvc.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try realm.write {
                if let deletCategory = categoryArray?[indexPath.row] {
                    realm.delete(deletCategory)
                }
            }
        } catch {
            print("Error deleting category \(error)" )
        }
    }
    
    //MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (categoryName) in
            categoryName.placeholder = "New category name"
            textField = categoryName
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategoty = Category()
            newCategoty.name = textField.text!
            newCategoty.colorCategory = UIColor.randomFlat.hexValue()
            
//            self.categoryArray.append(newCategoty)
            
            self.save(category: newCategoty)
        }
        
        let cancelAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAlertAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)
        
//        request: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categoryArray = try context.fetch(request)
//        } catch {
//            print("Error fetching category data from context \(error)")
//        }
//
        tableView.reloadData()
    }
    
}


