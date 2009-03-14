//
//  ViewTransition.m
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/5/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewTransition.h"

@implementation ViewTransition

- (id)init {
	if ((self = [super init]) == nil) {
		NSLog(@"ViewTransition#init: failed.");
	}

	transiting = NO;
	
	return self;
}

- (void)setMainView:(UIView*)view {
	mainView = view;
}

- (void)replaceSubView:(UIView*)oldView withNewView:(UIView*)newView fromRight:(BOOL)fromRight {
	[self replaceSubView:oldView withNewView:newView fromRight:fromRight obj:nil selector:nil];
}

- (void)replaceSubView:(UIView*)oldView withNewView:(UIView*)newView fromRight:(BOOL)fromRight obj:(id)obj selector:(SEL)sel {
	// If transiting, return immediately.
	if (transiting) { return; }
	transiting = YES;
	object = obj;
	selector = sel;
	
	NSLog(@"replaceSubView is called.");
	
	NSArray* subViews = [mainView subviews];
	NSUInteger index;
	
	if ([oldView superview] == mainView) {
		for (index = 0; [subViews objectAtIndex:index] != oldView; ++index) {}
		[oldView removeFromSuperview];
	}
	
	// If there's a new view and it doesn't already have a superview, insert it where the old view was
	if (newView && ([newView superview] == nil)) {
		[mainView insertSubview:newView	atIndex: index];
	}
	
	// Set up the animation
	CATransition* animation = [CATransition animation];
	animation.delegate = self;
	
	if (fromRight) {
		animation.type = kCATransitionReveal;
		animation.subtype = kCATransitionFromRight;
	} else {
		animation.type = kCATransitionMoveIn;
		animation.subtype = kCATransitionFromLeft;
	}
	[animation setDuration:0.5];
	[animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

	[[mainView layer] addAnimation:animation forKey:@"transitionViewAnimation"];
}

- (void)animationDidStop:(CAAnimation*)theAnimation finished:(BOOL)flag {
	NSLog(@"animationDidStop");
	transiting = NO;
	if (object && selector) {
		[object performSelector:selector];
	}
}
@end
