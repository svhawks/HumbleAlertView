# HumbleAlertView

Temporary and unobtrusive translucent alert view for iOS.

![Demo](https://media.giphy.com/media/l378oq9EG6yJqjgfS/giphy.gif)

## Details

HumbleAlertView allows you to present a translucent alert view with a title and an optional message on the bottom of the screen. Use it to inform your user about temporary issues that do not require any immediate action and are not blocking the flow of your app.

HumbleAlertView can have a title and an optional message, in a way similar to UIAlertView. It automatically fades out after a configurable time interval and, by default, can be dismissed with a tap. It can automatically adapt its size according to the device it's being deployed on, user interface orientation and length of the strings passed to it.


## Demo

To run the example project, clone the repo, and run `pod install` from the Demo directory first.

## Installation

HumbleAlertView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HumbleAlertView"
```


## Usage

HumbleAlertView requires that you include the QuartzCore.framework in your project.

After that, here's how you present an HumbleAlertView:

	let humble = HumbleAlertView(title: "Hi there.", message: nil, timeout: 5.0, dismissible: false)
	humble.show()

Just like with UIAlertView, the dismissal of the view is handled by the view itself, so there's no need to call anything else. If you do want to dismiss it manually, just call `hide` on the instance.

HumbleAlertView has to be `show`n in or after `viewDidAppear:` is invoked on the Root View Controller. If you attempt to call `show` before that, the instance may not be visible on the screen.

You can also have HumbleAlertView show only within your view of choice by calling `showInView:` instead of `show`.

### Init methods


#### initWithTitle:message:timeout:dismissible:

Exposes all of the available options. 

    init(title: String?, message: String?, timeout: TimeInterval, dismissible: Bool)

##### Parameters
_title_  
The string that appears in the view's title label.

_message_  
Descriptive text that provides more details than the title. Can be `nil`.

_timeout_  
Time interval before the alert is automatically dismissed. 

_dismissible_  
Whether the alert can be dismissed with a tap or not. 


#### initWithTitle:message:

Equivalent to `initWithTitle:message:timeout:dismissible:`, but assumes default values for `timeout` (`6` seconds) and `dismissible` (`true`). 

    init(title: String?, message: String?)


#### initWithTitle:

Equivalent to `initWithTitle:message:timeout:dismissible:`, but assumes default values for `message` (`nil`) `timeout` (`4` seconds) and `dismissible` (`true`). 

    init(title: String?)

### Properties

#### position
The vertical position of the view.

	position: HumbleAlertViewPosition;

This property controls the origin of the view on the Y axis.

The default value is `.bottom`.

#### style
The visual style of the view.

	style: HumbleAlertViewStyle

The view can have either light text on a dark background (`.dark`) or dark text over a light background (`.light`). 

The default value is `.standart`, which maps to `.light`.

#### completionBlock
A block to execute after the instance has been dismissed.

	completionBlock: (() -> Void)?

#### title
The string that appears in the title of the alert.

	title: String
	
Setting this property after initialization recalculates the view's metrics.

#### message
Descriptive text that provides more details than the title.

	message: String
	
Setting this property after initialization recalculates the view's metrics.

#### titleLabel
The label that displays the title.

	titleLabel: UILabel

#### messageLabel
The label that displays the title.

	messageLabel: UILabel

#### topContentMargin
A margin that prevents the alert from drawing above it.

	topContentMargin: CGFloat

#### bottomContentMargin
A margin that prevents the alert from drawing below it.

	bottomContentMargin: CGFloat

#### timeout
Time interval before the alert is automatically dismissed.

	timeout: NSTimeInterval

#### dismissible
Whether the alert can be dismissed with a tap or not.

	dismissable: Bool

#### visible
A Boolean value that indicates whether the view is currently visible on the screen.

	visible: Bool

Known Issues
---------------

Here are some current limitations in HumbleAlertView:

 - Adding an HumbleAlertView while displaying a keyboard will cause it to be placed under the keyboard. This can be worked around using the `position` property.

Help us make this better
---------------

We built HumbleAlertView because we needed it for one of our projects. If you improve it in any way, please send us a pull request. Enjoy!

## Author
| [<img src="https://avatars1.githubusercontent.com/u/1448702?v=4" width="100px;"/>](http://okaris.com)   | [Omer Karisman](http://okaris.com)<br/><br/><sub>Lead UI/UX @ [MojiLaLa](http://mojilala.com)</sub><br/> [![Twitter][1.1]][1] [![Dribble][2.1]][2] [![Github][3.1]][3]| [<img src="https://pbs.twimg.com/profile_images/1331045707961274368/-YifJbqn_400x400.jpg" width="100px;"/>](https://twitter.com/sahin)   | [Sahin Boydas](https://twitter.com/sahin)<br/><br/><sub>Founder @ [RemoteTeam.com](https://www.remtoeteam.com)</sub><br/> [![LinkedIn][4.1]][4]|
| - | :- | - | :- |

[1.1]: http://i.imgur.com/wWzX9uB.png (twitter icon without padding)
[2.1]: http://i.imgur.com/Vvy3Kru.png (dribbble icon without padding)
[3.1]: http://i.imgur.com/9I6NRUm.png (github icon without padding)
[4.1]: https://www.kingsfund.org.uk/themes/custom/kingsfund/dist/img/svg/sprite-icon-linkedin.svg (linkedin icon)

[1]: http://www.twitter.com/okarisman
[2]: http://dribbble.com/okaris
[3]: http://www.github.com/okaris
[4]: https://www.linkedin.com/in/sahinboydas

## Inspired from
ondalabs, http://ondalabs.com
