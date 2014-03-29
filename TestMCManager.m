//
//  TestMCManager.m
//  TestMCFramework
//
//  Created by Usman Khan on 29/03/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import "TestMCManager.h"
#import "TestMCViewController.h"

@interface TestMCManager ()

- (void)createID:(NSString *)uid;
- (void)createServiceName:(NSString *)name;

@end

@implementation TestMCManager

- (id)initWithID:(NSString *)uid andServiceName:(NSString *)servName
{
    self = [super init];
    if (self)
    {
        // Custom Initialization.
        [self createID:uid];
        [self createServiceName:servName];
        _advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:_localPeerID
                                                        discoveryInfo:nil
                                                          serviceType:_serviceName];
        _advertiser.delegate = self;
        [_advertiser startAdvertisingPeer];
        
        _browser = [[MCNearbyServiceBrowser alloc] initWithPeer:_localPeerID serviceType:_serviceName];
        //_browser.delegate = self;
        
        _session = [[MCSession alloc] initWithPeer:_localPeerID
                                  securityIdentity:nil
                              encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
        
        _peers = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createID:(NSString *)uid
{
    //MCPeerID *localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    _localPeerID = [[MCPeerID alloc] initWithDisplayName:uid];
}

- (void)createServiceName:(NSString *)name
{
    _serviceName = name;
}

- (void)sendSomeMessageDataTo:(MCPeerID *)peerID
{
    NSString *message = [NSString stringWithFormat:@"Hello! From Yours Truly %@.", _localPeerID.displayName];
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    if (![_session sendData:data toPeers:[[NSArray alloc] initWithObjects:peerID, nil]  withMode:MCSessionSendDataReliable error:&error])
    {
        NSLog(@"[Error] %@", error);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mcparentController.sentLabel setText:message];
    });}

- (void)presentBrowser
{
    _browserViewController = [[MCBrowserViewController alloc] initWithBrowser:_browser
                                                                      session:_session];
    _browserViewController.delegate = self;
}

#pragma mark - MCNearbyServiceAdvertiserDelegate Methods

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertise didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, _session);
    
    //[self sendSomeMessageDataTo:peerID];
}

#pragma mark - MCSessionDelegate Methods

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received: %@", message);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_mcparentController.receivedLabel setText:message];
    });
    //[_mcparentController.receivedLabel setText:message];
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    if (state == MCSessionStateConnected)
    {
        NSLog(@"State changed to connected for peer %@.", peerID);
    }
    else if (state == MCSessionStateNotConnected)
    {
        NSLog(@"State changed to not-connected for %@.", peerID);
    }
    else
    {
        NSLog(@"State changed to %d for %@.", state, peerID);
    }
    
    if (![_peers containsObject:peerID]) {
        [_peers addObject:peerID];
    }
    
    /*
    if (state == MCSessionStateConnected)
    {
        NSLog(@"Sending a message.");
        [self sendSomeMessageDataTo:peerID];
    }
     */
}

// Missing Delegate Methods for other stuff - To Do

#pragma mark - MCBrowserViewControllerDelegate Methods

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [_peers addObject:peerID];
    return YES;
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [_mcparentController dismissBrowser];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [_mcparentController dismissBrowser];
}

@end
