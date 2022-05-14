//from apple's swiftui tutorial on persisting data

import Foundation
import SwiftUI

class BgmTrackStore: ObservableObject {
    @Published var bgmTracks: [bgmTrack] = []
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent("bgmtracks.data")
    }
    
    static func load(completion: @escaping (Result<[bgmTrack], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let bgmTracks = try JSONDecoder().decode([bgmTrack].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(bgmTracks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(bgmtracks: [bgmTrack], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(bgmtracks)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(bgmtracks.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
