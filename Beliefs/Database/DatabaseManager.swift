import Foundation
import SQLite3

class DatabaseManager {
    static let shared = DatabaseManager()
    var db: OpaquePointer?
    
    private init() {
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("BeliefsDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Error opening database")
        } else {
            createTable()
        }
    }
    
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Beliefs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        evidence TEXT);
        """
        
        var createTableStatement: OpaquePointer?
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Beliefs table created.")
            } else {
                print("Beliefs table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertBelief(title: String, evidence: String) {
        let insertStatementString = "INSERT INTO Beliefs (title, evidence) VALUES (?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 2, (evidence as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Insert failed: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("INSERT statement could not be prepared: \(errmsg)")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func fetchAllBeliefs() -> [Belief] {
        let queryStatementString = "SELECT * FROM Beliefs;"
        var queryStatement: OpaquePointer?
        var beliefs = [Belief]()
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let title = sqlite3_column_text(queryStatement, 1)
                let evidence = sqlite3_column_text(queryStatement, 2)
                
                let beliefTitle = title != nil ? String(cString: title!) : ""
                let beliefEvidence = evidence != nil ? String(cString: evidence!) : ""
                
                beliefs.append(Belief(id: Int(id), title: beliefTitle, evidence: beliefEvidence))
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SELECT statement could not be prepared: \(errmsg)")
        }
        sqlite3_finalize(queryStatement)
        return beliefs
    }
    
    func updateBelief(id: Int, title: String, evidence: String) {
        let updateStatementString = "UPDATE Beliefs SET title = ?, evidence = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (evidence as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Update failed: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("UPDATE statement could not be prepared: \(errmsg)")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func deleteBelief(id: Int) {
        let deleteStatementString = "DELETE FROM Beliefs WHERE id = ?;"
        var deleteStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Delete failed: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("DELETE statement could not be prepared: \(errmsg)")
        }
        sqlite3_finalize(deleteStatement)
    }
}
