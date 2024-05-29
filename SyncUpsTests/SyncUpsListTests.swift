import ComposableArchitecture
import XCTest

@testable import SyncUps

final class SyncUpsListTests: XCTestCase {
  @MainActor
  func testAddSyncUp_NonExhaustive() async {
    let store = TestStore(initialState: SyncUpsList.State()) {
      SyncUpsList()
    } withDependencies: {
      $0.uuid = .incrementing
    }
    store.exhaustivity = .off

    await store.send(.addSyncUpButtonTapped)

    let editedSyncUp = SyncUp(
      id: SyncUp.ID(UUID(0)),
      attendees: [
        Attendee(id: Attendee.ID(), name: "Blob"),
        Attendee(id: Attendee.ID(), name: "Blob Jr.")
      ],
      title: "Point-Free morning sync"
    )
    await store.send(\.addSyncUp.binding.syncUp, editedSyncUp)

    await store.send(\.confirmAddButtonTapped) {
      $0.syncUps = [editedSyncUp]
    }
  }

  @MainActor
  func testAddSyncUp() async {
    let store = TestStore(initialState: SyncUpsList.State()) {
      SyncUpsList()
    } withDependencies: {
      $0.uuid = .incrementing
    }

    await store.send(.addSyncUpButtonTapped) {
      $0.addSyncUp = SyncUpForm.State(
        syncUp: SyncUp(id: SyncUp.ID(UUID(0)))
      )
    }

    let editedSyncUp = SyncUp(
      id: SyncUp.ID(UUID(0)),
      attendees: [
        Attendee(id: Attendee.ID(), name: "Blob"),
        Attendee(id: Attendee.ID(), name: "Blob Jr.")
      ],
      title: "Point-Free morning sync"
    )
    await store.send(\.addSyncUp.binding.syncUp, editedSyncUp) {
      $0.addSyncUp?.syncUp = editedSyncUp
    }

    await store.send(\.confirmAddButtonTapped) {
      $0.addSyncUp = nil
      $0.syncUps = [editedSyncUp]
    }
  }

  @MainActor
  func testDeletion() async {
    let store = TestStore(
      initialState: SyncUpsList.State(
        syncUps: [
          SyncUp(
            id: SyncUp.ID(),
            title: "Point-Free Morning Sync"
          )
        ]
      )
    ) {
      SyncUpsList()
    }

    await store.send(.onDelete([0])) {
      $0.syncUps = []
    }
  }
}
