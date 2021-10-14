import UIKit

class BaseViewController: UIViewController {
  // MARK: - Properties
  /**
   This property used for some common operations with ViewModel. Child class implementation must set this property to actually created proper type view model
   */
  var commonTypeViewModel: BaseViewModel!

  // MARK: - Lifecycle methods
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    createViewModel()
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupStaticContentForDisplay()
    addBindings()
    commonTypeViewModel.loadInitialData()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    commonTypeViewModel.refreshData()
  }

  // MARK: - Custom public/internal methods
  /** Override this method to create instance of ViewModel with proper type. Don't call super in child class implementation
   */
  func createViewModel() {
    fatalError("Override \(#function) in \(type(of: self)) class. Do not call super in your implementation")
  }

  /** Override this method to bind reactions for view model's value changes
   */
  func addBindings() {

  }

  /** Override this method to set all static content on the screen
   No need to call super implementation, it does nothing
   */
  func setupStaticContentForDisplay() {

  }

  func showStandardErrorAlert(withMessage message: String, onDismiss: (() -> Void)? = nil) {
    let alert = UIAlertController(title: LocalizedString(forKey: "error_alert.title"),
                                  message: message,
                                  preferredStyle: .actionSheet)

    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
      onDismiss?()
    }))
    
    present(alert, animated: true, completion: nil)
  }
}
