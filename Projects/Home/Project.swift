import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "Home"

let dependecies: [TargetDependency] = [
    .project(target: "DependencyInjectionInterfaces",
             path: "../DependencyInjection"),
    .project(target: "DesignSystem",
    path: "../DesignSystem"),
    .external(name: "NetworkingInterfaces"),
]

let project = Project.templateModule(named: moduleName,
                                     targets: [.source,. interfaces, .test],
                                     dependencies: dependecies)
