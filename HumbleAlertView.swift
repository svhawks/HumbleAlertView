import QuartzCore
import UIKit

enum HumbleAlertViewPosition : Int {
  case bottom
  case center
  case top
}

enum HumbleAlertViewStyle : Int {
  case light
  case dark
  case standart
}


class HumbleAlertView: UIView {
  /**
   Equivalent to `initWithTitle:message:timeout:dismissible:`, but assumes default values for `message` (nil) `timeout` (4 seconds) and `dismissible` (YES).
   @param title The string that appears in the view's title label.
   */

  /**
   The vertical position of the view.

   The default value is `HumbleAlertViewPositionBottom`.
   */
  var position = HumbleAlertViewPosition(rawValue: 0)!
  /**
   The visual style of the view.

   The view can have either light text on a dark background (`HumbleAlertViewStyleDark`) or dark text over a light background (`HumbleAlertViewStyleLight`).

   The default value is `HumbleAlertViewStyleDefault`, which maps to `HumbleAlertViewStyleLight`.
   */
  private var _style = HumbleAlertViewStyle(rawValue: 0)!
  var style: HumbleAlertViewStyle {
    get {
      return _style
    }
    set(style) {
      if style == .standart {
        _style = .light
      }
      _style = style
      var backgroundColor: UIColor? = nil
      var textColor: UIColor? = nil
      if style == .light {
        backgroundColor = UIColor(white: 1, alpha: 0.95)
        textColor = UIColor.black
      }
      else {
        backgroundColor = UIColor(white: 0, alpha: 0.75)
        textColor = UIColor.white
      }
      self.backgroundColor = backgroundColor
      titleLabel?.textColor = textColor
      messageLabel?.textColor = textColor
    }
  }
  /**
   A margin that prevents the alert from drawing above it.
   */
  private var _topContentMargin: CGFloat = 0.0
  var topContentMargin: CGFloat {
    get {
      return _topContentMargin
    }
    set(topContentMargin) {
      _topContentMargin = topContentMargin
      setNeedsLayout()
    }
  }
  /**
   A margin that prevents the alert from drawing below it.
   */
  private var _bottomContentMargin: CGFloat = 0.0
  var bottomContentMargin: CGFloat {
    get {
      return _bottomContentMargin
    }
    set(bottomContentMargin) {
      _bottomContentMargin = bottomContentMargin
      setNeedsLayout()
    }
  }
  /**
   A block to execute after the instance has been dismissed.
   */
  var completionBlock: (() -> Void)? = nil
  /**
   The string that appears in the title of the alert.
   */
  private var _title: String = ""
  var title: String {
    get {
      return _title
    }
    set(title) {
      _title = title
      titleLabel?.text = title as String
      setNeedsLayout()
    }
  }
  /**
   Descriptive text that provides more details than the title.
   */
  private var _message: String = ""
  var message: String {
    get {
      return _message
    }
    set(message) {
      _message = message
      messageLabel?.text = message as String
      setNeedsLayout()
    }
  }
  /**
   The label that displays the title.
   */
  var titleLabel: UILabel?
  /**
   The label that displays the message.
   */
  var messageLabel: UILabel?
  /**
   Time interval before the alert is automatically dismissed.
   */
  var timeout = TimeInterval()
  /**
   Whether the alert can be dismissed with a tap or not.
   */
  private var _isDismissible: Bool = false
  var isDismissible: Bool {
    get {
      return _isDismissible
    }
    set(dismissible) {
      _isDismissible = dismissible
      if dismissible {
        addGestureRecognizer(dismissTap!)
      }
      else {
        if (gestureRecognizers != nil) {
          removeGestureRecognizer(dismissTap!)
        }
      }
    }
  }
  /**
   A Boolean value that indicates whether the view is currently visible on the screen.
   */
  private(set) var isVisible: Bool = false

  var dismissTap: UITapGestureRecognizer?
  var interfaceOrientation = UIInterfaceOrientation(rawValue: 0)!
  var innerMargin: CGFloat = 0.0
  var isKeyboardIsVisible: Bool = false
  var keyboardHeight: CGFloat = 0.0

  // MARK: - Initialization

  convenience init(title: String?) {
    self.init(title: title, message: nil, timeout: 4, dismissible: true)
  }

  /**
   Equivalent to `initWithTitle:message:timeout:dismissible:`, but assumes default values for `timeout` (6 seconds) and `dismissible` (YES).
   @param title The string that appears in the view's title label.
   @param message Descriptive text that provides more details than the title. Can be nil.
   */
  convenience init(title: String?, message: String?) {
    self.init(title: title, message: message, timeout: 6, dismissible: true)
  }

  /**
   Initializes a new HumbleAlertView instance.
   @param title The string that appears in the view's title label.
   @param message Descriptive text that provides more details than the title. Can be nil.
   @param timeout Time interval before the alert is automatically dismissed.
   @param dismissible Whether the alert can be dismissed with a tap or not.
   */
  convenience init(title: String?, message: String?, timeout: TimeInterval, dismissible: Bool) {
    self.init(frame: CGRect.zero)

    self.title = ((title != nil) ? title! : "")
    self.message = ((message != nil) ? message! : "")
    self.timeout = timeout
    isDismissible = dismissible
    
  }

  /**
   Shows the HumbleAlertView on top of the frontmost view controller.
   */
  func show() {
    if title.isEmpty && message.isEmpty {
      print("HumbleAlertView: Your alert doesn't have any content.")
    }
    if isVisible {
      return
    }
    var parentController: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController
    while ((parentController?.presentedViewController) != nil) {
      parentController = parentController?.presentedViewController
    }
    let parentView: UIView? = parentController?.view
    show(in: parentView!)
  }

  /**
   Shows the HumbleAlertView on top of the given `view`.
   */
  func show(in view: UIView) {
    for subview: UIView in view.subviews {
      if (subview is HumbleAlertView) {
        let otherHAV: HumbleAlertView? = (subview as? HumbleAlertView)
        otherHAV?.hide()
      }
    }
    view.addSubview(self)
    isVisible = true
    UIView.animate(withDuration: 0.5, animations: {() -> Void in
      self.alpha = 1
    }, completion: {(_ finished: Bool) -> Void in
      self.perform(#selector(self.hide), with: nil, afterDelay: self.timeout)
    })
  }

  /**
   Hides the HumbleAlertView.
   */
  @objc func hide() {
    NSObject.cancelPreviousPerformRequests(withTarget: self)
    UIView.animate(withDuration: 0.5, animations: {() -> Void in
      self.alpha = 0
    }, completion: {(_ finished: Bool) -> Void in
      self.isVisible = false
      self.removeFromSuperview()
      if (self.completionBlock != nil) {
        self.completionBlock!()
      }
    })
  }

  override init(frame: CGRect) {
    super.init(frame: frame)

    layer.cornerRadius = 5.0
    backgroundColor = UIColor(white: 0, alpha: 0.45)
    alpha = 0
    layer.shadowColor = UIColor(white: 0, alpha: 0.1).cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 30.0
    let motionEffects = UIMotionEffectGroup()
    let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    horizontalMotionEffect.minimumRelativeValue = -14
    horizontalMotionEffect.maximumRelativeValue = 14
    let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
    verticalMotionEffect.minimumRelativeValue = -18
    verticalMotionEffect.maximumRelativeValue = 18
    motionEffects.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
    addMotionEffect(motionEffects)
    titleLabel = UILabel(frame: CGRect(x: HORIZONTAL_PADDING, y: VERTICAL_PADDING, width: 0, height: 0))
    titleLabel?.backgroundColor = UIColor.clear
    titleLabel?.textColor = UIColor.white
    titleLabel?.textAlignment = .center
    titleLabel?.font = UIFont.boldSystemFont(ofSize: CGFloat(TITLE_FONT_SIZE))
    titleLabel?.numberOfLines = 0
    titleLabel?.lineBreakMode = .byWordWrapping
    titleLabel?.autoresizingMask = ([.flexibleWidth, .flexibleHeight])
    addSubview(titleLabel!)
    messageLabel = UILabel(frame: CGRect(x: Int(HORIZONTAL_PADDING), y: 0, width: 0, height: 0))
    messageLabel?.backgroundColor = UIColor.clear
    messageLabel?.textColor = UIColor.white
    messageLabel?.textAlignment = .center
    messageLabel?.font = UIFont.systemFont(ofSize: CGFloat(MESSAGE_FONT_SIZE))
    messageLabel?.numberOfLines = 0
    messageLabel?.lineBreakMode = .byWordWrapping
    messageLabel?.autoresizingMask = ([.flexibleWidth, .flexibleHeight])
    addSubview(messageLabel!)
    style = .standart
    position = .bottom
    interfaceOrientation = UIApplication.shared.statusBarOrientation
    if UI_USER_INTERFACE_IDIOM() == .phone {
      innerMargin = 25
    }
    else {
      innerMargin = 50
    }
    dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.hide))
    NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeOrientation), name: NSNotification.Name.UIApplicationDidChangeStatusBarOrientation, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Show and hide

  // MARK: - View layout
  override func layoutSubviews() {
    var maxWidth: CGFloat = 0
    var totalLabelWidth: CGFloat = 0
    var totalHeight: CGFloat = 0
    let screenRect: CGRect? = superview?.bounds
    if UI_USER_INTERFACE_IDIOM() == .phone {
      maxWidth = (superview?.bounds.size.width)! - 40.0 - (HORIZONTAL_PADDING * 2)
    }
    else {
      maxWidth = CGFloat(520 - (HORIZONTAL_PADDING * 2))
    }
    var constrainedSize = CGSize.zero
    constrainedSize.width = maxWidth
    constrainedSize.height = CGFloat(MAXFLOAT)
    let titleSize: CGSize? = title.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: titleLabel?.font!], context: nil).size
    var messageSize = CGSize.zero
    if message != "" {
      messageSize = message.boundingRect(with: constrainedSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: messageLabel?.font!], context: nil).size
      totalHeight = (titleSize?.height)! + messageSize.height + floor(VERTICAL_PADDING * 2.5)
    }
    else {
      totalHeight = (titleSize?.height)! + floor(VERTICAL_PADDING * 2)
    }
    if titleSize?.width == maxWidth || messageSize.width == maxWidth {
      totalLabelWidth = maxWidth
    }
    else if messageSize.width > (titleSize?.width)! {
      totalLabelWidth = messageSize.width
    }
    else {
      totalLabelWidth = (titleSize?.width)!
    }

    let totalWidth: CGFloat = totalLabelWidth + (HORIZONTAL_PADDING * 2)
    let xPosition: CGFloat? = floor(((screenRect?.size.width)! / 2) - (totalWidth / 2))
    var yPosition: CGFloat = 0
    switch position {
    case .center:
      yPosition = ceil(((screenRect?.size.height)! / 2) - (totalHeight / 2))
    case .top:
      yPosition = innerMargin + topContentMargin
    default:
      yPosition = (screenRect?.size.height)! - ceil(totalHeight) - innerMargin - bottomContentMargin
    }

    frame = CGRect(x: xPosition!, y: yPosition, width: ceil(totalWidth), height: ceil(totalHeight))
    if isKeyboardIsVisible && position == .bottom {
      frame = CGRect(x: frame.origin.x, y: frame.origin.y - keyboardHeight, width: frame.size.width, height: frame.size.height)
    }
    titleLabel?.frame = CGRect(x: (titleLabel?.frame.origin.x)!, y: ceil((titleLabel?.frame.origin.y)!), width: ceil(totalLabelWidth), height: ceil((titleSize?.height)!))
    if messageLabel != nil {
      messageLabel?.frame = CGRect(x: (messageLabel?.frame.origin.x)!, y: ceil((titleSize?.height)!) + floor(VERTICAL_PADDING * 1.5), width: ceil(totalLabelWidth), height: ceil(messageSize.height))
    }
  }

  @objc func keyboardWillShow(_ notification: Notification) {
    let keyboardInfo: [AnyHashable: Any]? = notification.userInfo
    let keyboardSize = keyboardInfo?[UIKeyboardFrameBeginUserInfoKey] as? CGSize ?? CGSize.zero
    isKeyboardIsVisible = true
    keyboardHeight = keyboardSize.height
    setNeedsLayout()
  }

  @objc func keyboardWillHide(_ notification: Notification) {
    isKeyboardIsVisible = false
    setNeedsLayout()
  }

  // MARK: - Orientation handling
  @objc func didChangeOrientation(_ notification: Notification) {
    interfaceOrientation = UIApplication.shared.statusBarOrientation
    setNeedsLayout()
  }

  // MARK: - Setters

  // MARK: - Cleanup
  deinit {
    NotificationCenter.default.removeObserver(self)
    removeGestureRecognizer(dismissTap!)
  }
}

let HORIZONTAL_PADDING: CGFloat = 18.0
let VERTICAL_PADDING: CGFloat = 14.0
let TITLE_FONT_SIZE = 17
let MESSAGE_FONT_SIZE = 14
