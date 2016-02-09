//
//  ViewController.m
//  LinkedInLogin
//
//  Created by TheAppGuruz-iOS-103 on 02/02/16.
//  Copyright © 2016 TheAppGuruz. All rights reserved.
//

#import "ViewController.h"
#import <linkedin-sdk/LISDK.h>
#import <Foundation/Foundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginTapped:(id)sender
{
    NSArray *permissions = [NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil];
    
    [LISDKSessionManager createSessionWithAuth:permissions state:nil showGoToAppStoreDialog:YES successBlock:^(NSString *returnState){
        NSLog(@"%s","success called!");
        LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
        NSLog(@"Session  : %@", session.description);
        
        [[LISDKAPIHelper sharedInstance] getRequest:@"https://api.linkedin.com/v1/people/~"
                                            success:^(LISDKAPIResponse *response) {
                                                
                                                NSData* data = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                                                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                                
                                                NSString *authUsername = [NSString stringWithFormat: @"%@ %@", [dictResponse valueForKey: @"firstName"], [dictResponse valueForKey: @"lastName"]];
                                                NSLog(@"Authenticated user name  : %@", authUsername);
                                                [self.lblAuthenticatedUser setText: authUsername];
                                                
                                            } error:^(LISDKAPIError *apiError) {
                                                NSLog(@"Error  : %@", apiError);
                                            }];
    } errorBlock:^(NSError *error) {
        NSLog(@"Error called  : %@", error);
    }];
}
@end