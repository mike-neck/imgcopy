import Cocoa
import Foundation

class ImageViewWindow: NSWindow, NSWindowDelegate, NSApplicationDelegate {
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
    }
    
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(self)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApplication.shared.terminate(self)
        return true
    }
}

extension Data {
    func getSize() -> NSSize? {
        return image?.size
    }

    var image: NSImage? {
        get {
            NSImage(data: self)
        }
    }
}

@MainActor
func showInWindow(_ data: Data) throws {
    let windowApp = NSApplication.shared
    NSApp.setActivationPolicy(.regular)
    guard let image = data.image else {
        throw RuntimeError(description: "Unexpected data type for image")
    }
    let windowRect = getDefaultRect(image: image)
#if DEBUG
    print("image rect: x=\(windowRect.origin.x) y=\(windowRect.origin.y) h=\(windowRect.height) w=\(windowRect.width)")
#endif
    let imageView = NSImageView(image: image)
    imageView.imageScaling = .scaleProportionallyUpOrDown
    let window = ImageViewWindow(
        contentRect: windowRect,
        styleMask: [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView],
        backing: .buffered,
        defer: false
    )
    window.center()
    window.title = "Image View"
    window.contentView = imageView
    window.makeKeyAndOrderFront(nil)
    windowApp.delegate = window
    windowApp.run()
}

func getDefaultRect(image: NSImage) -> NSRect {
    guard let mainScreen = NSScreen.main else {
        return NSMakeRect(image.size.width, image.size.height, 0, 25)
    }
    let mainFrame = mainScreen.frame
    let size = mainFrame.size
    let width = size.width
    let height = size.height
    #if DEBUG
    print("calculated rect: w=\(width) h=\(height), image: w=\(image.size.width) h=\(image.size.height)")
    #endif
    return NSMakeRect(
            width / 3 + 1,
            height / 3 + 1,
            image.size.width,
            image.size.height,
    )
}

