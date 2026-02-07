import Danger
import Foundation
import DangerSwiftSlather

let danger = Danger()

// 1. Basic PR checks
let allSourceFiles = danger.git.modifiedFiles + danger.git.createdFiles
let swiftFiles = allSourceFiles.filter { $0.hasSuffix(".swift") }

if danger.github.pullRequest.title.contains("WIP") {
    warn("PR is still Work in Progress")
}

// 2. Report Coverage
let coverageFolder = "all-reports"
let fileManager = FileManager.default

if let reportFolders = try? fileManager.contentsOfDirectory(atPath: coverageFolder).filter({ $0.hasPrefix("reports-") }) {
    for folder in reportFolders {
        let targetName = folder.replacingOccurrences(of: "reports-", with: "")
        let coberturaPath = "\(coverageFolder)/\(folder)/test_output/cobertura.xml"
        if fileManager.fileExists(atPath: coberturaPath) {
            SlatherCoverage().report(coberturaXmlPath: coberturaPath, minimumCoverage: 80.0)
        } else {
            warn("Coverage report not found for \(targetName)")
        }
    }
}