/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import Foundation

/// Core implementation of Datadog SDK.
///
/// The core provides a storage and upload mechanism for each registered
/// feature based on their respective configuration.
///
/// By complying with `DatadogFeatureRegistry`, the core can
/// provide context and writing scopes to features for event recording.
public final class DatadogCore {
    /// The user consent provider for collecting PII.
    internal let consentProvider: ConsentProvider

    /// User PII.
    internal let userInfoProvider: UserInfoProvider

    /// Creates a core instance.
    ///
    /// - Parameters:
    ///   - consentProvider: The user consent provider for collecting PII.
    ///   - userInfoProvider: User PII.
    internal init(
        consentProvider: ConsentProvider,
        userInfoProvider: UserInfoProvider
    ) {
        self.consentProvider = consentProvider
        self.userInfoProvider = userInfoProvider
    }
}

extension DatadogCore: DatadogFeatureRegistry {
    public func registerFeature(named: String, storage: StorageConfiguration, upload: UploadConfiguration) {
        // no-op
    }

    public func feature(named: String) -> DatadogFeature? {
        // no-op
        return nil
    }
}
