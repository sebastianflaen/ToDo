//
//  Category.swift
//  ToDo
//
//  Created by Sebastian Sundet Flaen on 15/07/2019.
//  Copyright © 2019 ssflaen. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name: String = ""
    //dynamic så den kan oppdage endringen mens applikasjonen kjører
    
    let items = List<Item>()
    
}
