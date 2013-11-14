//
//  PlayerViewController.m
//  RendererLister
//
//  Created by Proteas on 13-11-5.
//  Copyright (c) 2013年 Proteas. All rights reserved.
//

#import "PlayerViewController.h"
#import <CyberLink/UPnPAV.h>

static NSString * const kVideoURLStr =
@"http://119.188.71.28/vlive.qqvideo.tc.qq.com/c0013t5lpwn.mp4?vkey=AB28806443FEFD1FC88D97195E10E907BAE0F22420944D29F687D71D81ACA73799A76DF80F1C7041&br=66&platform=10103&fmt=mp4&level=3&sdtfrom=v4000&locid=257add52-9916-4245-9173-6db0d4ecd480&size=150494262&ocid=136454060";

@interface PlayerViewController () <CGUpnpDeviceDelegate>

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(startPlay) withObject:nil afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startPlay
{
    if (!self.avRenderer)
        return;
    
    BOOL result = NO;
    self.avRenderer.delegate = self;
    result = [self.avRenderer stop];
    NSLog(@"----------------->stop: %d", result);
    result = [self.avRenderer setAVTransportURI:@"!!! DLNA Supported Video Link !!!"];
    NSLog(@"----------------->setAVTransportURI: %d", result);
    
    result = [self.avRenderer play];
    NSLog(@"----------------->play: %d", result);
    
    result = [self.avRenderer seek:4.262611];
    NSLog(@"----------------->seek: %d", result);
    
    result = [self.avRenderer isPlaying];
    NSLog(@"----------------->isPlaying: %d", result);
}

- (BOOL)device:(CGUpnpDevice *)device service:(CGUpnpService *)service actionReceived:(CGUpnpAction *)action
{
    NSLog(@"action %@", [action description]);
    return YES;
}

@end
