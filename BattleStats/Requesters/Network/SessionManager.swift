import Foundation
import RxSwift
import Sniffer

// MARK: - Definitions
public enum HTTPMethod: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
}

public typealias Parameters = Any

fileprivate struct TaskCompletion {
    let taskId: Int?
    let observer: AnyObserver<(Response)>
    var responseData: Data
}

public struct Response {
    let data: Data
    let urlResponse: HTTPURLResponse
}

extension TaskCompletion: Equatable {
    static func == (lhs: TaskCompletion, rhs: TaskCompletion) -> Bool {
        return lhs.taskId == rhs.taskId
    }
}

// MARK: - Session Manager
protocol SessionManagerInterface: class {
    var session: URLSession { get }
    func resumeDataTask(forRequest request: URLRequest) -> Observable<Response>
}

public final class SessionManager: NSObject, SessionManagerInterface {
    var session: URLSession
    fileprivate var taskCompletions = [TaskCompletion]()
    
    init(environment: Environment = Environment()) {
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForRequest = 30
        
        let httpAdditionalHeaders = ["Content-Type" : "application/json; charset=utf-8"]
        urlSessionConfiguration.httpAdditionalHeaders = httpAdditionalHeaders
        
        if environment.enableRequestLogs {
            Sniffer.enable(in: urlSessionConfiguration)
        }
        
        self.session = URLSession(configuration: urlSessionConfiguration)
        
        super.init()
        
        self.session = URLSession(configuration: urlSessionConfiguration,
                                  delegate: self,
                                  delegateQueue: OperationQueue.main)
    }
    
    func resumeDataTask(forRequest request: URLRequest) -> Observable<Response> {
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: request)
            self.taskCompletions.append(TaskCompletion(taskId: task.taskIdentifier,
                                                       observer: observer,
                                                       responseData: Data()))
            
            task.resume()
            return Disposables.create {
                if task.state != .completed {
                    task.cancel()
                }
            }
        }
    }
    
    func invalidateSession() {
        session.invalidateAndCancel()
    }
}

// MARK: - URLSession Delegate
extension SessionManager: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let index = self.taskCompletions.index(where: { $0.taskId == dataTask.taskIdentifier }) {
            self.taskCompletions[index].responseData.append(data)
        }
    }
    
    public func urlSession(_ session: URLSession,
                           dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(URLSession.ResponseDisposition.allow)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        guard let taskCompletion = self.taskCompletions.first(where: { $0.taskId == task.taskIdentifier }) else {
            return
        }
        guard let error = error as NSError? else {
            
            if let dataTask = task as? URLSessionDataTask,
                let urlResponse = dataTask.response as? HTTPURLResponse {
                
                let response = Response(data: taskCompletion.responseData, urlResponse: urlResponse)
                taskCompletion.observer.on(.next(response))
            }
            taskCompletion.observer.on(.completed)
            
            if let index = self.taskCompletions.index(of: taskCompletion) {
                self.taskCompletions.remove(at: index)
            }
            
            return
        }
        
        taskCompletion.observer.on(.error(error))
        if let index = self.taskCompletions.index(of: taskCompletion) {
            self.taskCompletions.remove(at: index)
        }
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        guard let taskCompletion = self.taskCompletions.first(where: { $0.taskId == task.taskIdentifier }) else {
            return
        }
        taskCompletion.observer.on(.error(RequestErrors.waitingForConnectivity))
    }
}

