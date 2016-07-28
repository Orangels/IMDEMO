//
//  Reachability.h
//  CheckNetworkDemo
//
//  Created by Elean on 15/12/11.
//  Copyright © 2015年 Elean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

extern NSString *const kReachabilityChangedNotification;

typedef enum
{
    // 当前网络的状态.
    NotReachable     = 0,//无网络
    ReachableViaWiFi = 2,//WIFI可用
    ReachableViaWWAN = 1//流量网络可用
} NetworkStatus;

@class Reachability;

typedef void (^NetworkReachable)(Reachability * reachability);
//有网络的block

typedef void (^NetworkUnreachable)(Reachability * reachability);
//无网络的block


@interface Reachability : NSObject

@property (nonatomic, copy) NetworkReachable    reachableBlock;
@property (nonatomic, copy) NetworkUnreachable  unreachableBlock;

@property (nonatomic, assign) SCNetworkReachabilityRef  reachabilityRef;

@property (nonatomic, assign) dispatch_queue_t          reachabilitySerialQueue;

@property (nonatomic, assign) BOOL reachableOnWWAN;

@property (nonatomic, strong) id reachabilityObject;

+ (Reachability *)reachabilityWithHostname:(NSString *)hostname;

+ (Reachability *)reachabilityForInternetConnection;

+ (Reachability *)reachabilityWithAddress:(const struct sockaddr_in *)hostAddress;

+ (Reachability *)reachabilityForLocalWiFi;

- (Reachability *)initWithReachabilityRef:(SCNetworkReachabilityRef)ref;

//用于循环检测当前是否有网络
- (BOOL)startNotifier;
- (void)stopNotifier;

- (BOOL)isReachable;
- (BOOL)isReachableViaWWAN;
- (BOOL)isReachableViaWiFi;

// WWAN 是可用的，但是不主动连接，知道连接已经被建立.

// WiFi 可能需要连接VPN.
- (BOOL)isConnectionRequired;
// Identical DDG variant.
- (BOOL)connectionRequired;
// Apple's routine.
// Dynamic, on demand connection?
- (BOOL)isConnectionOnDemand;
// Is user intervention required?
- (BOOL)isInterventionRequired;

- (NetworkStatus)currentReachabilityStatus;
- (SCNetworkReachabilityFlags)reachabilityFlags;
- (NSString *)currentReachabilityString;
- (NSString *)currentReachabilityFlags;

@end
