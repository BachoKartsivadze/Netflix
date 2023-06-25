//
//  DBManager.swift
//  CoreDataPractice
//
//  Created by bacho kartsivadze on 04.01.23.
//

import Foundation
import CoreData

final class DBManager {
    
    static var shared = DBManager()
    
    private init () {} // რომ ვეღარავინ შექმნას
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NetflicCloneModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    enum dataBaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.media_type = model.media_type
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.id = Int64(model.id)
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            print(error.localizedDescription)
            completion(.failure(dataBaseError.failedToSaveData))
        }
    }
    
    
    func fetchingTitlesFromDataBase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        let context = persistentContainer.viewContext
        
        let request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch {
            completion(.failure(dataBaseError.failedToFetchData))
        }
        
    }
    
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        context.delete(model) // askint the dataBase meneger to delete certain object
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(dataBaseError.failedToDeleteData))
        }
    }
}
