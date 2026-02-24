import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "Helpers"

let project = Project.templateModule(named: moduleName,
                                     targets: [.source, .test])
