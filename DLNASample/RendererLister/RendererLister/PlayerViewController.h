//
//  PlayerViewController.h
//  RendererLister
//
//  Created by Proteas on 13-11-5.
//  Copyright (c) 2013年 Proteas. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CGUpnpAvRenderer;

@interface PlayerViewController : UIViewController

@property (nonatomic, strong) CGUpnpAvRenderer *avRenderer;

@end
