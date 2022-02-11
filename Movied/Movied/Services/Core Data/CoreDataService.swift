import UIKit
import CoreData

struct CoreDataService {
    
    static let shared = CoreDataService()
    
    private static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private let context = appDelegate?.persistentContainer.viewContext
    
    private func save() {
        do {
            try context?.save()
        } catch {
            print(CoreDataError.errorSaving.rawValue)
        }
    }
    
    private func create<T: NSManagedObject>(completion: @escaping (T) -> Void ) {
        if let context = context {
            let newObject = T(context: context)
            completion(newObject)
        }
        save()
    }
    
    private func load<T: NSManagedObject>(predicate: NSPredicate?,
                                          completion: @escaping (Result<[T]?, CoreDataError>) -> Void) {
        let request = NSFetchRequest<T>(entityName: "\(T.className)")
        request.predicate = predicate
        do {
            let result = try context?.fetch(request) ?? [T]()
            completion(.success(result))
        } catch {
            completion(.failure(.errorFetching))
        }
    }
    
    private func delete<T: NSManagedObject>(item: T, completion: (() -> Void)?) {
        context?.delete(item)
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
                                  completion: @escaping (Result<[FavoriteMovie]?, CoreDataError>) -> Void) {
        load(predicate: predicate, completion: completion)
    }
    
    func deleteFavoriteMovie(item: FavoriteMovie, completion: (() -> Void)?) {
        delete(item: item, completion: completion)
    }
}
