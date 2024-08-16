//
//  SplashReactorImp.swift
//
//  Splash
//
//  Created by 조용인
//

import SplashDomain
import SplashPresenter
import FCMDomain
import RecordsDomain
import AppCoordinator

import ReactorKit
import RxSwift

public final class SplashReactorImp: SplashReactor {
  public typealias Action = SplashReactorAction
  public typealias Mutation = SplashReactorMutation
  public typealias State = SplashReactorState
  
  public let initialState: State
  public let coordinator: any AppCoordinator
  
  private let checkTokenUseCase: CheckTokenUsecase
  private let checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase
  private let fcmSaveUseCase: FCMSaveUseCase
  private let checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  private let disposeBag = DisposeBag()
  
  public init(
    coordinator: any AppCoordinator,
    checkTokenUseCase: CheckTokenUsecase,
    checkIsFirstLoadedUseCase: CheckIsFirstLoadedUseCase,
    fcmSaveUseCase: FCMSaveUseCase,
    checkRecordCalendarUseCase: CheckCalendarRecordsUseCase
  ) {
    self.coordinator = coordinator
    self.checkTokenUseCase = checkTokenUseCase
    self.checkIsFirstLoadedUseCase = checkIsFirstLoadedUseCase
    self.fcmSaveUseCase = fcmSaveUseCase
    self.checkRecordCalendarUseCase = checkRecordCalendarUseCase
    self.initialState = State()
  }
  
  public func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .checkToken:
      return checkIsFirstLoadedUseCase.execute()
        .flatMap { isAlreadyLoaded in
          isAlreadyLoaded ? self.handleTokenCheckFlow() : .just(.startAuth)
        }
    }
  }
  
  public func reduce(state: State, mutation: Mutation) -> State {
    var newState = state
    switch mutation {
    case .startAuth:
      coordinator.destination.accept(.startAuth)
    case .startMain:
      coordinator.destination.accept(.startHome)
    }
    return newState
  }
}

// MARK: - Private Methods

extension SplashReactorImp {
  
  private func checkToken() -> Observable<Bool> {
    guard let accessToken = checkTokenUseCase.execute() else {
      return .just(false) // 토큰이 없으면 인증 필요
    }
    return .just(true) // 토큰이 있으면 메인으로
  }
  
  private func handleTokenCheckFlow() -> Observable<Mutation> {
    return checkToken()
      .flatMap { isAuthenticated in
        isAuthenticated ? self.performPostAuthenticationTasks() : .just(.startAuth)
      }
      .catchAndReturn(.startAuth)
  }
  
  private func performPostAuthenticationTasks() -> Observable<Mutation> {
    // FCM 토큰 저장, 기록 캘린더 확인을 순차적으로 처리
    return saveFCMToken()
      .flatMap { _ in self.checkRecordCalendar() }
      .map { _ in .startMain }
      .catchAndReturn(.startMain)
  }
  
  private func saveFCMToken() -> Observable<Void> {
    return fcmSaveUseCase.execute()
      .asObservable()
      .do(onNext: { _ in
        print("FCM 토큰 저장 완료")
      })
  }
  
  private func checkRecordCalendar() -> Observable<Void> {
    /// 최초 cursor 값 설정
    return fetchCalendarRecords(cursor: "2024-01-01", limit: 10)
  }
  
  private func fetchCalendarRecords(cursor: String, limit: Int) -> Observable<Void> {
    /// checkRecordCalendarUseCase를 사용하여 서버에서 데이터를 받아옴
    return checkRecordCalendarUseCase.execute(cursor: cursor, limit: limit)
      .asObservable()
      .flatMap { calendarModel -> Observable<Void> in
        print("기록 캘린더 확인 완료: \(calendarModel)")
        
        /// nextCursor가 nil이 아닐 경우, 재귀적으로 다음 페이지 데이터를 가져옴
        if let nextCursor = calendarModel.nextCursor.nextCursor {
          return self.fetchCalendarRecords(cursor: nextCursor, limit: limit)
        } else {
          /// nextCursor가 nil이면 더 이상 데이터를 요청하지 않고 완료
          return .just(Void())
        }
      }
      .catch { error in
        /// 에러 처리 및 종료
        print("기록 캘린더 확인 중 에러 발생: \(error)")
        return .just(Void()) // 에러가 발생해도 일단 흐름이 중단되지 않도록 처리
      }
  }
}
