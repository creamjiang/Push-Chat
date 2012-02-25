//
//  AppDelegate.m
//  PushChat
//
//  Created by Ernesto Carrión on 2/21/12.
//  Copyright (c) 2012 Kogi Mobile. All rights reserved.
//

#import "AppDelegate.h"

#import "LoginViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    LoginViewController * controller;
    if (!IS_IPAD) {
        controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    } else {
        controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController_iPad" bundle:nil];
    }
    
    
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:controller];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    NSString * newToken = deviceToken.description;
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[Model sharedModel] setDeviceToken:newToken];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

@end
