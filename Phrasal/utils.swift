import UIKit

func documentsDirectory() -> URL
{
  let urls = FileManager.default.urls(for: .documentDirectory,
                                      in: .userDomainMask)
  return urls[0]
}

func storiesDirectory() -> URL
{
  let urls = FileManager.default.urls(for: .applicationSupportDirectory,
                                      in: .userDomainMask)
  return urls[0].appendingPathComponent("Templates", isDirectory: true)
}
