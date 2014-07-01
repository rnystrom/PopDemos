//
//  RWTInteractionController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 6/30/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTInteractionController.h"
#import <POP.h>

@interface RWTInteractionController ()

@property (weak, nonatomic) IBOutlet UIImageView *facebook;

@end

@implementation RWTInteractionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    self.facebook.userInteractionEnabled = YES;
    [self.facebook addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self.facebook pop_removeAllAnimations];
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [pan locationInView:self.view];
        self.facebook.center = point;
    }
    else {
        CGRect bounds = self.view.bounds;
        // middle of the view controller
        CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        
        POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        spring.toValue = [NSValue valueWithCGPoint:center];
        spring.springBounciness = 20;
        spring.springSpeed = 20;
        
        [self.facebook pop_addAnimation:spring forKey:@"spring"];
    }
}

@end
