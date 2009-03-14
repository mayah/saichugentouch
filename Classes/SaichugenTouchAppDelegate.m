//
//  SaichugenTouchAppDelegate.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 11/30/08.
//  Copyright YUHA 2008. All rights reserved.
//

#import "SaichugenTouchAppDelegate.h"
#import "SaichugenTouchViewController.h"
#import "SaichugenScore.h"

@implementation SaichugenTouchAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize gameViewController;
@synthesize score;


// ----------------------------------------------------------------------
// alloc/dealloc

- (void)dealloc {
	[gameViewController release];
    [viewController release];
	[score release];
    [window release];
    [super dealloc];
}

// ----------------------------------------------------------------------
// event handlers

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after app launch
	NSLog(@"applicationDidFinishLaunching");
	srandom((unsigned) time(NULL));
	
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	// load score from file.
	[self loadScoreFromFile];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	NSLog(@"applicationWillTerminate is called");
	// save score to file.
	[self saveScoreToFile];
}


// ----------------------------------------------------------------------
// score

- (void)loadScoreFromFile {
	assert(!score);
	score = [[SaichugenScore loadFromFile] retain];
}

- (void)saveScoreToFile {
	assert(score);
	[score saveToFile];
}

@end
