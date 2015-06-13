//
//  Frame.pb.swift
//  StructBuf
//
//  Created by David Paschich on 6/12/15.
//  Copyright © 2015 David Paschich. All rights reserved.
//

import Foundation

struct Frame: Message {

    let size: UInt32

    struct FrameBuilder: Builder {
        static func fromStream(stream: NSInputStream) throws -> Message {
            throw StructBufError.NotImplemented
        }
    }


}