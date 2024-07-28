import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: OpaquePointer?
    
    private init() {
        // Initialize SQLite Database
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("BeliefsDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            createTables()
        }
    }
    
    private func createTables() {
        let createBeliefsTableString = """
        CREATE TABLE IF NOT EXISTS Beliefs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        evidence TEXT,
        category TEXT NOT NULL DEFAULT 'Misc');
        """
        
        let createCategoriesTableString = """
        CREATE TABLE IF NOT EXISTS Categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE);
        """
        
        executeStatement(sql: createBeliefsTableString, errorMessage: "Error creating Beliefs table")
        executeStatement(sql: createCategoriesTableString, errorMessage: "Error creating Categories table")
    }
    
    private func executeStatement(sql: String, errorMessage: String) {
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("\(sql) executed successfully.")
            } else {
                print(errorMessage)
            }
        } else {
            print("Statement could not be prepared: \(errorMessage)")
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - Belief Operations
    
    func insertBelief(title: String, evidence: String, category: String) {
        let insertStatement = "INSERT INTO Beliefs (title, evidence, category) VALUES (?, ?, ?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatement, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (evidence as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (category as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Belief successfully inserted.")
            } else {
                print("Failed to insert belief: \(String(cString: sqlite3_errmsg(db)!))")
            }
        } else {
            print("INSERT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
    }
    
    func fetchAllBeliefs() -> [Belief] {
        let queryStatement = "SELECT * FROM Beliefs;"
        var statement: OpaquePointer?
        var beliefs = [Belief]()
        
        if sqlite3_prepare_v2(db, queryStatement, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let title = String(
                    describing: String(
                        cString: sqlite3_column_text(statement, 1)
                    )
                )
                let evidence = String(
                    describing: String(
                        cString: sqlite3_column_text(statement, 2)
                    )
                )
                let category = String(
                    describing: String(
                        cString: sqlite3_column_text(statement, 3)
                    )
                )
                
                beliefs.append(Belief(id: Int(id), title: title, evidence: evidence, category: category))
            }
        } else {
            print("SELECT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
        return beliefs
    }
    
    func updateBelief(id: Int, title: String, evidence: String, category: String) {
        let updateStatement = "UPDATE Beliefs SET title = ?, evidence = ?, category = ? WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatement, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (evidence as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (category as NSString).utf8String, -1, nil)
            sqlite3_bind_int(statement, 4, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Belief successfully updated.")
            } else {
                print("Failed to update belief: \(String(cString: sqlite3_errmsg(db)!))")
            }
        } else {
            print("UPDATE statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
    }
    
    func deleteBelief(id: Int) {
        let deleteStatement = "DELETE FROM Beliefs WHERE id = ?;"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatement, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_int(statement, 1, Int32(id))
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Belief successfully deleted.")
            } else {
                print("Failed to delete belief: \(String(cString: sqlite3_errmsg(db)!))")
            }
        } else {
            print("DELETE statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
    }
    
    // MARK: - Category Operations
    
    func insertCategory(name: String) {
        let insertStatement = "INSERT INTO Categories (name) VALUES (?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatement, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Category successfully inserted.")
            } else {
                print("Failed to insert category: \(String(cString: sqlite3_errmsg(db)!))")
            }
        } else {
            print("INSERT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
    }
    
    func fetchAllCategories() -> [Category] {
        let queryStatement = "SELECT * FROM Categories;"
        var statement: OpaquePointer?
        var categories = [Category]()
        
        if sqlite3_prepare_v2(db, queryStatement, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                
                categories.append(Category(id: Int(id), name: name))
            }
        } else {
            print("SELECT statement could not be prepared: \(String(cString: sqlite3_errmsg(db)!))")
        }
        sqlite3_finalize(statement)
        return categories
    }
}
