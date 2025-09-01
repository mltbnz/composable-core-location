import CoreLocation
import XCTestDynamicOverlay

extension LocationManager {
  /// The failing implementation of the ``LocationManager`` interface. By default this
  /// implementation stubs all of its endpoints as functions that immediately call `XCTFail`.
  ///
  /// This allows you to test an even deeper property of your features: that they use only the
  /// location manager endpoints that you specify and nothing else. This can be useful as a
  /// measurement of just how complex a particular test is. Tests that need to stub many endpoints
  /// are in some sense more complicated than tests that only need to stub a few endpoints. It's not
  /// necessarily a bad thing to stub many endpoints. Sometimes it's needed.
  ///
  /// As an example, to create a failing manager that simulates a location manager that has already
  /// authorized access to location, and when a location is requested it immediately responds
  /// with a mock location we can do something like this:
  ///
  /// ```swift
  /// // Send actions to this subject to simulate the location manager's delegate methods
  /// // being called.
  /// let locationManagerSubject = PassthroughSubject<LocationManager.Action, Never>()
  ///
  /// // The mock location we want the manager to say we are located at
  /// let mockLocation = Location(
  ///   coordinate: CLLocationCoordinate2D(latitude: 40.6501, longitude: -73.94958),
  ///   // A whole bunch of other properties have been omitted.
  /// )
  ///
  /// var manager = LocationManager.failing
  ///
  /// // Override any CLLocationManager endpoints your test invokes:
  /// manager.authorizationStatus = { .authorizedAlways }
  /// manager.delegate = { locationManagerSubject.eraseToEffect() }
  /// manager.locationServicesEnabled = { true }
  /// manager.requestLocation = {
  ///   .fireAndForget { locationManagerSubject.send(.didUpdateLocations([mockLocation])) }
  /// }
  /// ```
  public static let failing = Self(
    accuracyAuthorization: unimplemented(
      "\(Self.self).accuracyAuthorization",
      placeholder: nil
    ),
    authorizationStatus: unimplemented(
      "\(Self.self).authorizationStatus",
      placeholder: .denied
    ),
    delegate: unimplemented(
      "\(Self.self).delegate",
      placeholder: AsyncStream.never
    ),
    dismissHeadingCalibrationDisplay: unimplemented(
      "\(Self.self).dismissHeadingCalibrationDisplay"
    ),
    heading: unimplemented(
      "\(Self.self).heading",
      placeholder: nil
    ),
    headingAvailable: unimplemented(
      "\(Self.self).headingAvailable",
      placeholder: false
    ),
    isRangingAvailable: unimplemented(
      "\(Self.self).isRangingAvailable",
      placeholder: false
    ),
    location: unimplemented(
      "\(Self.self).location",
      placeholder: nil
    ),
    locationServicesEnabled: unimplemented(
      "\(Self.self).locationServicesEnabled",
      placeholder: false
    ),
    maximumRegionMonitoringDistance: unimplemented(
      "\(Self.self).maximumRegionMonitoringDistance",
      placeholder: CLLocationDistance.greatestFiniteMagnitude
    ),
    monitoredRegions: unimplemented(
      "\(Self.self).monitoredRegions",
      placeholder: []
    ),
    requestAlwaysAuthorization: unimplemented(
      "\(Self.self).requestAlwaysAuthorization"
    ),
    requestLocation: unimplemented(
      "\(Self.self).requestLocation"
    ),
    requestWhenInUseAuthorization: unimplemented(
      "\(Self.self).requestWhenInUseAuthorization"
    ),
    requestTemporaryFullAccuracyAuthorization: unimplemented(
      "\(Self.self).requestTemporaryFullAccuracyAuthorization"
    ),
    set: unimplemented(
      "\(Self.self).set"
    ),
    significantLocationChangeMonitoringAvailable: unimplemented(
      "\(Self.self).significantLocationChangeMonitoringAvailable",
      placeholder: false
    ),
    startMonitoringForRegion: unimplemented(
      "\(Self.self).startMonitoringForRegion"
    ),
    startMonitoringSignificantLocationChanges: unimplemented(
      "\(Self.self).startMonitoringSignificantLocationChanges"
    ),
    startMonitoringVisits: unimplemented(
      "\(Self.self).startMonitoringVisits"
    ),
    startUpdatingHeading: unimplemented(
      "\(Self.self).startUpdatingHeading"
    ),
    startUpdatingLocation: unimplemented(
      "\(Self.self).startUpdatingLocation"
    ),
    stopMonitoringForRegion: unimplemented(
      "\(Self.self).stopMonitoringForRegion"
    ),
    stopMonitoringSignificantLocationChanges: unimplemented(
      "\(Self.self).stopMonitoringSignificantLocationChanges"
    ),
    stopMonitoringVisits: unimplemented(
      "\(Self.self).stopMonitoringVisits"
    ),
    stopUpdatingHeading: unimplemented(
      "\(Self.self).stopUpdatingHeading"
    ),
    stopUpdatingLocation: unimplemented(
      "\(Self.self).stopUpdatingLocation"
    )
  )
}
