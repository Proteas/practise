//  Created by ProbablyInteractive.
//  Copyright 2009 Probably Interactive. All rights reserved.

#import <Foundation/Foundation.h>
#import "lua.h"

#define WAX_VERSION 0.93

void wax_setup();
void wax_start(char *initScript, lua_CFunction extensionFunctions, ...);
void wax_startWithServer();
void wax_end();

lua_State *wax_currentLuaState();

void luaopen_wax(lua_State *L);

// added by proteas
lua_State *fm_start(char *initScript, lua_CFunction extensionFunctions, ...);
void fm_end(lua_State *L);

void fm_addPathToLuaPath(lua_State *L, char const *path);
