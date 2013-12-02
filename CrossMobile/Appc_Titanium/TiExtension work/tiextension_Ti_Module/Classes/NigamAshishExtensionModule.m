/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "NigamAshishExtensionModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation NigamAshishExtensionModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"0c5d64d8-5bb4-4c3e-b0eb-758a34d8c07f";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"nigam.ashish.extension";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

// working but instance method needs to be created in extension class and then called over UI thread for any ui work
-(void)setMainExtensionClass:(id)args
{
    NSLog(@"[INFO] %@ params",args);
    NSLog(@"[INFO] %@ params",[args class]);
    
    if ([args isKindOfClass:[NSArray class]]) {
        NSLog(@"[INFO] %@ : Expecting Single Params i.e. Extension Class Name",self);
    }else{
        Class mainClass = NSClassFromString(args);
        [mainClass startingPoint:nil];
    }
}

-(void)setMainExtensionClassWithParams:(id)args
{
    NSLog(@"[INFO] %@ params",args);
    NSLog(@"[INFO] %@ params",[args class]);
    
    if ([args isKindOfClass:[NSArray class]]) {
        Class mainClass = NSClassFromString([args objectAtIndex:0]);
        [mainClass startingPoint:args];
    }else{
        Class mainClass = NSClassFromString(args);
        [mainClass startingPoint:args];
    }
}


// working will execute method on non UI thread
-(void)setMainExtensionClassWithInstance:(id)args
{
    NSLog(@"[INFO] %@ params",args);
    NSLog(@"[INFO] %@ params",[args class]);
    
    if ([args isKindOfClass:[NSArray class]]) {
        Class mainClass = NSClassFromString([args objectAtIndex:0]);
        id ins = [[mainClass alloc] init];
        [ins startingPoint:args];
    }else{
        Class mainClass = NSClassFromString(args);
        id ins = [[mainClass alloc] init];
        [ins startingPoint:args];
    }
}

// working will execute method on UI thread
-(void)setMainExtensionClassWithInstanceOnMainThread:(id)args
{
    NSLog(@"[INFO] %@ params",args);
    NSLog(@"[INFO] %@ params",[args class]);
    
    if ([args isKindOfClass:[NSArray class]]) {
        Class mainClass = NSClassFromString([args objectAtIndex:0]);
        id ins = [[mainClass alloc] init];
        [ins performSelectorOnMainThread:@selector(startingPoint:) withObject:args waitUntilDone:NO];
    }else{
        Class mainClass = NSClassFromString(args);
        id ins = [[mainClass alloc] init];
        [ins performSelectorOnMainThread:@selector(startingPoint:) withObject:args waitUntilDone:NO];
    }
}

@end
