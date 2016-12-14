import Foundation
import MobileCoreServices
import UIKit


// MARK: - Pasteboard Helpers
//
extension UIPasteboard
{
    /// Removes all of the stored Rich String's Attributes
    ///
    func stripStringAttributes() {
        let plainOptions = [NSDocumentTypeDocumentAttribute: NSPlainTextDocumentType]
        let richOptions = [NSDocumentTypeDocumentAttribute: NSRTFTextDocumentType]

        let supportedTypes = [
            String(kUTTypeRTF):         richOptions,
            String(kUTTypeText):        richOptions,
            String(kUTTypePlainText):   plainOptions
        ]

        for (type, options) in supportedTypes {
            guard let data = data(forPasteboardType: type),
                let original = try? NSAttributedString(data: data, options: options, documentAttributes: nil),
                let stripped = original.string.data(using: .utf8) else
            {
                continue
            }

            setData(stripped, forPasteboardType: type)
        }
    }

    /// Removes all of the Aztec-Stored String's Attributes
    ///
    func stripAztecAttributes() {
        guard let data = value(forPasteboardType: NSAttributedString.pastesboardUTI) as? Data,
            let original = NSAttributedString.unarchive(with: data) else
        {
            return
        }

        let rearchived = NSAttributedString(string: original.string).archivedData()
        setValue(rearchived, forPasteboardType: NSAttributedString.pastesboardUTI)
    }
}
