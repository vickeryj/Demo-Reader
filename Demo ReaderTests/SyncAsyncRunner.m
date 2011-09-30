//
//  SyncAsyncRunner.m
//  
//
//  Created by Joshua Vickery on 4/2/10.
//  Copyright 2010 Joshua Vickery. All rights reserved.
//

#import "SyncAsyncRunner.h"


@implementation SyncAsyncRunner

@synthesize callbackDelegate, timeout;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.timeout = 20;
	}
	return self;
}


- (BOOL) waitForCallback {
	int secondsEllapsed = 0;
	NSRunLoop *rl = [NSRunLoop currentRunLoop];
	while (secondsEllapsed < timeout && !callbackReceived) 
	{
		//wait for a callback to happen while spinning the run loop by hand
		[rl runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
		secondsEllapsed++;
	}
	return callbackReceived;
}
- (BOOL)waitForResponseFromTarget:(id)messageTarget toMessage:(SEL)message {
    callbackReceived = NO;

	[messageTarget performSelector:message];
	
	return [self waitForCallback];
}

- (BOOL)waitForResponseFromTarget:(id)messageTarget toMessage:(SEL)message withObjects:(id)firstArg,... {
	
	//create an NSInvocation for the message we are trying to 
	NSMethodSignature *methodSignature = [messageTarget methodSignatureForSelector:message];
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
	[invocation setTarget:messageTarget];
	[invocation setSelector:message];
	
	int numArguments = [methodSignature numberOfArguments];
	if (numArguments > 2) {
		[invocation setArgument:&firstArg atIndex:2]; //we start at idx 2 to account for the hidden "self" and "cmd" args
		if (numArguments > 3) {
			va_list arglist;
			va_start(arglist, firstArg);
			for (int i = 3 ; i < numArguments; i++) {//start at 3
				id arg = va_arg(arglist,id);
				[invocation setArgument:&arg atIndex:i];
			}
			va_end(arglist);
		}
		[invocation retainArguments];
	}
	
	[invocation invoke];
	
	return [self waitForCallback];
	
}


//handle all callbacks
-(NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *signature;
	signature = [super methodSignatureForSelector:selector];
	if (nil == signature) {
		signature = [self.callbackDelegate methodSignatureForSelector:selector];
	}
	if (nil == signature) {
		signature = [NSMethodSignature signatureWithObjCTypes:"@^v^c"];
	}
	return signature;
}

- (void) forwardInvocation:(NSInvocation *)anInvocation {
	callbackReceived = YES;
	if (nil != self.callbackDelegate) {
		[anInvocation setTarget:self.callbackDelegate];
		[anInvocation invoke];
	}
}

#pragma mark cleanup
- (void) dealloc
{
	[super dealloc];
}


@end
