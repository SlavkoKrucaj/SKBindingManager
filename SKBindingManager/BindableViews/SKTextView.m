//
//  SKTextView.m
//  SKBindingManager
//
//  Created by Slavko Krucaj on 29.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import "SKTextView.h"

@interface SKTextView()
@property (nonatomic, retain) NSString *observableProperty;
@end

@implementation SKTextView

@synthesize observableProperty;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//    self.delegate = nil;
//    self.text = self.observableProperty;
//    self.delegate = self;
//}

- (void)initialize {
    self.delegate = self;
//    [self addObserver:self forKeyPath:@"observableProperty" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    self.observableProperty = self.text;
}

@end
