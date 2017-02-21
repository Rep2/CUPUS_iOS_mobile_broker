public class ConnectionDelegate: NSObject, StreamDelegate {
    
    var messages = [(Data, () -> Void)]()
    var dataBeingWritten: Data?
    
    var streamHasSpaceAvailable: OutputStream?
    
    
    public func write(message: String, callback: @escaping () -> Void) throws {
        guard let messageData = message.data(using: .ascii) else {
            throw ConnectionError.stringConversionFailed
        }
        
        write(data: messageData, callback: callback)
    }
    
    public func write(data: Data, callback: @escaping () -> Void) {
        let data = NSMutableData(data: data)
        
        data.append("\n".data(using: .ascii)!)
        
        messages.append((data as Data, callback))
        
        // Trigger writing by hand
        if let stream = streamHasSpaceAvailable {
            write(to: stream)
        }
    }
    
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasSpaceAvailable:
            if let stream = aStream as? OutputStream {
                write(to: stream)
            }
        case Stream.Event.endEncountered:
            print("end encountered11111111111")
        default:
            break
        }
    }
    
    // Called only when stream is in state hasSpaceAvailable
    private func write(to stream: OutputStream) {
        if let (message, callback) = messages.first {
            streamHasSpaceAvailable = nil
            
            var data: Data
            
            if let dataBeingWritten = dataBeingWritten {
                data = dataBeingWritten
            } else {
                data = message
            }
            
            let count = data.withUnsafeBytes {
                stream.write($0, maxLength: data.count)
            }
            
            if count == data.count {
                messages.removeFirst()
                
                callback()
                
                print("Written whole message count: \(count)")
            } else {
                dataBeingWritten = data.dropFirst(count).base
                
                print("Written first \(count) caracters of message")
            }
        } else {
            // If no data is written stream will not recieve further hasSpaceAvailable
            // Because of that we need to remember that stream is available for writing and trigger it by hand
            streamHasSpaceAvailable = stream
        }
    }
    
}
