import UIKit

class StoriesTableViewController: UITableViewController  {
  
  let stories = ["The Campaign Speech", "A Love Letter", "Dear John",
                 "Diary of a Castaway", "Captain’s Log", "I Quit",
                 "Restaurant Review", "A Night in the Graveyard",
                 "Some Limericks", "From the Future", "Detention at School",
                 "Insomnia", "Fairy Magic", "A Trip to the Nether",
                 "Attack of Herobrine"]
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection: Int) -> Int {
    let delegate = UIApplication.shared.delegate as! AppDelegate
    return delegate.templates.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
  {
    let cell = tableView.dequeueReusableCell(withIdentifier: "StoryTitle",
                                             for: indexPath)
    let delegate = UIApplication.shared.delegate as! AppDelegate
    let template = delegate.templates[indexPath.row]

    cell.textLabel?.text = template.title
    return cell
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let controller = segue.destination as! PhrasesViewController


    let b = UIBarButtonItem(title: NSLocalizedString("Submit", comment: ""),
                            style: .plain, target: controller,
                            action: #selector(PhrasesViewController.submitPhrases(_:)))
    b.isEnabled = false
    controller.navigationItem.rightBarButtonItem = b
    controller.title = NSLocalizedString("Phrases", comment: "")

    if let row = self.tableView.indexPathForSelectedRow?.row {
      let delegate = UIApplication.shared.delegate as! AppDelegate
      let template = delegate.templates[row]
      controller.template = template
      controller.installTextFields(for: template.variables)
    }
  }

}

func extractFields(_ s: String) -> [String]
{
  var matches = [String]()
  var range = s.startIndex ..< s.endIndex
  var match: Range<String.Index>?

  repeat {
    /*
     * Using a regular expression here is a bit much, but it's handy.
     * Note that the "*?" operator is a non-greedy version of the usual "*".
     * That is, "*?" matches as few times as possible.
     */
    match = s.range(of: "\\{.*?\\}", options: .regularExpression, range: range)
    if let r = match {
      let low = s.index(r.lowerBound, offsetBy: 1)
      let high = s.index(r.upperBound, offsetBy: -1)
      matches.append(s.substring(with: low ..< high))
      range = high ..< s.endIndex
    }
  } while (match != nil)

  return matches
}
