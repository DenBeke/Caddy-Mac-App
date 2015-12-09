//
//  ViewController.swift
//  Caddy
//
//  Created by Mathias Beke on 8/12/15.
//  Copyright © 2015 DenBeke. All rights reserved.
//

import Cocoa

func executeCommand(command: String, args: [String]) -> String {
    
    let task = NSTask()
    
    task.launchPath = command
    task.arguments = args
    
    let pipe = NSPipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output: String = String(data: data, encoding: NSUTF8StringEncoding)!
    
    return output
}


class ViewController: NSViewController {
    
    var task = NSTask()
    var pipe = NSPipe()
    
    var path      = ""
    var caddyfile = ""
    var running   = false;
    
    @IBOutlet weak var start_stop_button: NSButton!
    
    override func viewDidLoad() {
        
        // Delegate
        //window.delegate = self
        
        // Set path to executable
        self.path = String(NSBundle.mainBundle().pathForResource("caddy", ofType: "")!)
        
        // Set path to Caddyfile
        self.caddyfile = String(NSBundle.mainBundle().pathForResource("Caddyfile", ofType: "")!)
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func toggleServer(sender: AnyObject) {
        if !running {
            startCaddy()
        } else {
            stopCaddy()
        }
    }
    
    func startCaddy() {
        running = true
        start_stop_button.title = "Stop Caddy"
        self.task = NSTask()
        self.pipe = NSPipe()
        self.task.launchPath = path
        self.task.standardOutput = pipe
        self.task.arguments = ["-conf=\(self.caddyfile)"]
        self.task.launch()
        print("Launched Caddy")
    }
    
    func stopCaddy() {
        running = false
        start_stop_button.title = "Start Caddy"
        task.terminate()
        print("Terminated Caddy")
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

