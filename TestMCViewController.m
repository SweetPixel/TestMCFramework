//
//  TestMCViewController.m
//  TestMCFramework
//
//  Created by Usman Khan on 29/03/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import "TestMCViewController.h"

@interface TestMCViewController ()

@end

@implementation TestMCViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        //_peers = [[NSMutableArray alloc] init];
        _manager = [[TestMCManager alloc] initWithID:[[UIDevice currentDevice] name]  andServiceName:@"locatamator-app"];
        _manager.mcparentController = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom Methods

- (IBAction)presentBrowser;
{
    [_manager presentBrowser];
    [self presentViewController:_manager.browserViewController
                       animated:YES
                     completion:^{
                         //[_manager.browser startBrowsingForPeers];
                     }];
    /*
    _browserViewController = [[MCBrowserViewController alloc] initWithBrowser:_manager.browser
                                                                      session:_manager.session];
    _browserViewController.delegate = self;
    _browserViewController.delegate = _manager;
    //[_manager presentBrowser];
    [self presentViewController:_browserViewController
                       animated:YES
                     completion:^{
                         //[_manager.browser startBrowsingForPeers];
                     }];
     */
}

- (void)dismissBrowser
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sendMessage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Send To" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles: nil];
    
    for (int i = 0; i < [_manager.peers count]; i++)
    {
        MCPeerID *peerID = [_manager.peers objectAtIndex:i];
        [actionSheet addButtonWithTitle:peerID.displayName];
    }
    
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [_manager.peers count])
    {
        // Do Nothing // Its cancel button
    }
    else
    {
        MCPeerID *peerID = [_manager.peers objectAtIndex:buttonIndex];
        
        if (peerID == nil)
        {
            NSLog(@"Some error occured.");
        }
        [_manager sendSomeMessageDataTo:peerID];
    }
}

/*
#pragma mark - MCBrowserViewControllerDelegate Methods

- (BOOL)browserViewController:(MCBrowserViewController *)browserViewController shouldPresentNearbyPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    [_peers addObject:peerID];
    return YES;
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

@end
