import UIKit

class PhrasesViewController: UIViewController, UITextFieldDelegate {

  var textFields = [UITextField]()
  var activeField: UITextField?
  var phrases = [String]()
  var template = Template("")

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var stackView: UIStackView!
  @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let c = NotificationCenter.default
    c.addObserver(self,
                  selector: #selector(PhrasesViewController.keyboardDidShow(_:)),
                  name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    c.addObserver(self,
                  selector: #selector(PhrasesViewController.keyboardWillHide(_:)),
                  name: NSNotification.Name.UIKeyboardWillHide, object: nil)

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  @objc func keyboardDidShow(_ notification: NSNotification)
  {
    let info = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey]

    if let screenRect = (info as AnyObject?)?.cgRectValue {
      let kbrect = view.convert(screenRect, from: nil)
      scrollViewBottomConstraint.constant = kbrect.size.height
      view.layoutIfNeeded()
      
      var shortRect = view.frame
      shortRect.size.height -= kbrect.size.height
      var firstResponder: UIView? = nil
      
      for child in stackView.arrangedSubviews {
        if child.isFirstResponder {
          firstResponder = child
          break
        }
      }
      
      if firstResponder != nil {
        let field = firstResponder as! UITextField
        
        if (shortRect.contains(field.frame.origin) == false) {
          scrollView.scrollRectToVisible(field.frame, animated: true)
        }
      }

    }
  }
  
  @objc func keyboardWillHide(_ notification: NSNotification)
  {
    scrollViewBottomConstraint.constant = 0
    view.layoutIfNeeded()
  }
  
  // Use the return key to go to the next text field.
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    let nextTag = (textField.tag + 1)
    let nextField = stackView.viewWithTag(nextTag)
    
    if nextField != nil {
      nextField?.becomeFirstResponder()
    } else {
      textField.resignFirstResponder()
    }
    return true
  }

  // Watch all the text fields to enable/disable the "Submit" button
  @objc func editingChanged(sender: UIButton)
  {
    var enabled = true

    for field in textFields {
      guard let text = field.text else {
        enabled = false
        break
      }
      if text == "" {
        enabled = false
        break
      }
    }
    // If we got here, all the fields are non-empty.
    navigationItem.rightBarButtonItem?.isEnabled = enabled
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as! StoryViewController
    let b = UIBarButtonItem(title: NSLocalizedString("Done", comment:""),
                            style: .plain, target: controller,
                            action: #selector(StoryViewController.done(_:)))

    controller.template = template
    controller.navigationItem.rightBarButtonItem = b
    controller.loadViewIfNeeded()
    controller.renderTemplate()
   }
  
  
  /*
   * Create text fields for each phrase to be filled in.  Assign tags
   * consecutively from 0 so that we can arrange for the return key to go
   * the next text field in sequence.
   */
  func installTextFields(for array: [String])
  {
    self.loadViewIfNeeded()
    
    stackView.subviews.forEach { $0.removeFromSuperview() }
    textFields.removeAll()
    
    var tag = 0
    
    for placeholder in array {
      let field = phraseTextField(placeholder)
      field.tag = tag
      tag = tag + 1
      field.delegate = self
      field.addTarget(self, action: #selector(editingChanged(sender:)),
                      for: .editingChanged)
      stackView.addArrangedSubview(field)
      textFields.append(field)
    }
  }

  @objc func submitPhrases(_ sender: Any?)
  {
    let answers = textFields.map({ (f) -> String in
      if let phrase = f.text {
        return phrase
      } else {
        return "unspecified"
      }
    })
    template.phrases = answers

    self.performSegue(withIdentifier: "Show Story", sender: sender)
  }
  
}

private func phraseTextField(_ string: String) -> UITextField
{
  let field = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 44))

  field.placeholder = string
  field.borderStyle = .none
  field.textAlignment = .center
  field.autocapitalizationType = .none
  field.adjustsFontSizeToFitWidth = true
  field.minimumFontSize = 24
  if let font = UIFont(name: "BodoniSvtyTwoOSITCTT-Book", size: 36) {
    field.font = font
  }
  return field
}

