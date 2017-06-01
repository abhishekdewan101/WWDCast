//
//  CoreDataController.swift
//  WWDCast
//
//  Created by Maksym Shcheglov on 22/05/2017.
//  Copyright © 2017 Maksym Shcheglov. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

protocol EntityRepresentable {
    associatedtype EntityType: CoreDataRepresentable

    func asEntity() -> EntityType
}

protocol CoreDataPersistable: NSFetchRequestResult {
    static var primaryAttribute: String {get}
    static var entityName: String {get}
    static func fetchRequest() -> NSFetchRequest<Self>
}

protocol CoreDataRepresentable {
    associatedtype CoreDataType: CoreDataPersistable

    var uid: String {get}

    func update(object: CoreDataType)
}

extension CoreDataRepresentable where Self.CoreDataType: NSManagedObject {

    func sync(in context: NSManagedObjectContext) -> Observable<CoreDataType> {
        return context.rx.sync(entity: self, update: update)
    }

    func update(in context: NSManagedObjectContext) -> Observable<CoreDataType?> {
        return context.rx.update(entity: self, update: update)
    }
}

extension Session: CoreDataRepresentable {
    typealias CoreDataType = SessionManagedObject

    var uid: String {
        return self.uniqueId
    }

    func update(object: CoreDataType) {
        object.uniqueId = self.uniqueId
        object.id = Int16(self.id)
        object.year = Int16(self.year.rawValue)
        object.track = Int16(self.track.rawValue)
        object.title = self.title
        object.summary = self.summary
        object.video = self.video?.absoluteString
        object.captions = self.captions?.absoluteString
        object.thumbnail = self.thumbnail.absoluteString
        object.favorite = self.favorite
        object.platforms = self.platforms.isEmpty ? "" : self.platforms.map({ $0.rawValue }).joined(separator: "#")
    }

}

final class CoreDataController {

    private let persistentContainer: NSPersistentContainer
    private var isStoreLoaded: Bool = false

    var viewContext: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    init?(name: String) {
        self.persistentContainer = NSPersistentContainer(name: name)
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        try? self.persistentContainer.viewContext.setQueryGenerationFrom(.current)
    }

    func loadStore(completion: @escaping (Error?) -> Void) {
        if self.isStoreLoaded {
            completion(nil)
            return
        }

        self.persistentContainer.loadPersistentStores { _, error in
            if error == nil {
                self.isStoreLoaded = true
            }

            completion(error)
        }
    }

    func newBackgroundContext() -> NSManagedObjectContext {
        return self.persistentContainer.newBackgroundContext()
    }

    /// Executes a block on the main queue
    ///
    /// - Parameter block: A block to execute on the main queue
    func perform(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }

    /// Synchronously performs a given block on the main queue
    ///
    /// - Parameter block: A block to execute on the main queue
    func performAndWait(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.performAndWait {
            block(self.viewContext)
        }
    }

    /// Executes a block on a new private queue context.
    ///
    /// - Parameter block: A block to execute on a newly created private queue context
    func performInBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        return self.persistentContainer.performBackgroundTask(block)
    }

}
