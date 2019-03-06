//
//  Category.swift
//  ToDoApp
//
//  Created by Aleksei Chudin on 04/03/2019.
//  Copyright © 2019 Aleksei Chudin. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    // Relationship with class Item (realm DB)
    let items = List<Item>()
    
}
