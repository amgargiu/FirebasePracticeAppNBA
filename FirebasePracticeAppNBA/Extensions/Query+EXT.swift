//
//  Query+EXT.swift
//  SwiftfulFirebase
//
//  Created by Antonio Gargiulo on 7/11/26.
//

import Foundation


// just imported for publisher extension for Listener
import Combine
import FirebaseFirestore


/*
Custom Swift type to use when needing to use this DocumentSnapshot in Views or VM
Useful for storing the last doc for pagination
 
Example seen in ProductsViewModel (when scrolling through for ProductsView) - in P9
 */

struct DocumentSnapshotContainer {
    let documentSnapshot: DocumentSnapshot
}

extension Query {
    
    
//    func getDocuments2<T>(as type: T.Type ) async throws -> [T] where T: Decodable {
//        let snapshot = try await self.getDocuments()
//        return try snapshot.documents.map { document in
//            try document.data(as: T.self)
//        }
//    }
    
    // Function that jsut returns the decoded docs (using other func as basis)
    func getDocuments2<T>(as type: T.Type ) async throws -> [T] where T: Decodable {
        return try await getDocumentsWithSnapshot(as: type).products
    }
    
    // For Pagination
    // function that returns decoded docuements AND last Doc snapshot
    func getDocumentsWithSnapshot<T>(as type: T.Type ) async throws -> (products: [T], lastDoc: DocumentSnapshotContainer?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let products = try snapshot.documents.map { document in
            try document.data(as: T.self)
        }
        
        var container: DocumentSnapshotContainer? = nil
        if let lastDoc = snapshot.documents.last {
            container = DocumentSnapshotContainer(documentSnapshot: lastDoc)
        }
        
        return (products, container)
    }
    
    // .start(afterDocument: ) did not take in optional last doc - which required aus to do some if { } to unwrap the last doc parameter whench fetching
    // Instead use this to avoid that - last doc can be optional - if it is just return self (the collection)
    
    func startOptional(afterDocument lastDocument: DocumentSnapshotContainer?) -> Query {
        
        let optionalLastDocument = lastDocument?.documentSnapshot
        
        if let optionalLastDocument {
            return self
                .start(afterDocument: optionalLastDocument)
        } else {
            return self
        }
    }
    
    // can use this to fnd the amount of docs in a colleciton without fetching - used to understand if pagaimation needed
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
    
    
    
    // from listener video - converting a listener (to decode as well) to a combine publisher, also return listener to cancel later
    
    // Realistically probably want to convert this into an async stream
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T : Decodable {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let products: [T] = documents.compactMap({ try? $0.data(as: T.self) })
            publisher.send(products)
        }
        
        return (publisher.eraseToAnyPublisher(), listener) // retunr listener just to reference for cancel
    }
    
}
