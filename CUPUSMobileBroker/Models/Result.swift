import SwiftSocket

public enum Result<T> {
    case success(value: T)
    case failure(error: Error)

    static func from(result: SwiftSocket.Result) -> Result<Bool> {
        switch result {
        case .success:
            return Result<Bool>.success(value: true)
        case .failure(let error):
            return Result<Bool>.failure(error: error)
        }
    }
}

func == <T: Equatable>(lhs: Result<T>, rhs: Result<T>) -> Bool {
    switch (lhs, rhs) {
    case (.success(let value1), .success(let value2)):
        return value1 == value2
    default:
        return false
    }
}
