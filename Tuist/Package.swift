// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        productTypes: [
            "Swinject": .framework,
            "NetworkingInterfaces": .framework,
            "Networking": .framework
        ]
    )
#endif

let package = Package(
    name: "ExchangesApp",
    dependencies: [
        .package(url: "https://github.com/Swinject/Swinject.git", from: "2.9.1"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.18.9"),
        .package(url: "https://github.com/vitor-rc1/networking-package.git", from: "1.2.0")
    ]
)
