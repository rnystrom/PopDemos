//
//  RWTAutoLayoutController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 6/30/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTAutoLayoutController.h"
#import <POP.h>

@interface RWTAutoLayoutController ()

@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerHeightConstraint;

@end

@implementation RWTAutoLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.container.layer.borderColor = [UIColor blackColor].CGColor;
    self.container.layer.borderWidth = 1;
}

- (IBAction)onResize:(id)sender {
    // random width between 150 max 450
    CGFloat rWidth = arc4random() % 300 + 150;
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.springBounciness = 20;
    spring.springSpeed = 20;
    
    POPAnimatableProperty *property = [POPAnimatableProperty propertyWithName:@"com.rwt.heightContstraint" initializer:^(POPMutableAnimatableProperty *prop) {
        // note the object used is NSLayoutConstraint, the same object we assign the animation to
        prop.readBlock = ^(NSLayoutConstraint *constraint, CGFloat values[]) {
            values[0] = constraint.constant;
        };
        
        prop.writeBlock = ^(NSLayoutConstraint *constraint, const CGFloat values[]) {
            constraint.constant = values[0];
        };
        
        // this helps Pop determine when the animation is over
        prop.threshold = 0.01;
    }];
    
    spring.property = property;
    spring.toValue = @(rWidth);
    
    [self.containerHeightConstraint pop_addAnimation:spring forKey:@"spring"];
}

@end
