//
//  AppDelegate.m
//  FMLuaDemo
//
//  Created by Wei Wang on 12-7-17.
//  Copyright (c) 2012年 Beijing Founder Electronics Co.,Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"


@interface AppDelegate ()

@property (nonatomic, retain) UIViewController *rootViewController;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController = _rootViewController;


- (void)dealloc {
    
    [_window release];
    self.rootViewController = nil;
    
    [super dealloc];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    _rootViewController = [[RootViewController alloc] init];
    [self.window addSubview:self.rootViewController.view];
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
    //
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    //
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    //
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    //
}

@end
