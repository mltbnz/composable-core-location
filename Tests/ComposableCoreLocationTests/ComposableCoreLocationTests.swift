import ComposableCoreLocation
import Dependencies
import Foundation
import Testing

struct ComposableCoreLocationTests {
  @Test func testLocationEncodeDecode() throws {
    let value = Location(
      altitude: 50,
      coordinate: CLLocationCoordinate2D(latitude: 10, longitude: 20),
      course: 9,
      courseAccuracy: 1,
      horizontalAccuracy: 3,
      speed: 5,
      speedAccuracy: 2,
      timestamp: Date(timeIntervalSince1970: 0),
      verticalAccuracy: 6
    )

    let data = try JSONEncoder().encode(value)
    let decoded = try JSONDecoder().decode(Location.self, from: data)

    #expect(value == decoded)
  }

  @Test func testLocationEquatable() {
    let a = Location(
      altitude: 1,
      coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1),
      course: 1,
      courseAccuracy: 1,
      horizontalAccuracy: 1,
      speed: 1,
      speedAccuracy: 1,
      timestamp: Date(timeIntervalSince1970: 0),
      verticalAccuracy: 1
    )

    let differentSpeedAccuracy = Location(
      altitude: 1,
      coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1),
      course: 1,
      courseAccuracy: 1,
      horizontalAccuracy: 1,
      speed: 1,
      speedAccuracy: 2,
      timestamp: Date(timeIntervalSince1970: 0),
      verticalAccuracy: 1
    )

    let differentCourseAccuracy = Location(
      altitude: 1,
      coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 1),
      course: 1,
      courseAccuracy: 2,
      horizontalAccuracy: 1,
      speed: 1,
      speedAccuracy: 1,
      timestamp: Date(timeIntervalSince1970: 0),
      verticalAccuracy: 1
    )

    #expect(a == a)
    #expect(a != differentSpeedAccuracy)
    #expect(a != differentCourseAccuracy)
  }

  @Test func testDependencyOverride() {
    withDependencies {
      $0.locationManager.locationServicesEnabled = { true }
      $0.locationManager.authorizationStatus = { .denied }
      $0.locationManager.location = {
        Location(coordinate: CLLocationCoordinate2D(latitude: 40.6501, longitude: -73.94958))
      }
    } operation: {
      @Dependency(\.locationManager) var locationManager
      #expect(locationManager.locationServicesEnabled())
      #expect(locationManager.authorizationStatus() == .denied)
      #expect(locationManager.location()?.coordinate.latitude == 40.6501)
    }
  }

  @Test func testDelegateStreamYieldsActions() async {
    let (stream, continuation) = AsyncStream<LocationManager.Action>.makeStream()

    let location = Location(coordinate: CLLocationCoordinate2D(latitude: 1, longitude: 2))

    continuation.yield(.didChangeAuthorization(.authorizedAlways))
    continuation.yield(.didUpdateLocations([location]))
    continuation.finish()

    let received = await withDependencies {
      $0.locationManager.delegate = { stream }
    } operation: { () async -> [LocationManager.Action] in
      @Dependency(\.locationManager) var locationManager
      var actions: [LocationManager.Action] = []
      for await action in locationManager.delegate() {
        actions.append(action)
      }
      return actions
    }

    #expect(
      received == [
        .didChangeAuthorization(.authorizedAlways),
        .didUpdateLocations([location]),
      ]
    )
  }

  @Test func testFireAndForgetEndpointInvocation() {
    let requestLocationCount = LockIsolated(0)
    let requestWhenInUseCount = LockIsolated(0)
    
    withDependencies {
      $0.locationManager.requestLocation = {
        requestLocationCount.withValue { $0 += 1 }
      }
      $0.locationManager.requestWhenInUseAuthorization = { requestWhenInUseCount.withValue { $0 += 1 } }
    } operation: {
      @Dependency(\.locationManager) var locationManager
      locationManager.requestLocation()
      locationManager.requestLocation()
      locationManager.requestWhenInUseAuthorization()
    }

    #expect(requestLocationCount.value == 2)
    #expect(requestWhenInUseCount.value == 1)
  }
}
