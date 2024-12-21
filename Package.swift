// swift-tools-version:5.9

//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// This manifest is auto-generated.  Do not commit edits to this file;
// they will be overwritten.

import Foundation
import PackageDescription

// MARK: - Dynamic Content

let clientRuntimeVersion: Version = "0.104.0"
let crtVersion: Version = "0.40.0"

let excludeRuntimeUnitTests = false

let serviceTargets: [String] = [
    "AWSBedrock",
    "AWSBedrockRuntime",
]

// MARK: - Static Content

// MARK: Target Dependencies

extension Target.Dependency {
    // AWS modules
    static var awsClientRuntime: Self { "AWSClientRuntime" }
    static var awsSDKCommon: Self { "AWSSDKCommon" }
    static var awsSDKEventStreamsAuth: Self { "AWSSDKEventStreamsAuth" }
    static var awsSDKHTTPAuth: Self { "AWSSDKHTTPAuth" }
    static var awsSDKIdentity: Self { "AWSSDKIdentity" }
    static var awsSDKChecksums: Self { "AWSSDKChecksums" }

    // CRT module
    static var crt: Self { .product(name: "AwsCommonRuntimeKit", package: "aws-crt-swift") }

    // Smithy modules
    static var clientRuntime: Self { .product(name: "ClientRuntime", package: "smithy-swift") }
    static var smithy: Self { .product(name: "Smithy", package: "smithy-swift") }
    static var smithyChecksumsAPI: Self { .product(name: "SmithyChecksumsAPI", package: "smithy-swift") }
    static var smithyChecksums: Self { .product(name: "SmithyChecksums", package: "smithy-swift") }
    static var smithyEventStreams: Self { .product(name: "SmithyEventStreams", package: "smithy-swift") }
    static var smithyEventStreamsAPI: Self { .product(name: "SmithyEventStreamsAPI", package: "smithy-swift") }
    static var smithyEventStreamsAuthAPI: Self { .product(name: "SmithyEventStreamsAuthAPI", package: "smithy-swift") }
    static var smithyHTTPAPI: Self { .product(name: "SmithyHTTPAPI", package: "smithy-swift") }
    static var smithyHTTPAuth: Self { .product(name: "SmithyHTTPAuth", package: "smithy-swift") }
    static var smithyIdentity: Self { .product(name: "SmithyIdentity", package: "smithy-swift") }
    static var smithyIdentityAPI: Self { .product(name: "SmithyIdentityAPI", package: "smithy-swift") }
    static var smithyRetries: Self { .product(name: "SmithyRetries", package: "smithy-swift") }
    static var smithyRetriesAPI: Self { .product(name: "SmithyRetriesAPI", package: "smithy-swift") }
    static var smithyWaitersAPI: Self { .product(name: "SmithyWaitersAPI", package: "smithy-swift") }
    static var smithyTestUtils: Self { .product(name: "SmithyTestUtil", package: "smithy-swift") }
    static var smithyStreams: Self { .product(name: "SmithyStreams", package: "smithy-swift") }
}

// MARK: Base Package

let package = Package(
    name: "aws-sdk-swift",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products:
        runtimeProducts +
        serviceTargets.map(productForService(_:)),
    dependencies:
        [clientRuntimeDependency, crtDependency].compactMap { $0 },
    targets:
        runtimeTargets +
        serviceTargets.map(target(_:))
)

// MARK: Products

private var runtimeProducts: [Product] {
    ["AWSClientRuntime", "AWSSDKCommon", "AWSSDKEventStreamsAuth", "AWSSDKHTTPAuth", "AWSSDKIdentity", "AWSSDKChecksums"]
        .map { .library(name: $0, targets: [$0]) }
}

private func productForService(_ service: String) -> Product {
    .library(name: service, targets: [service])
}

// MARK: Dependencies

private var clientRuntimeDependency: Package.Dependency {
    let path = "../smithy-swift"
    let gitURL = "https://github.com/smithy-lang/smithy-swift"
    let useLocalDeps = ProcessInfo.processInfo.environment["AWS_SWIFT_SDK_USE_LOCAL_DEPS"] != nil
    return useLocalDeps ? .package(path: path) : .package(url: gitURL, exact: clientRuntimeVersion)
//    return .package(path: "../smithy-swift")
}

private var crtDependency: Package.Dependency {
    .package(url: "https://github.com/awslabs/aws-crt-swift", exact: crtVersion)
//    return .package(path: "../aws-crt-swift")
}

// MARK: Targets

private var runtimeTargets: [Target] {
    [
        .target(
            name: "AWSSDKForSwift",
            path: "Sources/Core/AWSSDKForSwift",
            exclude: ["Documentation.docc/AWSSDKForSwift.md"]
        ),
        .target(
            name: "AWSClientRuntime",
            dependencies: [
                .crt,
                .clientRuntime,
                .smithyRetriesAPI,
                .smithyRetries,
                .smithyEventStreamsAPI,
                .smithyEventStreamsAuthAPI,
                .awsSDKCommon,
                .awsSDKHTTPAuth,
                .awsSDKIdentity
            ],
            path: "Sources/Core/AWSClientRuntime/Sources/AWSClientRuntime",
            resources: [
                .process("Resources"),
            ]
        ),
        .target(
            name: "AWSSDKCommon",
            dependencies: [.crt],
            path: "Sources/Core/AWSSDKCommon/Sources"
        ),
        .target(
            name: "AWSSDKEventStreamsAuth",
            dependencies: [.smithyEventStreamsAPI, .smithyEventStreamsAuthAPI, .smithyEventStreams, .crt, .clientRuntime, "AWSSDKHTTPAuth"],
            path: "Sources/Core/AWSSDKEventStreamsAuth/Sources"
        ),
        .target(
            name: "AWSSDKHTTPAuth",
            dependencies: [.crt, .smithy, .clientRuntime, .smithyHTTPAuth, "AWSSDKIdentity", "AWSSDKChecksums"],
            path: "Sources/Core/AWSSDKHTTPAuth/Sources"
        ),
        .target(
            name: "AWSSDKIdentity",
            dependencies: [.crt, .smithy, .clientRuntime, .smithyIdentity, .smithyIdentityAPI, .smithyHTTPAPI, .awsSDKCommon],
            path: "Sources/Core/AWSSDKIdentity/Sources"
        ),
        .target(
            name: "AWSSDKChecksums",
            dependencies: [.crt, .smithy, .clientRuntime, .smithyChecksumsAPI, .smithyChecksums, .smithyHTTPAPI],
            path: "Sources/Core/AWSSDKChecksums/Sources"
        )
    ]
}

private func target(_ service: String) -> Target {
    .target(
        name: service,
        dependencies: [
            .clientRuntime,
            .awsClientRuntime,
            .smithyRetriesAPI,
            .smithyRetries,
            .smithy,
            .smithyIdentity,
            .smithyIdentityAPI,
            .smithyEventStreamsAPI,
            .smithyEventStreamsAuthAPI,
            .smithyEventStreams,
            .smithyChecksumsAPI,
            .smithyChecksums,
            .smithyWaitersAPI,
            .awsSDKCommon,
            .awsSDKIdentity,
            .awsSDKHTTPAuth,
            .awsSDKEventStreamsAuth,
            .awsSDKChecksums,
        ],
        path: "Sources/Services/\(service)/Sources/\(service)"
    )
}
