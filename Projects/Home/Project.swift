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

let interfaceDependecies: [TargetDependency] = [
    .project(target: "NavigationInterfaces",
             path: "../Navigation"),
]

let project = Project.templateModule(named: moduleName,
                                     targets: [.source,. interfaces, .test, .testing],
                                     dependencies: dependecies,
                                     interfaceDependecies: interfaceDependecies)
