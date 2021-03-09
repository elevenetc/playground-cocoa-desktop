//
//  ViewController.swift
//  window-manager
//
//  Created by Eugene Levenetc on 08/03/2021.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let apps = NSWorkspace.shared.runningApplications
        let screens = NSScreen.screens
        
        for app in apps as Array {
            print("running app: \(app.processIdentifier): \(String(describing: app.localizedName))")
        }
        
        for screen in screens as Array {
            print("screen: \(screen.localizedName)")
        }

        let windowList: CFArray? = CGWindowListCopyWindowInfo(.optionOnScreenOnly, kCGNullWindowID)

        for entry in windowList! as Array {

            let ownerName: String = entry.object(forKey: kCGWindowName) as? String ?? "N/A"
            let ownerPID: Int = entry.object(forKey: kCGWindowOwnerPID) as? Int ?? 0
            let windowNumber: Int32 = entry.object(forKey: kCGWindowNumber) as? Int32 ?? 0
            let ownerBounds = entry.object(forKey: kCGWindowBounds) as? NSDictionary ?? [String: Any]() as NSDictionary
            print("windowNumber: \(windowNumber), ownerPID:\(ownerPID), bounds:\(ownerBounds)")
            switchToApp(withWindow: windowNumber)
        }
    }
    
    func switchToApp(withWindow windowNumber: Int32) {
        let options = CGWindowListOption(arrayLiteral: CGWindowListOption.excludeDesktopElements, CGWindowListOption.optionOnScreenOnly)
        let windowListInfo = CGWindowListCopyWindowInfo(options, CGWindowID(0))
        guard let infoList = windowListInfo as NSArray? as? [[String: AnyObject]] else { return }
        if let window = infoList.first(where: { ($0["kCGWindowNumber"] as? Int32) == windowNumber}), let pid = window["kCGWindowOwnerPID"] as? Int32 {
            let app = NSRunningApplication(processIdentifier: pid)!
            //app?.activate(options: .activateIgnoringOtherApps)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

