import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "Detail"

let dependecies: [TargetDependency] = [
    .project(target: "DependencyInjectionInterfaces",
             path: "../DependencyInjection"),
    .project(target: "DesignSystem",
             path: "../DesignSystem"),
    .project(target: "HomeInterfaces",
             path: "../Home"),
    .external(name: "NetworkingInterfaces"),
]

let interfaceDependecies: [TargetDependency] = [
    .project(target: "NavigationInterfaces",
             path: "../Navigation"),
]

let project = Project.templateModule(named: moduleName,
                                     targets: [.source, .interfaces, .test, .testing],
                                     dependencies: dependecies,
                                     interfaceDependecies: interfaceDependecies)
