import UIKit

class StoryViewController: UIViewController {

  @IBOutlet weak var textView: UITextView!

  var template: Template = Template("")

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    textView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
  }

  @objc func done(_ sender: AnyObject?) {
    _ = navigationController?.popToRootViewController(animated: true)
  }

  @IBAction func showShareSheet(_ sender: UIBarButtonItem) {
    let controller = UIActivityViewController(activityItems: [textView.text], applicationActivities: nil)

    controller.modalPresentationStyle = .popover

    let popover = controller.popoverPresentationController
    popover?.barButtonItem = sender

    self.present(controller, animated: true, completion: nil)
  }

  func renderTemplate()
  {
    let text = NSMutableAttributedString()
    let frags = template.frags
    let phrases = template.phrases

    let style = NSMutableParagraphStyle()
    style.alignment = .center
    let titleFont = UIFont(name: "BodoniSvtyTwoOSITCTT-Bold", size: 24)
    let titleAttributes = [NSAttributedStringKey.font: titleFont!,
                           NSAttributedStringKey.paragraphStyle: style] as [NSAttributedStringKey : Any]

    let plainFont = UIFont(name: "BodoniSvtyTwoOSITCTT-Book", size: 24)
    let plainAttributes = [NSAttributedStringKey.font: plainFont!] as [NSAttributedStringKey : Any]
    let phraseFont = UIFont(name: "IrishGrover", size: 24)
    let phraseAttributes = [NSAttributedStringKey.font: phraseFont!,
                            NSAttributedStringKey.foregroundColor: UIColor.purple] as [NSAttributedStringKey : Any]
    let newline = NSAttributedString(string: "\n", attributes: plainAttributes)

    let a = NSAttributedString(string: template.title, attributes: titleAttributes)
    text.append(a)
    text.append(newline)
    text.append(newline)

    let fragCount = frags.count
    let phraseCount = phrases.count
    for i in 0 ..< fragCount {
      let a = NSAttributedString(string: frags[i], attributes: plainAttributes)
      text.append(a)
      if (i < phraseCount) {
        let b = NSAttributedString(string: phrases[i], attributes: phraseAttributes)
        text.append(b)
      }
    }
    textView.textStorage.setAttributedString(text)
  }
}
