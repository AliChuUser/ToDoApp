//
//  Item.swift
//  ToDoApp
//
//  Created by Aleksei Chudin on 04/03/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // Relationship with class Category (realm DB)
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
