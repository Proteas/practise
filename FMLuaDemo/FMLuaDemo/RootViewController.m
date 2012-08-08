//
//  RootViewController.m
//  FMLuaDemo
//
//  Created by Wei Wang on 12-7-17.
//  Copyright (c) 2012年 Beijing Founder Electronics Co.,Ltd. All rights reserved.
//

#import "RootViewController.h"
#import "lua.h"
#import "lauxlib.h"

static int SampleCFunction(lua_State *L) {
    
    bool isStr = lua_isstring(L, -1);
    if (!isStr)
        return 1;
    
    const char *msg = lua_tostring(L, -1);
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Call C Function From Lua" 
                                                     message:[NSString stringWithUTF8String:msg]
                                                    delegate:nil 
                                           cancelButtonTitle:@"Cancel" 
                                           otherButtonTitles:nil] autorelease];
    [alert show];
    
    return 0;
}


@interface RootViewController ()

- (void)callLuaNoParam:(id)sender;
- (void)callLuaWithString:(id)sender;
- (void)callLuaWithDict:(id)sender;
- (void)callLuaWithObject:(id)sender;
- (void)callLuaReturnRawString:(id)sender;
- (void)callLuaReturnObjCString:(id)sender;
- (void)callCFunctionFromLua:(id)sender;

@end


@implementation RootViewController


- (id)init {
    
    if ((self = [super init])) {
        wax_start("SampleScript-1.lua", NULL);
        lua_State *L = wax_currentLuaState();
        
        // number
        lua_getglobal(L, "count");
        int count = lua_tonumber(L, -1);
        NSLog(@"Count From Lua: %d", count);
        lua_pop(L, 1);
        
        // string
        lua_getglobal(L, "msg");
        const char *msg = lua_tostring(L, -1);
        NSLog(@"Msg From Lua: %s", msg);
        lua_pop(L, 1);
        
        // objc var
        lua_getglobal(L, "alertView");
        UIAlertView *alertView = fm_instance_getObject(L, -1);
        [alertView show];
        lua_pop(L, 1);
        
        wax_end();
        
        // shared state
        _luaState = fm_start("SampleScript-2.lua", NULL);
        lua_pushcfunction(_luaState, SampleCFunction);
        lua_setglobal(_luaState, "showMsg");
    }
    
    return self;
}


- (void)dealloc {
    
    fm_end(_luaState); 
    _luaState = NULL;
    
    [super dealloc];
}


- (void)loadView {
    
    [super loadView];
    
    UIButton *btn = nil;
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua No Param" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua No Param" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 20.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaNoParam:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    // 
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua With String" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua With String" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 100.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaWithString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua With Dict" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua With Dict" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 180.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaWithDict:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua With Object" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua With Object" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 260.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaWithObject:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua Return Raw String" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua Return Raw String" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 340.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaReturnRawString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call Lua Return ObjC String" forState:UIControlStateNormal];
    [btn setTitle:@"Call Lua Return ObjC String" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 420.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callLuaReturnObjCString:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //
    btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn setTitle:@"Call C Function From Lua" forState:UIControlStateNormal];
    [btn setTitle:@"Call C Function From Lua" forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(20.0f, 500.0f, 230.0f, 60.0f);
    [btn addTarget:self action:@selector(callCFunctionFromLua:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    //
}


- (void)callLuaNoParam:(id)sender {
    
    //wax_printStack(_luaState);
    lua_getglobal(_luaState, "SayHello");
    //wax_printStack(_luaState);
    wax_pcall(_luaState, 0, 0);
    //wax_printStack(_luaState);
    lua_pop(_luaState, 1);
    //wax_printStack(_luaState);
}


- (void)callLuaWithString:(id)sender {
    
    lua_getglobal(_luaState, "SayHello2");
    lua_pushstring(_luaState, "msg from objc");
    wax_pcall(_luaState, 1, 0);
    lua_pop(_luaState, 1);
}


- (void)callLuaWithDict:(id)sender {
    
    lua_getglobal(_luaState, "SayHello3");
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"hello lua from objc", @"msg", nil];
    wax_fromInstance(_luaState, dict);
    wax_pcall(_luaState, 1, 0);
    lua_pop(_luaState, 1);
}


- (void)sayHello:(NSString *)msg {
    
    UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Message" 
                                                         message:msg 
                                                        delegate:nil 
                                               cancelButtonTitle:@"Cancel" 
                                               otherButtonTitles:nil] autorelease];
    [alertView show];
}


- (void)callLuaWithObject:(id)sender {
    
    lua_getglobal(_luaState, "SayHello4");
    wax_fromInstance(_luaState, self);
    wax_pcall(_luaState, 1, 0);
    lua_pop(_luaState, 1);
}


- (void)callLuaReturnRawString:(id)sender {
    
    lua_getglobal(_luaState, "SayHello5");
    wax_pcall(_luaState, 0, 1);
    const char *msg = lua_tostring(_luaState, -1);
    [self sayHello:[NSString stringWithUTF8String:msg]];
    lua_pop(_luaState, 1);
}


- (void)callLuaReturnObjCString:(id)sender {
    
    lua_getglobal(_luaState, "SayHello6");
    wax_pcall(_luaState, 0, 1);
    NSString *msg = (NSString *)fm_instance_getObject(_luaState, -1);
    [self sayHello:msg];
    lua_pop(_luaState, 1);
}


- (void)callCFunctionFromLua:(id)sender {
    
    lua_getglobal(_luaState, "SayHello7");
    wax_pcall(_luaState, 0, 0);
    lua_pop(_luaState, 1);
}

@end
