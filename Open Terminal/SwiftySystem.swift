//
//  SwiftySystem.swift
//  OpenTerminal
//
//  Created by Benny Lach on 28.10.16.
//  Copyright © 2016 QP. All rights reserved.
//

import Foundation

struct SwiftySystem {
    @discardableResult
    static func execute(path: String?, arguments: [String]?) -> Process {
        let task: Process = Process();
        task.launchPath = path;
        task.arguments = arguments;
        task.launch();
        
        task.waitUntilExit();
        
        return task;
    }
}
