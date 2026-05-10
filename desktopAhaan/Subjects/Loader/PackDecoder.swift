import Foundation

/// Decodes a `SubjectPack` from JSON data with rich error reporting. The
/// pipeline guarantees schema correctness, but app builds can ship with stale
/// or hand-edited packs, so we surface the exact JSON path of any failure.
enum PackDecoder {

    enum DecodeError: LocalizedError {
        case fileNotFound(URL)
        case unreadable(URL, underlying: Error)
        case decode(URL, codingPath: String, message: String)

        var errorDescription: String? {
            switch self {
            case .fileNotFound(let url):
                return "Pack file not found: \(url.lastPathComponent)"
            case .unreadable(let url, let underlying):
                return "Could not read \(url.lastPathComponent): \(underlying.localizedDescription)"
            case .decode(let url, let codingPath, let message):
                return "Decode error in \(url.lastPathComponent) at \(codingPath): \(message)"
            }
        }
    }

    static func decode(from url: URL) throws -> SubjectPack {
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw DecodeError.unreadable(url, underlying: error)
        }
        do {
            return try JSONDecoder().decode(SubjectPack.self, from: data)
        } catch let DecodingError.keyNotFound(key, ctx) {
            throw DecodeError.decode(url, codingPath: pathString(ctx.codingPath),
                                     message: "missing key '\(key.stringValue)'")
        } catch let DecodingError.typeMismatch(_, ctx) {
            throw DecodeError.decode(url, codingPath: pathString(ctx.codingPath), message: ctx.debugDescription)
        } catch let DecodingError.valueNotFound(_, ctx) {
            throw DecodeError.decode(url, codingPath: pathString(ctx.codingPath), message: ctx.debugDescription)
        } catch let DecodingError.dataCorrupted(ctx) {
            throw DecodeError.decode(url, codingPath: pathString(ctx.codingPath), message: ctx.debugDescription)
        } catch {
            throw DecodeError.decode(url, codingPath: "<root>", message: error.localizedDescription)
        }
    }

    private static func pathString(_ path: [CodingKey]) -> String {
        path.map { $0.stringValue }.joined(separator: ".")
    }
}
