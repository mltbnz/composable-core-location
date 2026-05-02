import CoreLocation
import Dependencies
import DependenciesMacros

/// A wrapper around Core Location's `CLLocationManager` that exposes its functionality through a
/// dependency client and `AsyncStream`-based delegate, making it easy to use with the Composable
/// Architecture and easy to test.
///
/// To use it, register the dependency in your reducer:
///
/// ```swift
/// @Reducer
/// struct Feature {
///   @Dependency(\.locationManager) var locationManager
///   ...
/// }
/// ```
///
/// And subscribe to delegate actions via the ``delegate()`` async stream:
///
/// ```swift
/// case .onAppear:
///   return .run { send in
///     for await event in locationManager.delegate() {
///       await send(.locationManager(event))
///     }
///   }
/// ```
///
/// In tests, `@DependencyClient` provides an unimplemented test value automatically. Override only
/// the endpoints your test exercises:
///
/// ```swift
/// store.dependencies.locationManager.authorizationStatus = { .authorizedWhenInUse }
/// store.dependencies.locationManager.requestLocation = { /* … */ }
/// ```
@DependencyClient
public struct LocationManager: Sendable {
  /// Actions that correspond to `CLLocationManagerDelegate` methods.
  ///
  /// See `CLLocationManagerDelegate` for more information.
  public enum Action: Equatable, Sendable {
    case didChangeAuthorization(CLAuthorizationStatus)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didDetermineState(CLRegionState, region: Region)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didEnterRegion(Region)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didExitRegion(Region)

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didFailRanging(beaconConstraint: CLBeaconIdentityConstraint, error: Error)

    case didFailWithError(Error)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didFinishDeferredUpdatesWithError(Error?)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didPauseLocationUpdates

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didResumeLocationUpdates

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didStartMonitoring(region: Region)

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    case didUpdateHeading(newHeading: Heading)

    case didUpdateLocations([Location])

    @available(macCatalyst, deprecated: 13)
    @available(tvOS, unavailable)
    case didUpdateTo(newLocation: Location, oldLocation: Location)

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didVisit(Visit)

    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case monitoringDidFail(region: Region?, error: Error)

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    case didRangeBeacons([Beacon], satisfyingConstraint: CLBeaconIdentityConstraint)
  }

  public struct Error: Swift.Error, Equatable, Sendable {
    public let error: NSError

    public init(_ error: Swift.Error) {
      self.error = error as NSError
    }
  }

  public var accuracyAuthorization: @Sendable () -> AccuracyAuthorization?

  public var authorizationStatus: @Sendable () -> CLAuthorizationStatus = { .notDetermined }

  public var delegate: @Sendable () -> AsyncStream<Action> = { .finished }

  public var dismissHeadingCalibrationDisplay: @Sendable () -> Void

  public var heading: @Sendable () -> Heading?

  public var headingAvailable: @Sendable () -> Bool = { false }

  public var isRangingAvailable: @Sendable () -> Bool = { false }

  public var location: @Sendable () -> Location?

  public var locationServicesEnabled: @Sendable () -> Bool = { false }

  public var maximumRegionMonitoringDistance: @Sendable () -> CLLocationDistance = {
    CLLocationDistanceMax
  }

  public var monitoredRegions: @Sendable () -> Set<Region> = { [] }

  public var requestAlwaysAuthorization: @Sendable () -> Void

  public var requestLocation: @Sendable () -> Void

  public var requestWhenInUseAuthorization: @Sendable () -> Void

  public var requestTemporaryFullAccuracyAuthorization:
    @Sendable (_ purposeKey: String) async throws -> Void

  public var set: @Sendable (_ properties: Properties) -> Void

  public var significantLocationChangeMonitoringAvailable: @Sendable () -> Bool = { false }

  public var startMonitoringForRegion: @Sendable (_ region: Region) -> Void

  public var startMonitoringSignificantLocationChanges: @Sendable () -> Void

  public var startMonitoringVisits: @Sendable () -> Void

  public var startUpdatingHeading: @Sendable () -> Void

  public var startUpdatingLocation: @Sendable () -> Void

  public var stopMonitoringForRegion: @Sendable (_ region: Region) -> Void

  public var stopMonitoringSignificantLocationChanges: @Sendable () -> Void

  public var stopMonitoringVisits: @Sendable () -> Void

  public var stopUpdatingHeading: @Sendable () -> Void

  public var stopUpdatingLocation: @Sendable () -> Void

  /// Updates the given properties of a uniquely identified `CLLocationManager`.
  public func set(
    activityType: CLActivityType? = nil,
    allowsBackgroundLocationUpdates: Bool? = nil,
    desiredAccuracy: CLLocationAccuracy? = nil,
    distanceFilter: CLLocationDistance? = nil,
    headingFilter: CLLocationDegrees? = nil,
    headingOrientation: CLDeviceOrientation? = nil,
    pausesLocationUpdatesAutomatically: Bool? = nil,
    showsBackgroundLocationIndicator: Bool? = nil
  ) {
    #if os(macOS) || os(tvOS) || os(watchOS)
      return
    #else
      self.set(
        properties: Properties(
          activityType: activityType,
          allowsBackgroundLocationUpdates: allowsBackgroundLocationUpdates,
          desiredAccuracy: desiredAccuracy,
          distanceFilter: distanceFilter,
          headingFilter: headingFilter,
          headingOrientation: headingOrientation,
          pausesLocationUpdatesAutomatically: pausesLocationUpdatesAutomatically,
          showsBackgroundLocationIndicator: showsBackgroundLocationIndicator
        )
      )
    #endif
  }
}

extension LocationManager {
  public struct Properties: Equatable, Sendable {
    var activityType: CLActivityType? = nil

    var allowsBackgroundLocationUpdates: Bool? = nil

    var desiredAccuracy: CLLocationAccuracy? = nil

    var distanceFilter: CLLocationDistance? = nil

    var headingFilter: CLLocationDegrees? = nil

    var headingOrientation: CLDeviceOrientation? = nil

    var pausesLocationUpdatesAutomatically: Bool? = nil

    var showsBackgroundLocationIndicator: Bool? = nil

    public static func == (lhs: Self, rhs: Self) -> Bool {
      var isEqual = true
      #if os(iOS) || targetEnvironment(macCatalyst) || os(watchOS)
        isEqual =
          isEqual
          && lhs.activityType == rhs.activityType
          && lhs.allowsBackgroundLocationUpdates == rhs.allowsBackgroundLocationUpdates
      #endif
      isEqual =
        isEqual
        && lhs.desiredAccuracy == rhs.desiredAccuracy
        && lhs.distanceFilter == rhs.distanceFilter
      #if os(iOS) || targetEnvironment(macCatalyst) || os(watchOS)
        isEqual =
          isEqual
          && lhs.headingFilter == rhs.headingFilter
          && lhs.headingOrientation == rhs.headingOrientation
      #endif
      #if os(iOS) || targetEnvironment(macCatalyst)
        isEqual =
          isEqual
          && lhs.pausesLocationUpdatesAutomatically == rhs.pausesLocationUpdatesAutomatically
          && lhs.showsBackgroundLocationIndicator == rhs.showsBackgroundLocationIndicator
      #endif
      return isEqual
    }

    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public init(
      activityType: CLActivityType? = nil,
      allowsBackgroundLocationUpdates: Bool? = nil,
      desiredAccuracy: CLLocationAccuracy? = nil,
      distanceFilter: CLLocationDistance? = nil,
      headingFilter: CLLocationDegrees? = nil,
      headingOrientation: CLDeviceOrientation? = nil,
      pausesLocationUpdatesAutomatically: Bool? = nil,
      showsBackgroundLocationIndicator: Bool? = nil
    ) {
      self.activityType = activityType
      self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
      self.desiredAccuracy = desiredAccuracy
      self.distanceFilter = distanceFilter
      self.headingFilter = headingFilter
      self.headingOrientation = headingOrientation
      self.pausesLocationUpdatesAutomatically = pausesLocationUpdatesAutomatically
      self.showsBackgroundLocationIndicator = showsBackgroundLocationIndicator
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(watchOS, unavailable)
    public init(
      desiredAccuracy: CLLocationAccuracy? = nil,
      distanceFilter: CLLocationDistance? = nil
    ) {
      self.desiredAccuracy = desiredAccuracy
      self.distanceFilter = distanceFilter
    }

    @available(iOS, unavailable)
    @available(macCatalyst, unavailable)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    public init(
      activityType: CLActivityType? = nil,
      allowsBackgroundLocationUpdates: Bool? = nil,
      desiredAccuracy: CLLocationAccuracy? = nil,
      distanceFilter: CLLocationDistance? = nil,
      headingFilter: CLLocationDegrees? = nil,
      headingOrientation: CLDeviceOrientation? = nil
    ) {
      self.activityType = activityType
      self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
      self.desiredAccuracy = desiredAccuracy
      self.distanceFilter = distanceFilter
      self.headingFilter = headingFilter
      self.headingOrientation = headingOrientation
    }
  }
}

extension LocationManager: DependencyKey {
  public static let liveValue: LocationManager = .live
}

extension DependencyValues {
  public var locationManager: LocationManager {
    get { self[LocationManager.self] }
    set { self[LocationManager.self] = newValue }
  }
}
