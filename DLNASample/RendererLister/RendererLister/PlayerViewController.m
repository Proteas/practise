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
@"http://123.125.86.11/vlive.qqvideo.tc.qq.com/m0013lwk0pl.mp4?vkey=A07DC25BC50127BB71AA1059AD431FDFC3AA80E22BC871AA9CFFFF6E63C130F9F996E9F1A9120975&br=66&platform=10103&fmt=mp4&level=3&sdtfrom=v4000";

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
    result = [self.avRenderer setAVTransportURI:@"http://123.125.86.36/0/vlive.qqvideo.tc.qq.com/c0013t5lpwn.mp4?vkey=29411456E895E2E93185D438E4D7BB15BFAE3E2818BC2EDD7995E92227AD4A0D3F4D0B1D8027926D&br=66&platform=10103&fmt=mp4&level=3&sdtfrom=v4000"];
    NSLog(@"----------------->setAVTransportURI: %d", result);
    
    result = [self.avRenderer play];
    NSLog(@"----------------->play: %d", result);
}

- (BOOL)device:(CGUpnpDevice *)device service:(CGUpnpService *)service actionReceived:(CGUpnpAction *)action
{
    NSLog(@"action %@", [action description]);
    return YES;
}

@end
