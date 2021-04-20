import NotificationCenter

class BaseViewModel {
  // MARK: - Lifecycle methods
  init() {
    subscribeForNotifications()
  }

  deinit {
    unsubscribeFromAllNotifications()
  }

  // MARK: - Internal/public custom methods
  /**
   Override this method to subscribe for notifications from NotificationCenter. Default implementation does nothing
   */
  func subscribeForNotifications() {
    // default implementation does nothing
  }

  /**
   Override this method to implement initial data loading. Default implementation does nothing
   */
  func loadInitialData() {
    // default implementation does nothing
  }

  /**
   Override this method to implement data refreshing. Default implementation does nothing
   */
  func refreshData() {
    // default implementation does nothing
  }

  // MARK: - Private custom methods
  private func unsubscribeFromAllNotifications() {
    NotificationCenter.default.removeObserver(self)
  }
}
