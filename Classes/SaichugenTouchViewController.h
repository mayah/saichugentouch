//
//  SaichugenTouchViewController.h
//  SaichugenTouch
//
//  Created by Kawanaka Shinya on 11/30/08.
//  Copyright YUHA 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewTransition.h"
#import "GameView.h"

@class SaichugenScore;

@interface SaichugenTouchViewController : UIViewController {
	// ViewTransition Object for animation in changing views.
	ViewTransition* viewTransition;
	
	// Views
	IBOutlet UIView* startView;
	IBOutlet UIView* scoreView;
	IBOutlet UIView* aboutView;
	IBOutlet UIView* gameRuleView;
	IBOutlet GameView* gameView;
	
	// Subviews -- GameRuleView
	IBOutlet UIWebView* gameRuleWebView;
	// SubViews -- ScoreView
	IBOutlet UITableView* scoreTableView;
	IBOutlet UIView* scoreFooterView;
}

@property (nonatomic, retain) IBOutlet UIView* startView;
@property (nonatomic, retain) IBOutlet UIView* scoreView;
@property (nonatomic, retain) IBOutlet UIView* aboutView;
@property (nonatomic, retain) IBOutlet UIView* gameRuleView;
@property (nonatomic, retain) IBOutlet GameView* gameView;
@property (nonatomic, retain) IBOutlet UIView* scoreFooterView;


// ----------------------------------------------------------------------
// Start View
- (IBAction) pressedStartButton:(id)sender;
- (IBAction) pressedGameRuleButton:(id)sender;
- (IBAction) pressedScoreButton:(id)sender;
- (IBAction) pressedAboutButton:(id)sender;

// Game View
- (IBAction) onGameHOMEButtonPressed:(id)sender;

// Rule View
- (IBAction) onGameRuleOKButtonPressed:(id)sender;

// Score View
- (IBAction) onScoreOKButtonPressed:(id)sender;
- (IBAction) pressedScoreResetButton:(id)sender;

// About View
- (IBAction) onAboutOKButtonPressed:(id)sender;

@end

