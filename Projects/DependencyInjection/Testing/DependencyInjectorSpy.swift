//
//  Created by Vitor Conceicao.
//
//  github.com/vitor-rc1
//
//

import DependencyInjectionInterfaces
import Foundation

public final class DependencyInjectorSpy: DependencyInjector {
    public init() {}

    enum Method {
        case register
        case registerWithArgument
        case resolve
        case resolveWithArgument
    }

    // Container to hold registered services and their factories
    private var registeredServices: [String: Any] = [:]
    private var registeredServicesWithArgument: [String: Any] = [:]

    var calledMethods: [Method] = []

    private func typeIdentifier<T>(_ type: T.Type) -> String {
        return String(reflecting: type)
    }

    public func register<Service>(_ serviceType: Service.Type,
                                  factory: @escaping (DependencyResolver) -> Service) {
        calledMethods.append(.register)
        let identifier = typeIdentifier(serviceType)
        registeredServices[identifier] = factory
    }

    public func register<Service, Argument>(_ serviceType: Service.Type,
                                            factory: @escaping (DependencyResolver, Argument) -> Service) {
        calledMethods.append(.registerWithArgument)
        let identifier = typeIdentifier(serviceType)
        registeredServicesWithArgument[identifier] = factory
    }

    public func resolve<Service>() -> Service {
        calledMethods.append(.resolve)
        let identifier = typeIdentifier(Service.self)

        if let factory = registeredServices[identifier] as? (DependencyResolver) -> Service {
            return factory(self)
        }

        fatalError("No mock or registration found for \(identifier). Use stub(for:mock:) to configure a mock.")
    }

    public func resolve<Service, Argument>(_ serviceType: Service.Type,
                                           argument: Argument) -> Service {
        calledMethods.append(.resolveWithArgument)
        let identifier = typeIdentifier(serviceType)

        if let factory = registeredServicesWithArgument[identifier] as? (DependencyResolver, Argument) -> Service {
            return factory(self, argument)
        }

        fatalError("No mock or registration found for \(identifier). Use stub(for:mock:) to configure a mock.")
    }

    // MARK: - Test Helpers

    /// Clear all registrations and mocks
    public func reset() {
        registeredServices.removeAll()
        registeredServicesWithArgument.removeAll()
        calledMethods.removeAll()
    }
}
