//
//  Bundle-Decodable.swift
//  Snowseeker
//
//  Created by Mylla Sasaki on 18/06/26.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode(T.self, from: data)
        }
        catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle: missing key \(key). \(context.debugDescription)")
        }
        catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle: type mismatch. \(context.debugDescription)")
        }
        catch DecodingError.valueNotFound(_, let context) {
            fatalError("Failed to decode \(file) from bundle: value not found. \(context.debugDescription)")
        }
        catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
