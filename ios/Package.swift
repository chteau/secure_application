// swift-tools-version: 5.9
import PackageDescription

let package = Package(
  name: "secure_application",
  platforms: [
    .iOS(.v12)
  ],
  products: [
    .library(name: "secure_application", targets: ["secure_application"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "secure_application",
      dependencies: [],
      path: "Classes",
      publicHeadersPath: ".",
      cSettings: [
        .headerSearchPath(".")
      ]
    )
  ]
)
