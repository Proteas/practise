//
//  wax_garbage_collection.h
//  WaxTests
//
//  Created by Corey Johnson on 2/23/10.
//  Copyright 2010 Probably Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

struct lua_State;

@interface wax_gc : NSObject {

}

+ (void)start;
+ (void)stop;
+ (void)cleanupUnusedObject;

@end


// part 2
@interface fm_gc : NSObject {
    
    NSMutableArray *_lvStates;
    NSTimer *_timer;
}

+ (fm_gc *)currentGC;

// Don not start some state for multi times
- (void)start:(struct lua_State *)lvState;
- (void)stop:(struct lua_State *)lvState;

@end
