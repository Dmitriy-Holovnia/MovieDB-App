//
//  MOMovie+CoreDataProperties.swift
//  MovieDB App
//
//  Created by Dmitiy Golovnia on 30.07.2021.
//
//

import Foundation
import CoreData


extension MOMovie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOMovie> {
        return NSFetchRequest<MOMovie>(entityName: "MOMovie")
    }

    @NSManaged public var id: Int64
    @NSManaged public var adult: Bool
    @NSManaged public var posterPath: String?
    @NSManaged public var overview: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var voteAverage: Double

}

extension MOMovie : Identifiable, DomainModel {
    typealias DomainModelType = Movie
    
    func toDomainModel() -> Movie {
        Movie(id: Int(self.id),
              title: self.title,
              voteAverage: self.voteAverage,
              adult: self.adult,
              posterPath: self.posterPath,
              overview: self.overview,
              releaseDate: self.releaseDate)
    }
}
