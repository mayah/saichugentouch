//
//  ViewTransition.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 12/5/08.
//  Copyright 2008 YUHA. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CAAnimation;

@interface ViewTransition : NSObject {
	BOOL transiting;
	UIView* mainView;
	
	id object;
	SEL selector;
}

- (void)setMainView:(UIView*) view;
- (void)replaceSubView:(UIView*)oldView withNewView:(UIView*)newView fromRight:(BOOL)fromRight;
- (void)replaceSubView:(UIView*)oldView withNewView:(UIView*)newView fromRight:(BOOL)fromRight obj:(id)obj selector:(SEL)sel;

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag;
@end
