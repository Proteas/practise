//
//  RootViewController.h
//  FMLuaDemo
//
//  Created by Wei Wang on 12-7-17.
//  Copyright (c) 2012年 Beijing Founder Electronics Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wax.h"
#import "wax_helpers.h"


@interface RootViewController : UIViewController {
    
    lua_State *_luaState;
}

@end
