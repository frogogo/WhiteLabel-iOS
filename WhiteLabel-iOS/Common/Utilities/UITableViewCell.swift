import UIKit

extension UITableViewCell {
  /// Convenience computed property. Returns string reuse identifier exactly matching with cell class name
  static var reuseID: String {
    return String(describing: self)
  }

  /// Convenience computed property. Returns string xibName identifier exactly matching with cell class name
  static var xibName: String {
    return String(describing: self)
  }

  /// Convenience method. It registers xib matching with class name in passed table view
  static func registerNibInTableView(_ tableView: UITableView) {
    let nibToRegister = UINib(nibName: self.xibName, bundle: nil)
    tableView.register(nibToRegister, forCellReuseIdentifier: self.reuseID)
  }
}
