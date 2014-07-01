//
//  RWTAnimationsController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 7/1/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTAnimationsController.h"
#import <POP.h>

@interface RWTAnimationsController ()

@end

@implementation RWTAnimationsController

CGFloat const AnimationsTopPadding = 100.f;

- (BOOL)animateToTop:(UIView *)view {
    return view.frame.origin.y != AnimationsTopPadding;
}

// determine if the view needs to animate up or down
- (CGRect)nextFrameForView:(UIView *)view {
    BOOL goToTop = [self animateToTop:view];
    CGRect frame = view.frame;
    
    if (! goToTop) {
        frame.origin.y = self.view.bounds.size.height - AnimationsTopPadding - frame.size.height;
    }
    else {
        frame.origin.y = AnimationsTopPadding;
    }
    
    return frame;
}

- (IBAction)onSpring:(id)sender {
    CGRect frame = [self nextFrameForView:sender];
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.toValue = [NSValue valueWithCGRect:frame];
    spring.springBounciness = 15;
    spring.springSpeed = 20;
    
    [sender pop_addAnimation:spring forKey:@"spring"];
}

- (IBAction)onDecay:(id)sender {
    // for demo purposes we aren't interupting the animation
    if (! [sender pop_animationKeys]) {
        BOOL goToTop = [self animateToTop:sender];
        
        POPDecayAnimation *decay = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        // velocity determines the delta of our property
        decay.velocity = @(goToTop?-900:900);
        
        [sender pop_addAnimation:decay forKey:@"decay"];
    }
}

- (IBAction)onBasic:(id)sender {
    CGRect frame = [self nextFrameForView:sender];
    
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    basic.toValue = [NSValue valueWithCGRect:frame];
    
    [sender pop_addAnimation:basic forKey:@"basic"];
}

@end
