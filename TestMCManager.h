//
//  TestMCManager.h
//  TestMCFramework
//
//  Created by Usman Khan on 29/03/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
@class TestMCViewController;

@interface TestMCManager : NSObject <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate,MCSessionDelegate, MCBrowserViewControllerDelegate>

@property (strong, nonatomic) MCPeerID *localPeerID;
@property (strong, nonatomic) NSString *serviceName;
@property (strong, nonatomic) MCNearbyServiceAdvertiser *advertiser;
@property (strong, nonatomic) MCNearbyServiceBrowser *browser;
@property (strong, nonatomic) MCSession *session;
@property (strong, nonatomic) MCBrowserViewController *browserViewController;
@property (strong, nonatomic) NSMutableArray *peers;
@property (nonatomic) TestMCViewController *mcparentController;

- (id)initWithID:(NSString *)uid andServiceName:(NSString *)servName;
- (void)presentBrowser;
- (void)sendSomeMessageDataTo:(MCPeerID *)peerID;

@end
