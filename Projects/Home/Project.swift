import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "Home"

let dependecies: [TargetDependency] = [
    .project(target: "DependencyInjectionInterfaces",
             path: "../DependencyInjection"),
    .project(target: "DesignSystem",
             path: "../DesignSystem"),
    .project(target: "DetailInterfaces",
             path: "../Detail"),
    .project(target: "Helpers",
             path: "../Helpers"),
    .external(name: "NetworkingInterfaces"),
]

let interfaceDependecies: [TargetDependency] = [
    .project(target: "NavigationInterfaces",
             path: "../Navigation"),
]

let testsDependecies: [TargetDependency] = [
    .project(target: "DependencyInjectionTesting",
             path: "../DependencyInjection"),
    .project(target: "DetailTesting",
             path: "../Detail"),
    .project(target: "NavigationTesting",
             path: "../Navigation"),
]

let project = Project.templateModule(named: moduleName,
                                     targets: [.source,. interfaces, .test, .testing],
                                     dependencies: dependecies,
                                     testDependencies: testsDependecies,
                                     interfaceDependecies: interfaceDependecies)
