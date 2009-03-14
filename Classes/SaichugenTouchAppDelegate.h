//
//  SaichugenTouchAppDelegate.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 11/30/08.
//  Copyright YUHA 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameViewController;
@class SaichugenTouchViewController;
@class SaichugenScore;

@interface SaichugenTouchAppDelegate : NSObject <UIApplicationDelegate> {
    IBOutlet UIWindow* window;
    IBOutlet SaichugenTouchViewController* viewController;
	IBOutlet GameViewController* gameViewController;
	
	SaichugenScore* score;
}

@property (nonatomic, retain) IBOutlet UIWindow* window;
@property (nonatomic, retain) IBOutlet SaichugenTouchViewController* viewController;
@property (nonatomic, retain) IBOutlet GameViewController* gameViewController;
@property (nonatomic, readonly, assign) SaichugenScore* score;

// ----------------------------------------------------------------------

- (void)loadScoreFromFile;
- (void)saveScoreToFile;
@end




