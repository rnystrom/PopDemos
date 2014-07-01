//
//  RWTUIKitController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 6/30/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTUIKitController.h"
#import <POP.h>

@interface RWTUIKitController ()

@property (weak, nonatomic) IBOutlet UIButton *uikit;
@property (weak, nonatomic) IBOutlet UIButton *pop;

@end

@implementation RWTUIKitController

CGFloat const UIKitDistanceFromEdge = 100;

- (void)toggleView:(UIView *)view withPop:(BOOL)usePop {
    CGRect frame = view.frame;
    
    // determine if the view should animate up or down
    BOOL goDown = frame.origin.y == UIKitDistanceFromEdge;
    
    if (goDown) {
        frame.origin.y = self.view.bounds.size.height - UIKitDistanceFromEdge - frame.size.height;
    }
    else {
        frame.origin.y = UIKitDistanceFromEdge;
    }
    
    if (usePop) {
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        spring.toValue = [NSValue valueWithCGRect:frame];
        spring.springBounciness = 15;
        spring.springSpeed = 20;
        
        [view pop_addAnimation:spring forKey:@"spring"];
    }
    else {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.5
              initialSpringVelocity:0.5
                            options:kNilOptions
                         animations:^{
                             view.frame = frame;
                         }
                         completion:nil];
    }
}

- (IBAction)onUIKit:(id)sender {
    [self toggleView:sender withPop:NO];
}

- (IBAction)onPop:(id)sender {
    [self toggleView:sender withPop:YES];
}


@end
