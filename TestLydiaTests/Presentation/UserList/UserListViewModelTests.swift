//
//  UserListViewModelTests 2.swift
//  TestLydia
//
//  Created by David Geoffroy on 01/07/2025.
//
import XCTest
import FactoryKit
import Combine
@testable import TestLydia

final class UserListViewModelTests: XCTestCase {
    var viewModel: UserListViewModel!
    var mockCoordinator: MockUserListCoordinator!
    var mockFetchUsersUseCase: MockFetchUsersUseCase!
    var mockFetchNextUsersUseCase: MockFetchNextUsersUseCase!

    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()

        mockCoordinator = MockUserListCoordinator(navigationController: UINavigationController())
        mockFetchUsersUseCase = MockFetchUsersUseCase()
        mockFetchNextUsersUseCase = MockFetchNextUsersUseCase()

        // Injecter les mocks dans Factory (exemple)
        Container.shared.fetchUsersUseCase.register { self.mockFetchUsersUseCase }
        Container.shared.fetchNextUsersUseCase.register { self.mockFetchNextUsersUseCase }

        viewModel = UserListViewModel(coordinator: mockCoordinator)
    }

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func testInitialLoad_success_emitsDataNeedsReload() async {
        let expectedUsers = UserEntity.mocks(count: 2)
        mockFetchUsersUseCase.usersToReturn = expectedUsers

        let expectationReload = expectation(description: "Data needs reload called")
        viewModel.dataNeedsReload.sink {
            expectationReload.fulfill()
        }.store(in: &cancellables)

        await viewModel.initialLoad()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.usersCount, expectedUsers.count)
        await fulfillment(of: [expectationReload], timeout: 1)
    }

    func testInitialLoad_failure_emitsInitError() async {
        mockFetchUsersUseCase.errorToThrow = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network error"])

        let expectationError = expectation(description: "Init error emitted")
        viewModel.initErrorPublisher.sink { message in
            XCTAssertTrue(message.contains("Network error"))
            expectationError.fulfill()
        }.store(in: &cancellables)

        await viewModel.initialLoad()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.usersCount, 0)
        await fulfillment(of: [expectationError], timeout: 1)
    }

    func testRefresh_success_emitsDataNeedsReload() async {
        let expectedUsers = UserEntity.mocks(count: 3)
        mockFetchNextUsersUseCase.usersToReturn = expectedUsers

        let expectationReload = expectation(description: "Data needs reload on refresh")
        viewModel.dataNeedsReload.sink {
            expectationReload.fulfill()
        }.store(in: &cancellables)

        await viewModel.refresh()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.usersCount, expectedUsers.count)
        await fulfillment(of: [expectationReload], timeout: 1)
    }

    func testRefresh_failure_emitsInitError() async {
        mockFetchNextUsersUseCase.errorToThrow = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])

        let expectationError = expectation(description: "Init error on refresh")
        viewModel.initErrorPublisher.sink { message in
            XCTAssertTrue(message.contains("Server error"))
            expectationError.fulfill()
        }.store(in: &cancellables)

        await viewModel.refresh()

        XCTAssertFalse(viewModel.isLoading)
        await fulfillment(of: [expectationError], timeout: 1)
    }

    func testLoadMore_success_appendsUsersAndEmitsReload() async {
        let initialUsers = UserEntity.mocks(count: 2)
        let moreUsers = UserEntity.mocks(count: 2)
        mockFetchNextUsersUseCase.usersToReturn = moreUsers

        await viewModel.initialLoad()

        mockFetchUsersUseCase.usersToReturn = initialUsers
        await viewModel.initialLoad()

        let expectationReload = expectation(description: "Data needs reload on loadMore")
        viewModel.dataNeedsReload.sink {
            expectationReload.fulfill()
        }.store(in: &cancellables)

        await viewModel.loadMore()

        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.usersCount, initialUsers.count + moreUsers.count)
        await fulfillment(of: [expectationReload], timeout: 1)
    }

    func testLoadMore_failure_emitsLoadMoreError() async {
        mockFetchNextUsersUseCase.errorToThrow = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Load more error"])

        let expectationError = expectation(description: "Load more error emitted")
        viewModel.loadMoreErrorPublisher.sink { message in
            XCTAssertTrue(message.contains("Load more error"))
            expectationError.fulfill()
        }.store(in: &cancellables)

        await viewModel.loadMore()

        XCTAssertFalse(viewModel.isLoading)
        await fulfillment(of: [expectationError], timeout: 1)
    }

    func testShowUserDetail_callsCoordinatorWithCorrectUser() async {
        let users = UserEntity.mocks(count: 3)
        mockFetchUsersUseCase.usersToReturn = users
        await viewModel.initialLoad()

        viewModel.showUserDetail(for: 1)

        XCTAssertTrue(mockCoordinator.showUserDetailCalled)
        XCTAssertEqual(mockCoordinator.userPassed, users[1])
    }

    func testGetCellModel_returnsCorrectCellEntity() async {
        let users = UserEntity.mocks(count: 2)
        mockFetchUsersUseCase.usersToReturn = users
        await viewModel.initialLoad()

        let cellModel = viewModel.getCellModel(for: 0)
        XCTAssertEqual(cellModel.name, "\(users[0].title) \(users[0].firstName) \(users[0].lastName)")
        XCTAssertEqual(cellModel.rawImage, users[0].rawProfilePicture)
    }
}
