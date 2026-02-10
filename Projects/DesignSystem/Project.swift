import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "DesignSystem"

let dependecies: [TargetDependency] = []

let testDependencies: [TargetDependency] = [
    .external(name: "SnapshotTesting")
]

let project = Project.templateModule(named: moduleName,
                                     targets: [.source, .test],
                                     dependencies: dependecies,
                                     testDependencies: testDependencies)
