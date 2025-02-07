/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

/// A type performing data migration.
internal protocol DataMigrator {
    func migrate()
}

internal struct DataMigratorFactory {
    /// Data directories for the feature.
    let directories: FeatureDirectories
    var telemetry: Telemetry? = nil

    /// Resolves migrator to use when the SDK is started.
    func resolveInitialMigrator() -> DataMigrator {
        return DeleteAllDataMigrator(
            directory: directories.unauthorized,
            telemetry: telemetry
        )
    }

    /// Resolves migrator to use when consent value changes.
    func resolveMigratorForConsentChange(from previousValue: TrackingConsent, to newValue: TrackingConsent) -> DataMigrator? {
        switch (previousValue, newValue) {
        case (.pending, .notGranted):
            return DeleteAllDataMigrator(
                directory: directories.unauthorized,
                telemetry: telemetry
            )
        case (.pending, .granted):
            return MoveDataMigrator(
                sourceDirectory: directories.unauthorized,
                destinationDirectory: directories.authorized,
                telemetry: telemetry
            )
        default:
            return nil
        }
    }
}
