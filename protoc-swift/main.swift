//
//  main.swift
//  protoc-swift
//
//  Created by David Paschich on 6/11/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

print("Hello, World!")

// Provide a plugin for the protoc compiler, as per
// https://developers.google.com/protocol-buffers/docs/reference/cpp/google.protobuf.compiler.command_line_interface#CommandLineInterface.AllowPlugins.details
//
// In particular, command line is:
// plugin [[]--out=OUTDIR] [[]--parameter=PARAMETER] PROTO_FILES < DESCRIPTORS

// open stdin as nsinputstream

// pass it to the FileDescriptorSet proto
let handle = NSFileHandle.fileHandleWithStandardInput()
let inputData = handle.availableData
print(inputData.length)
exit(1)
