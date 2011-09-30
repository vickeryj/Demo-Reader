//
//  SyncAsyncRunner.h
//  
//  A class to assist with testing Asynchronous operations.
// 
//  Instances of this class act as a drop in replacement for any asynchronous delegate
//  through dynamic proxying.
//
//  the "waitForResponseFromTarget..." methods block until this object receives some sort of callback.
//
//  Created by Joshua Vickery on 4/2/10.
//  Copyright 2010 Joshua Vickery. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SyncAsyncRunner : NSObject {

	BOOL callbackReceived;
	id callbackDelegate;
	NSInteger timeout;
	
}

//The dynamic proxy target. This is optional, but necessary if you actually
//want to receive the callbacks that this object is proxying.
@property(nonatomic, assign) id callbackDelegate;

//How long to wait in seconds for a callback before declaring the 
//operation to be timed out. Defaults to 20.
@property(nonatomic, assign) NSInteger timeout;

- (BOOL)waitForResponseFromTarget:(id)messageTarget toMessage:(SEL)message;
- (BOOL)waitForResponseFromTarget:(id)messageTarget toMessage:(SEL)message withObjects:(id)firstArg,...;


@end
