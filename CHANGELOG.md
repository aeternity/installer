# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Added

### Changed

### Removed

## [2.0.0] - 2019-04-15
### Added
- Allow installation of `latest` node version. 
- Running the installer without explicit version argument defaults to `latest`.

### Changed
- Use aeternity artifacts repository instead of GitHub release artifacts.
- Add post installation hint to run the node console.

### Removed
- Drop support of node versions before 1.3.0.  To install older versions use v1.0.0 of the installer.

## [1.0.0] - 2019-03-12
### Added
- Initial release.
- Support for Ubuntu 16.04 and Ubuntu 18.04.
- Support for macOS 10.13 and macOS 10.14.
- Supports all node releases since 1.0.0.

[Unreleased]: https://github.com/aeternity/installer/compare/v2.0.0...HEAD
[2.0.0]: https://github.com/aeternity/installer/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/aeternity/installer/releases/tag/v1.0.0
