// swift-tools-version:6.3

import PackageDescription

let package = Package(
  name: "composable-core-location",
  platforms: [
    .iOS(.v16),
    .macOS(.v13),
    .tvOS(.v16),
    .watchOS(.v9),
  ],
  products: [
    .library(
      name: "ComposableCoreLocation",
      targets: ["ComposableCoreLocation"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.10.0"),
    .package(url: "https://github.com/pointfreeco/swift-concurrency-extras", from: "1.3.0"),
  ],
  targets: [
    .target(
      name: "ComposableCoreLocation",
      dependencies: [
        .product(name: "Dependencies", package: "swift-dependencies"),
        .product(name: "DependenciesMacros", package: "swift-dependencies"),
        .product(name: "ConcurrencyExtras", package: "swift-concurrency-extras"),
      ]
    ),
    .testTarget(
      name: "ComposableCoreLocationTests",
      dependencies: ["ComposableCoreLocation"]
    ),
  ]
)
