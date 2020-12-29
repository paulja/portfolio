//
//  Bundle-Decodable.swift
//  Portfolio
//
//  Created by Paul Jackson on 13/11/2020.
//

import Foundation

// swiftlint:disable line_length

extension Bundle {
    /// Generic function to decode an object `<T>` from a JSON file contained within the bundle.
    ///
    /// All errors result in a `fatalError` and crash the app.
    /// 
    /// - Parameters:
    ///   - type: The type to decode in to.
    ///   - file: The source JSON file.
    ///   - dateDecodingStrategy: Override for the default date decoding strategy (`.deferredToDate`)
    ///   - keyDecodingStrategy: Override for the default key decoding strategy (`.useDefaultKeys`)
    /// - Returns: An instance of the typed object.
    func decode<T: Decodable>(
        _ type: T.Type,
        from file: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {

        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        decoder.keyDecodingStrategy = keyDecodingStrategy

        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key.stringValue)' not found – \(context.debugDescription)")
        } catch DecodingError.typeMismatch(_, let context) {
            fatalError("Failed to decode \(file) from bundle due to type mismatch – \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value – \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(_) {
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON")
        } catch {
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription)")
        }
    }
}
