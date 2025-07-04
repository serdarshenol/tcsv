import Foundation

struct FileHelper {
    static func exportLockedCSV(entries: [UserEntry]) -> URL? {
        let csvLines = entries.map { "\($0.group),\($0.name),\($0.email)" }
        let fullCSV = csvLines.joined(separator: "\n")
        guard let base64 = fullCSV.data(using: .utf8)?.base64EncodedData() else { return nil }

        let url = FileManager.default.temporaryDirectory.appendingPathComponent("locked_data.lcsv")
        try? base64.write(to: url)
        return url
    }

    static func readLockedCSV(from url: URL) -> [UserEntry]? {
        // Start accessing file (required for iCloud / external files)
        guard url.startAccessingSecurityScopedResource() else {
            print("❌ Failed to access security-scoped resource")
            return nil
        }

        defer { url.stopAccessingSecurityScopedResource() }

        do {
            let rawData = try Data(contentsOf: url)
            print("✅ File loaded: \(rawData.count) bytes")

            guard let decodedData = Data(base64Encoded: rawData) else {
                print("❌ Failed to decode Base64")
                return nil
            }

            guard let content = String(data: decodedData, encoding: .utf8) else {
                print("❌ Failed to convert to UTF-8 string")
                return nil
            }

            print("✅ Decoded content: \n\(content)")

            let lines = content.components(separatedBy: "\n")
            let entries = lines.compactMap { line -> UserEntry? in
                let parts = line.components(separatedBy: ",")
                guard parts.count == 3 else {
                    print("❌ Invalid line: \(line)")
                    return nil
                }
                return UserEntry(group: parts[0], name: parts[1], email: parts[2])
            }

            return entries
        } catch {
            print("❌ Error reading file: \(error)")
            return nil
        }
    }

}
