import ComposableArchitecture
import XCTest

@testable import SyncUps

final class SyncUpFormTests: XCTestCase {
  @MainActor
  func testAddAttendee() async {
    let store = TestStore(
      initialState: SyncUpForm.State(
        syncUp: SyncUp(id: SyncUp.ID())
      )
    ) {
        SyncUpForm()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    await store.send(.addAttendeeButtonTapped) {
      $0.focus = .attendee(Attendee.ID(UUID(0)))
      $0.syncUp.attendees = [Attendee(id: Attendee.ID(UUID(0)))]
    }
  }

// TODO: This test is broken in the tutorial, fix when it's resolved.
//  @MainActor
//  func testRemoveAttendee() async {
//    let store = TestStore(
//      initialState: SyncUpForm.State(
//        syncUp: SyncUp(
//          id: SyncUp.ID(),
//          attendees: [
//            Attendee(id: Attendee.ID()),
//            Attendee(id: Attendee.ID())
//          ]
//        )
//      )
//    ) {
//      SyncUpForm()
//    }
//
//    await store.send(.onDeleteAttendees([0])) {
//      $0.syncUp.attendees.removeFirst()
//    }
//  }

  @MainActor
  func testRemoveFocusedAttendee() async {
    let attendee1 = Attendee(id: Attendee.ID())
    let attendee2 = Attendee(id: Attendee.ID())
    let store = TestStore(
      initialState: SyncUpForm.State(
        focus: .attendee(attendee1.id),
        syncUp: SyncUp(
          id: SyncUp.ID(),
          attendees: [attendee1, attendee2]
        )
      )
    ) {
        SyncUpForm()
    }

    await store.send(.onDeleteAttendees([0])) {
      $0.focus = .attendee(attendee2.id)
      $0.syncUp.attendees = [attendee2]
    }
  }
}
