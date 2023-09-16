//
//  NetworkHandler.swift
//  PodPod
//
//  Created by Wonil Lee on 2023/09/16.
//

import Network

final class NetworkHandler {
    static let shared = NetworkHandler()
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    // 연결 타입
    enum ConnectionType{
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    // monotior 초기화
    private init(){
        monitor = NWPathMonitor()
    }
    
    // Network Monitoring 시작
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    // Network Monitoring 종료
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    // Network 연결 타입가져오기.
    private func getConnectionType(_ path: NWPath){
        if path.usesInterfaceType(.wifi) {
            if connectionType != .wifi {
                connectionType = .wifi
            }
        } else if path.usesInterfaceType(.cellular){
            if connectionType != .cellular {
                connectionType = .cellular
            }
        } else if path.usesInterfaceType(.wiredEthernet){
            if connectionType != .ethernet {
                connectionType = .ethernet
            }
        } else {
            if connectionType != .unknown {
                connectionType = .unknown
            }
        }
    }
}
