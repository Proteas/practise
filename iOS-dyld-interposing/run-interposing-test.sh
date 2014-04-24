#!/bin/bash

DYLD_INSERT_LIBRARIES=interposing-lib.dylib ./interposing-main
