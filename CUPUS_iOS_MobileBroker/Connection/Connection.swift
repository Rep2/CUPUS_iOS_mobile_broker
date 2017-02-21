enum ConnectionError: Error {
    case failedToConnect
    case stringConversionFailed
}

public class Connection: NSObject {
    
    // Initializes TCP connection for given host and port
    //
    // - Throws: 'ConnectionError.streamsNotInitialized' when connection was not established
    public static func connect(host: String, port: Int, delegate: StreamDelegate) throws -> Connection {
        var inputStream: InputStream?
        var outputStream: OutputStream?
        
        Stream.getStreamsToHost(withName: host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        
        guard let iStream = inputStream, let oStream = outputStream else {
            throw ConnectionError.failedToConnect
        }
        
        return Connection(inputStream: iStream, outputStream: oStream, delegate: delegate)
    }
    
    
    private let inputStream: InputStream
    private let outputStream: OutputStream
    
    private let delegate: StreamDelegate
    
    init(inputStream: InputStream, outputStream: OutputStream, delegate: StreamDelegate) {
        self.inputStream = inputStream
        self.outputStream = outputStream
        self.delegate = delegate
        
        super.init()
        
        inputStream.delegate = delegate
        outputStream.delegate = delegate
        
        inputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        outputStream.schedule(in: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        
        inputStream.open()
        outputStream.open()
    }
}
