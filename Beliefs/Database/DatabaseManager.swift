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
        }
        
        createTable()
    }
    
    private func createTable() {
        let createTableString = """
        CREATE TABLE IF NOT EXISTS Beliefs(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
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
            sqlite3_bind_text(insertStatement, 1, title, -1, nil)
            sqlite3_bind_text(insertStatement, 2, evidence, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
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
                let title = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let evidence = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                beliefs.append(Belief(id: Int(id), title: title, evidence: evidence))
                print("Query Result:")
                print("\(id) | \(title) | \(evidence)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return beliefs
    }
    
    func updateBelief(id: Int, title: String, evidence: String) {
        let updateStatementString = "UPDATE Beliefs SET title = ?, evidence = ? WHERE id = ?;"
        var updateStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, title, -1, nil)
            sqlite3_bind_text(updateStatement, 2, evidence, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(id))
            
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("UPDATE statement could not be prepared.")
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
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared.")
        }
        sqlite3_finalize(deleteStatement)
    }
}

