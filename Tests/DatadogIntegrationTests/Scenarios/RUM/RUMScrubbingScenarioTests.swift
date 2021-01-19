/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-2020 Datadog, Inc.
 */

import HTTPServerMock
import XCTest

class RUMScrubbingScenarioTests: IntegrationTests, RUMCommonAsserts {
    func testRUMScrubbingScenario() throws {
        let rumServerSession = server.obtainUniqueRecordingSession()

        let app = ExampleApplication()
        app.launchWith(
            testScenario: RUMScrubbingScenario.self,
            serverConfiguration: HTTPServerMockConfiguration(
                rumEndpoint: rumServerSession.recordingURL
            )
        )

        // Get RUM Session with expected number of RUM Errors
        let recordedRUMRequests = try rumServerSession.pullRecordedRequests(timeout: dataDeliveryTimeout) { requests in
            try RUMSessionMatcher.from(requests: requests)?.viewVisits.last?.errorEvents.count == 2
        }

        assertRUM(requests: recordedRUMRequests)

        let session = try XCTUnwrap(RUMSessionMatcher.from(requests: recordedRUMRequests))

        XCTAssertEqual(session.viewVisits.count, 1)
        let viewVisit = session.viewVisits[0]

        XCTAssertGreaterThan(viewVisit.viewEvents.count, 0)
        viewVisit.viewEvents.forEach { event in
            XCTAssertTrue(event.view.url.isRedacted)
        }

        XCTAssertGreaterThan(viewVisit.errorEvents.count, 0)
        viewVisit.errorEvents.forEach { event in
            XCTAssertTrue(event.error.message.isRedacted)
            XCTAssertTrue(event.view.url.isRedacted)
            XCTAssertTrue(event.error.resource?.url.isRedacted ?? true)
            XCTAssertTrue(event.error.stack?.isRedacted ?? true)
        }

        XCTAssertGreaterThan(viewVisit.resourceEvents.count, 0)
        viewVisit.resourceEvents.forEach { event in
            XCTAssertTrue(event.resource.url.isRedacted)
        }

        XCTAssertGreaterThan(viewVisit.actionEvents.count, 0)
        viewVisit.actionEvents.forEach { event in
            XCTAssertTrue(event.action.target?.name.isRedacted ?? true)
        }
    }
}

private extension String {
    var isRedacted: Bool {
        let sensitivePart = "sensitive"
        return !contains(sensitivePart)
    }
}
