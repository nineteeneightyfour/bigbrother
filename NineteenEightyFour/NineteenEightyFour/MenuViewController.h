//
//  MenuViewController.h
//  NineteenEightyFour
//
//  Created by Stéphane Hanser on 24/04/11.
//  Copyright 2011 Jonathan Perret. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MenuViewController : UIViewController {
}
- (IBAction)startGame;

@property (nonatomic, retain)	AVAudioPlayer			*appSoundPlayer;

- (void)playSound:(NSString*)path ofType:(NSString*)type;


@end
