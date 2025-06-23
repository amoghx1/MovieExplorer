//
//  CDMovie+CoreDataProperties.swift
//  MovieExplorer
//
//  Created by Amogh Raut   on 22/06/25.
//
//

import Foundation
import CoreData


extension CDMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMovie> {
        return NSFetchRequest<CDMovie>(entityName: "CDMovie")
    }

    @NSManaged public var id: Int32
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var rating: Double
    @NSManaged public var posterImageData: Data?

}

extension CDMovie : Identifiable {

}

extension CDMovie {
    func toMovie() -> Movie {
        return Movie(
            id: Int(self.id),
            title: self.title,
            overview: self.overview,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            rating: self.rating
        )
    }
}

