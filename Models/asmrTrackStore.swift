//from apple's swiftui tutorial on persisting data

import Foundation
import SwiftUI

class AsmrTrackStore: ObservableObject {
    @Published var asmrTracks: [asmrTrack] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("asmrtracks.data")
    }
    
    static func load(completion: @escaping (Result<[asmrTrack], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let asmrTracks = try JSONDecoder().decode([asmrTrack].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(asmrTracks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(asmrtracks: [asmrTrack], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(asmrtracks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(asmrtracks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
