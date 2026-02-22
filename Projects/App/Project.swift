import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "App"

let dependecies: [TargetDependency] = [
    .project(target: "DependencyInjection",
             path: "../DependencyInjection"),
    .project(target: "DependencyInjectionInterfaces",
             path: "../DependencyInjection"),
    .project(target: "Home",
             path: "../Home"),
    .project(target: "HomeInterfaces",
             path: "../Home"),
    .project(target: "Detail",
             path: "../Detail"),
    .project(target: "DetailInterfaces",
             path: "../Detail"),
    .project(target: "NavigationInterfaces",
             path: "../Navigation"),
    .external(name: "Networking"),
    .external(name: "NetworkingInterfaces"),
]

let testDependencies: [TargetDependency] = [
    .target(name: moduleName),
    .project(target: "DependencyInjectionTesting",
             path: "../DependencyInjection"),
    .project(target: "HomeTesting",
             path: "../Home"),
    .project(target: "NavigationTesting",
             path: "../Navigation"),
]

let project = Project(
    name: moduleName,
    options: .options(automaticSchemesOptions: .disabled),
    settings: .settings(
        base: commonSettings
    ),
    targets: [
        .target(name: moduleName,
                destinations: .iOS,
                product: .app,
                bundleId: "com.vrc.exchanges.\(moduleName.lowercased())",
                deploymentTargets: iOSDeploymentTarget,
                infoPlist: "Info.plist",
                buildableFolders: ["Sources", "Resources"],
                scripts: [
                    swiftLintScript
                ],
                dependencies: dependecies
               ),
        .target(name: "\(moduleName)Tests",
                destinations: .iOS,
                product: .unitTests,
                bundleId: "com.vrc.exchanges.\(moduleName.lowercased()).tests",
                deploymentTargets: iOSDeploymentTarget,
                infoPlist: .default,
                buildableFolders: ["Tests"],
                dependencies: testDependencies)

    ],
    schemes: [
        .scheme(name: moduleName,
                shared: true,
                buildAction: .buildAction(targets: [.project(path: ".", target: moduleName)]),
                testAction: .targets([
                    "\(moduleName)Tests"
                ],
                                     arguments: .arguments(environmentVariables: ["IS_TESTING": "true"])),
                runAction: .runAction(configuration: .debug,
                                      executable: .project(path: ".", target: moduleName),
                                      arguments: .arguments(environmentVariables: envs)))
    ]
)
