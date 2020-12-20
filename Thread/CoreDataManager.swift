import UIKit
import CoreData

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName:String = "Users"
    
    func getUsers(ascending: Bool = false) -> [Users] {
        var models: [Users] = [Users]()
        
        if let context = context {
            let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest<NSManagedObject>(entityName: modelName)
            fetchRequest.sortDescriptors = [idSort]
            
            do {
                if let fetchResult: [Users] = try context.fetch(fetchRequest) as? [Users] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("\(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    func saveUser(id: Int32, name: String, score: Int32, date: Date, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context, let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelName, in: context) {
            if let user: Users = NSManagedObject(entity: entity, insertInto: context) as? Users {
                user.id = id
                user.name = name
                user.score = score
                user.date = date
                
                contextSave { success in
                    onSuccess(success)
                }
            }
        }
    }
}

extension CoreDataManager {
    fileprivate func filteredRequest(id: Int32) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.predicate = NSPredicate(format: "id = %@", NSNumber(value: id))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }}
