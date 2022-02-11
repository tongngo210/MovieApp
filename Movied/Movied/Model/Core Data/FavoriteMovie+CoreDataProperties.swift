import Foundation
import CoreData

extension FavoriteMovie {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteMovie> {
        return NSFetchRequest<FavoriteMovie>(entityName: "FavoriteMovie")
    }
    
    @NSManaged public var imageURLString: String?
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var rate: Double
    @NSManaged public var overview: String?
}

extension FavoriteMovie : Identifiable {

}
