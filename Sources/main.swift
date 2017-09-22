//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
func handler(data: [String:Any]) throws -> RequestHandler {
	return {
		request, response in
		// Respond with a simple message.
		response.setHeader(.contentType, value: "text/html")
		response.appendBody(string: "<html><head><meta charset='utf-8'></head><title>欢饮来到我的笔记!</title><body>你好，我的朋友!</body></html>")
		// Ensure that response.completed() is called when your processing is done.
		response.completed()
	}
}


let server = HTTPServer()
server.serverName = "localhost"
var routes = Routes()
routes.add(method: .get, uri: "/login") { (request, response) in
    response.setBody(string: "<html><head><meta charset='utf-8'></head><body><p>我是/login路asf径返回的信息</p></body></html>")
    response.completed()
}

server.addRoutes(routes)

server.serverPort = 8082

do {
try  server.start()
}catch{
    fatalError("\(error)");
}
// Configuration data for an example server.
// This example configuration shows how to launch a server
// using a configuration dictionary.
let confData = [
    "servers": [
        // Configuration data for one server which:
        //    * Serves the hello world message at <host>:<port>/
        //    * Serves static files out of the "./webroot"
        //        directory (which must be located in the current working directory).
        //    * Performs content compression on outgoing data when appropriate.
        [
            "name":"localhost",
            "port":8081,
            "routes":[
                ["method":"get", "uri":"/", "handler":handler],
                ["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
                 "documentRoot":"./webroot",
                 "allowResponseFilters":true]
            ],
            
            "filters":[
                [
                "type":"response",
                "priority":"high",
                "name":PerfectHTTPServer.HTTPFilter.contentCompression,
                ]
            ]
        ]
    ]
]

do {
    // Launch the servers based on the configuration data.
    try HTTPServer.launch(configurationData: confData)
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}






