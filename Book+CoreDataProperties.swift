//
//  Book+CoreDataProperties.swift
//

import Foundation
import CoreData

extension Book {

    @NSManaged var bookName: String?
    @NSManaged var author: String?
    @NSManaged var price: NSNumber?

}
