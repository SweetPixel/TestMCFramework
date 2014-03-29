//
//  TestMCViewController.h
//  TestMCFramework
//
//  Created by Usman Khan on 29/03/2014.
//  Copyright (c) 2014 SweetPixel Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "TestMCManager.h"

@interface TestMCViewController : UIViewController <UIActionSheetDelegate>

//@property (strong, nonatomic) MCBrowserViewController *browserViewController;
//@property (strong, nonatomic) NSMutableArray *peers;
@property (strong, nonatomic) TestMCManager *manager;
@property (strong, nonatomic) IBOutlet UIButton *startBrowsing;
@property (strong, nonatomic) IBOutlet UILabel *sentLabel;
@property (strong, nonatomic) IBOutlet UILabel *receivedLabel;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;
- (IBAction)sendMessage;
- (IBAction)presentBrowser;
- (void)dismissBrowser;

@end
