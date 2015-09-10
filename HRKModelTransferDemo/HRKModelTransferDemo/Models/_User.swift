// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.swift instead.

import CoreData

public enum UserAttributes: String {
    case created_at = "created_at"
    case id = "id"
    case name = "name"
    case updated_at = "updated_at"
}

public enum UserRelationships: String {
    case posts = "posts"
}

@objc public
class _User: NSManagedObject {

    // MARK: - Class methods

    public class func entityName () -> String {
        return "User"
    }

    public class func entity(managedObjectContext: NSManagedObjectContext!) -> NSEntityDescription! {
        return NSEntityDescription.entityForName(self.entityName(), inManagedObjectContext: managedObjectContext);
    }

    // MARK: - Life cycle methods

    public override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    public convenience init(managedObjectContext: NSManagedObjectContext!) {
        let entity = _User.entity(managedObjectContext)
        self.init(entity: entity, insertIntoManagedObjectContext: managedObjectContext)
    }

    // MARK: - Properties

    @NSManaged public
    var created_at: NSDate?

    // func validateCreated_at(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var id: NSNumber?

    // func validateId(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var name: String?

    // func validateName(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    @NSManaged public
    var updated_at: NSDate?

    // func validateUpdated_at(value: AutoreleasingUnsafeMutablePointer<AnyObject>, error: NSErrorPointer) -> Bool {}

    // MARK: - Relationships

    @NSManaged public
    var posts: NSOrderedSet

}

extension _User {

    func addPosts(objects: NSOrderedSet) {
        let mutable = self.posts.mutableCopy() as! NSMutableOrderedSet
        mutable.unionOrderedSet(objects)
        self.posts = mutable.copy() as! NSOrderedSet
    }

    func removePosts(objects: NSOrderedSet) {
        let mutable = self.posts.mutableCopy() as! NSMutableOrderedSet
        mutable.minusOrderedSet(objects)
        self.posts = mutable.copy() as! NSOrderedSet
    }

    func addPostsObject(value: Post!) {
        let mutable = self.posts.mutableCopy() as! NSMutableOrderedSet
        mutable.addObject(value)
        self.posts = mutable.copy() as! NSOrderedSet
    }

    func removePostsObject(value: Post!) {
        let mutable = self.posts.mutableCopy() as! NSMutableOrderedSet
        mutable.removeObject(value)
        self.posts = mutable.copy() as! NSOrderedSet
    }

}

