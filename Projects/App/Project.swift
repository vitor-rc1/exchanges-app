import ProjectDescription
import ProjectDescriptionHelpers

let moduleName = "App"

let dependecies: [TargetDependency] = [
    .project(target: "DependencyInjection",
             path: "../DependencyInjection"),
    .project(target: "DependencyInjectionInterfaces",
             path: "../DependencyInjection"),
    .external(name: "Networking"),
    .external(name: "NetworkingInterfaces"),
]

let testDependencies: [TargetDependency] = [
    .target(name: moduleName),
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
                dependencies: testDependencies),
        .target(name: "\(moduleName)UITests",
                destinations: .iOS,
                product: .uiTests,
                bundleId: "com.vrc.exchanges.\(moduleName.lowercased()).uitests",
                deploymentTargets: iOSDeploymentTarget,
                infoPlist: .default,
                buildableFolders: ["UITests"],
                dependencies: testDependencies + [.xctest])

    ],
    schemes: [
        .scheme(name: moduleName,
                shared: true,
                buildAction: .buildAction(targets: [.project(path: ".", target: moduleName)]),
                testAction: .targets([
                    "\(moduleName)Tests",
                    // Disabled UITests for now, as they are not yet implemented
//                    "\(moduleName)UITests"
                ]
                                    ),
                runAction: .runAction(configuration: .debug,
                                      executable: .project(path: ".", target: moduleName),
                                      arguments: .arguments(environmentVariables: developmentEnv)))
    ]
)
