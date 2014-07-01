//
//  RWTRACController.m
//  PopDemos
//
//  Created by Ryan Nystrom on 6/30/14.
//  Copyright (c) 2014 Ryan Nystrom. All rights reserved.
//

#import "RWTRACController.h"
#import <POP.h>
#import <ReactiveCocoa.h>

@interface RWTRACController ()

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextView *logs;

@end

@implementation RWTRACController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logs.text = @"";
    
    // prepend text to our log view whenever the frame changes
    [[RACObserve(self.button, frame) deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSValue *frameValue) {
        CGRect frame = frameValue.CGRectValue;
        NSString *text = [NSString stringWithFormat:@"x: %.2f, y: %.2f",frame.origin.x,frame.origin.y];
        text = [text stringByAppendingFormat:@"\n%@",self.logs.text];
        self.logs.text = text;
    }];
}

- (void)animateRandomFrameForView:(UIView *)view {
    CGRect viewFrame = self.view.bounds;
    // random position
    // don't change frame and position at the same time, Pop doesn't like that
    CGRect frame = CGRectMake(arc4random() % (int)viewFrame.size.width,
                              arc4random() % (int)viewFrame.size.height,
                              100,
                              100);
    
    POPSpringAnimation *spring = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    spring.fromValue = [NSValue valueWithCGRect:view.frame];
    spring.toValue = [NSValue valueWithCGRect:frame];
    spring.springBounciness = 15;
    spring.springSpeed = 20;
    
    [self.button pop_addAnimation:spring forKey:@"spring"];
}

- (IBAction)onButton:(id)sender {
    [self animateRandomFrameForView:sender];
}

@end
