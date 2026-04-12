import Foundation

guard CommandLine.arguments.count > 1 else {
  fputs("usage: rime-word-segment <text>\n", stderr)
  exit(1)
}

let text = CommandLine.arguments[1]
let range = text.startIndex..<text.endIndex
var rows: [String] = []

text.enumerateSubstrings(in: range, options: [.byWords, .localized]) { substring, subrange, _, _ in
  guard let token = substring, !token.isEmpty else { return }
  let start = text.distance(from: text.startIndex, to: subrange.lowerBound)
  let end = text.distance(from: text.startIndex, to: subrange.upperBound)
  rows.append("\(start)\t\(end)\t\(token)")
}

print(rows.joined(separator: "\n"))
