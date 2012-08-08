//
//  wax_garbage_collection.m
//  WaxTests
//
//  Created by Corey Johnson on 2/23/10.
//  Copyright 2010 Probably Interactive. All rights reserved.
//

#import "wax_gc.h"

#import "lua.h"
#import "lauxlib.h"

#import "wax.h"
#import "wax_instance.h"
#import "wax_helpers.h"

#define WAX_GC_TIMEOUT 1

@implementation wax_gc

static NSTimer* timer = nil;

+ (void)start {
    [timer invalidate];
    timer = [NSTimer scheduledTimerWithTimeInterval:WAX_GC_TIMEOUT target:self selector:@selector(cleanupUnusedObject) userInfo:nil repeats:YES];
}

+ (void)stop {
    [timer invalidate];
    timer = nil;
}

+ (void)cleanupUnusedObject {   
    lua_State *L = wax_currentLuaState();
    BEGIN_STACK_MODIFY(L)
    
    wax_instance_pushStrongUserdataTable(L);

    lua_pushnil(L);  // first key
    while (lua_next(L, -2)) {
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(L, -1, WAX_INSTANCE_METATABLE_NAME);
        lua_pop(L, 1); // pops the value, keeps the key
            
        if (!instanceUserdata->isClass && !instanceUserdata->isSuper && [instanceUserdata->instance retainCount] <= 1) {
            lua_pushvalue(L, -1);
            lua_pushnil(L);
            lua_rawset(L, -4); // Clear it!
        }        
    }

        
    END_STACK_MODIFY(L, 0);
}

@end


// part 1
@interface fm_gc ()

@property (nonatomic, retain) NSMutableArray *lvStates;
@property (nonatomic, retain) NSTimer *timer;

- (void)cleanupUnusedObject:(struct lua_State *)lvState;
- (void)cleanupUnusedObjects;

@end


// part 2
@implementation fm_gc

@synthesize lvStates = _lvStates;
@synthesize timer = _timer;


+ (fm_gc *)currentGC {
    
    static fm_gc *gc = nil;
    if (nil == gc) {
        gc = [[fm_gc alloc] init];
    }
    
    return gc;
}


- (id)init {
    
    if ((self = [super init])) {
        _lvStates = [[NSMutableArray alloc] init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:WAX_GC_TIMEOUT 
                                                  target:self 
                                                selector:@selector(cleanupUnusedObjects) 
                                                userInfo:nil 
                                                 repeats:YES];
    }
    
    return self;
}


- (void)dealloc {
    
    [self.timer invalidate];
    self.timer = nil;
    [self cleanupUnusedObjects];
    self.lvStates = nil;
    
    [super dealloc];
}


- (void)start:(struct lua_State *)lvState {
    
    [self.lvStates addObject:[NSNumber numberWithLong:(long)lvState]];
}


- (void)stop:(struct lua_State *)lvState {
    
    NSNumber *targetObj = nil;
    for (NSNumber *address in self.lvStates) {
        if ([address longValue] == (long)lvState) {
            targetObj = address;
            break;
        }
    }
    
    if (targetObj)
        [self.lvStates removeObject:targetObj];
}


- (void)cleanupUnusedObjects {
    
    for (NSNumber *address in self.lvStates) {
        lua_State *L = (lua_State *)[address longValue];
        [self cleanupUnusedObject:L];
    }
}


- (void)cleanupUnusedObject:(struct lua_State *)lvState {
    
    BEGIN_STACK_MODIFY(lvState)
    
    wax_instance_pushStrongUserdataTable(lvState);
    
    lua_pushnil(lvState);  // first key
    while (lua_next(lvState, -2)) {
        wax_instance_userdata *instanceUserdata = (wax_instance_userdata *)luaL_checkudata(lvState, -1, WAX_INSTANCE_METATABLE_NAME);
        lua_pop(lvState, 1); // pops the value, keeps the key
        
        if (!instanceUserdata->isClass && !instanceUserdata->isSuper && [instanceUserdata->instance retainCount] <= 1) {
            //NSLog(@"Lua Script Engine Released Object: %x", (unsigned)instanceUserdata->instance);
            lua_pushvalue(lvState, -1);
            lua_pushnil(lvState);
            lua_rawset(lvState, -4); // Clear it!
        }        
    }
    
    
    END_STACK_MODIFY(lvState, 0);
}

@end
