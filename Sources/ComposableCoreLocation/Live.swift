import ConcurrencyExtras
import CoreLocation
import Foundation

extension LocationManager {
  /// The live implementation of the `LocationManager` interface, backed by a real
  /// `CLLocationManager`. This is the value used as the `liveValue` for the
  /// `\.locationManager` dependency.
  public static let live: LocationManager = {
    let observer = LocationManagerObserver()
    let box = UncheckedSendable(observer.manager)

    return Self(
      accuracyAuthorization: {
        if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, macCatalyst 14.0, *) {
          return AccuracyAuthorization(box.value.accuracyAuthorization)
        }
        return nil
      },
      authorizationStatus: { box.value.authorizationStatus },
      delegate: { observer.subscribe() },
      dismissHeadingCalibrationDisplay: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.dismissHeadingCalibrationDisplay()
        #endif
      },
      heading: {
        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
          return box.value.heading.map(Heading.init(rawValue:))
        #else
          return nil
        #endif
      },
      headingAvailable: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          return CLLocationManager.headingAvailable()
        #else
          return false
        #endif
      },
      isRangingAvailable: {
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          return CLLocationManager.isRangingAvailable()
        #else
          return false
        #endif
      },
      location: { box.value.location.map(Location.init(rawValue:)) },
      locationServicesEnabled: { CLLocationManager.locationServicesEnabled() },
      maximumRegionMonitoringDistance: {
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          return box.value.maximumRegionMonitoringDistance
        #else
          return CLLocationDistanceMax
        #endif
      },
      monitoredRegions: {
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          return Set(box.value.monitoredRegions.map(Region.init(rawValue:)))
        #else
          return []
        #endif
      },
      requestAlwaysAuthorization: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.requestAlwaysAuthorization()
        #endif
      },
      requestLocation: { box.value.requestLocation() },
      requestWhenInUseAuthorization: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.requestWhenInUseAuthorization()
        #endif
      },
      requestTemporaryFullAccuracyAuthorization: { purposeKey in
        #if !(os(macOS) || targetEnvironment(macCatalyst))
          if #available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11.0, macCatalyst 14.0, *) {
            try await withCheckedThrowingContinuation {
              (continuation: CheckedContinuation<Void, Swift.Error>) in
              box.value.requestTemporaryFullAccuracyAuthorization(withPurposeKey: purposeKey) {
                error in
                if let error {
                  continuation.resume(throwing: LocationManager.Error(error))
                } else {
                  continuation.resume()
                }
              }
            }
          }
        #endif
      },
      set: { properties in
        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
          if let activityType = properties.activityType {
            box.value.activityType = activityType
          }
          if let allowsBackgroundLocationUpdates = properties.allowsBackgroundLocationUpdates {
            box.value.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
          }
        #endif
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || targetEnvironment(macCatalyst)
          if let desiredAccuracy = properties.desiredAccuracy {
            box.value.desiredAccuracy = desiredAccuracy
          }
          if let distanceFilter = properties.distanceFilter {
            box.value.distanceFilter = distanceFilter
          }
        #endif
        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
          if let headingFilter = properties.headingFilter {
            box.value.headingFilter = headingFilter
          }
          if let headingOrientation = properties.headingOrientation {
            box.value.headingOrientation = headingOrientation
          }
        #endif
        #if os(iOS) || targetEnvironment(macCatalyst)
          if let pausesLocationUpdatesAutomatically = properties.pausesLocationUpdatesAutomatically {
            box.value.pausesLocationUpdatesAutomatically = pausesLocationUpdatesAutomatically
          }
          if let showsBackgroundLocationIndicator = properties.showsBackgroundLocationIndicator {
            box.value.showsBackgroundLocationIndicator = showsBackgroundLocationIndicator
          }
        #endif
      },
      significantLocationChangeMonitoringAvailable: {
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          return CLLocationManager.significantLocationChangeMonitoringAvailable()
        #else
          return false
        #endif
      },
      startMonitoringForRegion: { region in
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          if let raw = region.rawValue {
            box.value.startMonitoring(for: raw)
          }
        #endif
      },
      startMonitoringSignificantLocationChanges: {
        #if os(iOS) || targetEnvironment(macCatalyst)
          box.value.startMonitoringSignificantLocationChanges()
        #endif
      },
      startMonitoringVisits: {
        #if os(iOS) || targetEnvironment(macCatalyst)
          box.value.startMonitoringVisits()
        #endif
      },
      startUpdatingHeading: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.startUpdatingHeading()
        #endif
      },
      startUpdatingLocation: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.startUpdatingLocation()
        #endif
      },
      stopMonitoringForRegion: { region in
        #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
          if let raw = region.rawValue {
            box.value.stopMonitoring(for: raw)
          }
        #endif
      },
      stopMonitoringSignificantLocationChanges: {
        #if os(iOS) || targetEnvironment(macCatalyst)
          box.value.stopMonitoringSignificantLocationChanges()
        #endif
      },
      stopMonitoringVisits: {
        #if os(iOS) || targetEnvironment(macCatalyst)
          box.value.stopMonitoringVisits()
        #endif
      },
      stopUpdatingHeading: {
        #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.stopUpdatingHeading()
        #endif
      },
      stopUpdatingLocation: {
        #if os(iOS) || os(macOS) || os(watchOS) || targetEnvironment(macCatalyst)
          box.value.stopUpdatingLocation()
        #endif
      }
    )
  }()
}

/// Owns the `CLLocationManager` and its delegate, fanning delegate callbacks out to any number of
/// `AsyncStream<LocationManager.Action>` subscribers. This makes `delegate()` callable from
/// multiple consumers, with each receiving the same events.
private final class LocationManagerObserver: @unchecked Sendable {
  let manager: CLLocationManager
  private let delegate: Delegate

  init() {
    self.manager = CLLocationManager()
    self.delegate = Delegate()
    self.manager.delegate = self.delegate
  }

  func subscribe() -> AsyncStream<LocationManager.Action> {
    self.delegate.subscribe()
  }

  fileprivate final class Delegate: NSObject, CLLocationManagerDelegate, @unchecked Sendable {
    private let continuations =
      LockIsolated<[UUID: AsyncStream<LocationManager.Action>.Continuation]>([:])

    func subscribe() -> AsyncStream<LocationManager.Action> {
      let id = UUID()
      let continuations = self.continuations
      return AsyncStream<LocationManager.Action> { continuation in
        continuations.withValue { $0[id] = continuation }
        continuation.onTermination = { _ in
          continuations.withValue { _ = $0.removeValue(forKey: id) }
        }
      }
    }

    private func send(_ action: LocationManager.Action) {
      self.continuations.withValue { dict in
        for continuation in dict.values {
          continuation.yield(action)
        }
      }
    }

    func locationManager(
      _ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus
    ) {
      self.send(.didChangeAuthorization(status))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
      self.send(.didFailWithError(LocationManager.Error(error)))
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      self.send(.didUpdateLocations(locations.map(Location.init(rawValue:))))
    }

    #if os(macOS)
      func locationManager(
        _ manager: CLLocationManager, didUpdateTo newLocation: CLLocation,
        from oldLocation: CLLocation
      ) {
        self.send(
          .didUpdateTo(
            newLocation: Location(rawValue: newLocation),
            oldLocation: Location(rawValue: oldLocation)
          )
        )
      }
    #endif

    #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      func locationManager(
        _ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Swift.Error?
      ) {
        self.send(
          .didFinishDeferredUpdatesWithError(error.map(LocationManager.Error.init))
        )
      }
    #endif

    #if os(iOS) || targetEnvironment(macCatalyst)
      func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        self.send(.didPauseLocationUpdates)
      }

      func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        self.send(.didResumeLocationUpdates)
      }
    #endif

    #if os(iOS) || os(watchOS) || targetEnvironment(macCatalyst)
      func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.send(.didUpdateHeading(newHeading: Heading(rawValue: newHeading)))
      }
    #endif

    #if os(iOS) || os(macOS) || targetEnvironment(macCatalyst)
      func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.send(.didEnterRegion(Region(rawValue: region)))
      }

      func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.send(.didExitRegion(Region(rawValue: region)))
      }

      func locationManager(
        _ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion
      ) {
        self.send(.didDetermineState(state, region: Region(rawValue: region)))
      }

      func locationManager(
        _ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?,
        withError error: Swift.Error
      ) {
        self.send(
          .monitoringDidFail(
            region: region.map(Region.init(rawValue:)), error: LocationManager.Error(error)))
      }

      func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        self.send(.didStartMonitoring(region: Region(rawValue: region)))
      }
    #endif

    #if os(iOS) || targetEnvironment(macCatalyst)
      func locationManager(
        _ manager: CLLocationManager, didRange beacons: [CLBeacon],
        satisfying beaconConstraint: CLBeaconIdentityConstraint
      ) {
        self.send(
          .didRangeBeacons(
            beacons.map(Beacon.init(rawValue:)), satisfyingConstraint: beaconConstraint
          )
        )
      }

      func locationManager(
        _ manager: CLLocationManager,
        didFailRangingFor beaconConstraint: CLBeaconIdentityConstraint,
        error: Swift.Error
      ) {
        self.send(
          .didFailRanging(beaconConstraint: beaconConstraint, error: LocationManager.Error(error))
        )
      }

      func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        self.send(.didVisit(Visit(visit: visit)))
      }
    #endif
  }
}
