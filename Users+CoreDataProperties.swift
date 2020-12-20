import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var score: Int32
    @NSManaged public var date: Date?
}

extension Users : Identifiable {

}
