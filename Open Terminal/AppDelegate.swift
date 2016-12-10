//
//  AppDelegate.swift
//  Open Terminal
//
//  Created by Quentin PÂRIS on 23/02/2016.
//  Copyright © 2016 QP. All rights reserved.
//

import Cocoa
import Darwin

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    let statusItem: NSStatusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength);
    let menu: NSMenu = NSMenu();
    
    public func applicationWillFinishLaunching(_ notification: Notification) {
        let appleEventManager:NSAppleEventManager = NSAppleEventManager.shared();
        appleEventManager.setEventHandler(self, andSelector: #selector(AppDelegate.handleGetURLEvent(event: replyEvent:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL));
        
        // 给menu bar添加自定义菜单
        if let button = statusItem.button {
            button.image = NSImage(named: "terminal");
        }
        
        menu.addItem(NSMenuItem(title: "About", action: #selector(AppDelegate.aboutMe(sender:)), keyEquivalent: "A"));
        menu.addItem(NSMenuItem.separator());
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.exitApplication(sender:)), keyEquivalent: "q"));
        
        statusItem.menu = menu;
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
        handlePlugin(election: "use");
//        SwiftySystem.execute(path: "/usr/bin/killall", arguments: ["Finder"]);
    }
    
    func handleGetURLEvent(event: NSAppleEventDescriptor?, replyEvent: NSAppleEventDescriptor?) {
        if let url = NSURL(string: event!.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))!.stringValue!) {
            if let unwrappedPath = url.path {
                if (FileManager.default.fileExists(atPath: unwrappedPath)) {
                    SwiftySystem.execute(path: "/bin/bash", arguments: ["-c", "open -F -n -b 'com.googlecode.iterm2' " + unwrappedPath]);
                } else {
                    help(message: "The specified directory does not exist");
                }
            }
        }
    }
    
    @IBAction func exitApplication(sender: AnyObject?) {
        handlePlugin(election: "ignore");
        exit(0);
    }
    
    @IBAction func aboutMe(sender: AnyObject?) {
        help(message: "This application adds a Open iTerm2 item in every Finder context menus.\n\n(c) Quentin PÂRIS 2016 - http://quentin.paris");
    }
    
    private func help(message: String) {
        let alert: NSAlert = NSAlert();
        alert.messageText = "Information"
        alert.informativeText = message;
        alert.runModal();
    }
    
    private func handlePlugin(election: String) {
        SwiftySystem.execute(path: "/usr/bin/pluginkit", arguments: ["-e", election, "-i", "com.magikid.openterminal.Open-iTerm2-Plugins"]);
    }
    
    public func applicationWillTerminate(_ notification: Notification) {
        exitApplication(sender: nil);
    }
}

