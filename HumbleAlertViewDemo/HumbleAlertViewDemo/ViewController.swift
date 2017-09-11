import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    view = UIView()
    view.backgroundColor = UIColor.lightGray
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let demo = HumbleAlertView(title: "Hi there.", message: nil, timeout: 5.0, dismissible: false)
    demo.position = .top
    demo.topContentMargin = 64.0
    demo.completionBlock = {(_: Void) -> Void in
      let demo2 = HumbleAlertView(title: "This is a demo of HumbleAlertView.")
      demo2.position = .center
      demo2.style = .light
      demo2.completionBlock = {(_: Void) -> Void in
        let demo3 = HumbleAlertView(title: "Check out the code.", message: "Try out different setups before implementing it in your app.")
        demo3.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 19.0)
        demo3.messageLabel?.font = UIFont(name: "AvenirNext-Regular", size: 14.0)
        demo3.style = .dark
        demo3.bottomContentMargin = 50.0
        demo3.completionBlock = {(_: Void) -> Void in
          let demo4 = HumbleAlertView(title: "Have fun!", message: "You can tap this message to dismiss it.", timeout: 900.0, dismissible: true)
          demo4.position = .center
          demo4.show()
        }
        demo3.show()
      }
      demo2.show()
    }
    demo.show(in: view)
  }


  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

