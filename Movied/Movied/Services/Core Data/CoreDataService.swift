import UIKit
import CoreData

struct CoreDataService {
    
    static let shared = CoreDataService()
    
    private static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Name.persistantContainer)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    //MARK: - CRUD
    private func save() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func create<T: NSManagedObject>(completion: @escaping (T) -> Void ) {
        let newObject = T(context: context)
        completion(newObject)
        save()
    }
    
    private func load<T: NSManagedObject>(predicate: NSPredicate?,
                                          completion: @escaping (Result<[T]?, Error>) -> Void) {
        let request = NSFetchRequest<T>(entityName: "\(T.className)")
        request.predicate = predicate
        do {
            let result = try context.fetch(request)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func delete<T: NSManagedObject>(item: T, completion: (() -> Void)?) {
        context.delete(item)
        completion?()
        save()
    }
}
//MARK: - Favorite Movie
extension CoreDataService {
    func createFavoriteMovie(completion: @escaping (FavoriteMovie) -> Void ) {
        create(completion: completion)
    }
    
    func loadListOfFavoriteMovies(predicate: NSPredicate?,
                                  completion: @escaping (Result<[FavoriteMovie]?, Error>) -> Void) {
        load(predicate: predicate, completion: completion)
    }
    
    func deleteFavoriteMovie(item: FavoriteMovie, completion: (() -> Void)?) {
        delete(item: item, completion: completion)
    }
}
