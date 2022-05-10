/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

/// Defines a shared feature registry for global usage.
internal enum DatadogRegistry {
    /// The default feature registry for global usage.
    ///
    /// Instances complying to `DatadogFeatureRegistry` can be used
    /// as a global feature registry. By default, `.default` returns a no-op
    /// registery.
    internal static var `default`: DatadogFeatureRegistry = NOOPDatadogRegistry()
}

/// A Datadog Feature registry hold a set of features and is responsible of
/// managing their storage and upload mechanism. It also provide thread-safe
/// scope for features.
public protocol DatadogFeatureRegistry {
    /// Registers a feature by its name and configuration.
    ///
    /// - Parameters:
    ///   - named: The feature name.
    ///   - storage: The feature's storage configuration.
    ///   - upload: The feature's upload configuration.
    func registerFeature(named: String, storage: StorageConfiguration, upload: UploadConfiguration)

    /// Returns a Feature by its name.
    ///
    /// - Parameter named: The feature's name.
    /// - Returns: The feature if it was previously registered, `nil` otherwise.
    func feature(named: String) -> DatadogFeature?
}

/// Provide feature specific storage configuration.
public struct StorageConfiguration {
    // TODO: RUMM-2133
}

/// Provide feature specific upload configuration.
public struct UploadConfiguration {
    // TODO: RUMM-2133
}

/// A datadog feature providing thread-safe scope for writing events.
public protocol DatadogFeature {
    // TODO: RUMM-2133
}

/// No-op implementation of `DatadogFeatureRegistry`.
internal struct NOOPDatadogRegistry: DatadogFeatureRegistry {
    func registerFeature(named: String, storage: StorageConfiguration, upload: UploadConfiguration) {}

    func feature(named: String) -> DatadogFeature? {
        return nil
    }
}
