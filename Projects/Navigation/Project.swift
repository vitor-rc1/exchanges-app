import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "Navigation"

let dependecies: [TargetDependency] = []

let project = Project.templateModule(named: moduleName,
                                     targets: [.interfaces, .testing],
                                     dependencies: dependecies)
