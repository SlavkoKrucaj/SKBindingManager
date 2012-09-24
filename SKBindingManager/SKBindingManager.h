//
//  SKBindingManager.h
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBindingOptionFromObject        @"fromObject"
#define kBindingOptionToObject          @"toObject"
#define kBindingOptionFromKeyPath       @"fromKeyPath"
#define kBindingOptionToKeyPath         @"toKeyPath"
#define kBindingOptionBindId            @"bindId"
#define kBindingOptionTwoWayBinding     @"twoWay"
#define kBindingForwardTransformation   @"forwardTransformation"
#define kBindingBackwardTransformation  @"backwardTransformation"

#define kBindingLabelObservableProperty        @"text"
#define kBidningTextFieldObservableProperty    @"text"
#define kBindingTextViewObservableProperty     @"text"
#define kBindingSwitchObservableProperty       @"on"
#define kBindingStepperObservableProperty      @"value"
#define kBindingSliderObservableProperty       @"value"

typedef id (^SKTransformationBlock)(id value);

@interface SKBindingManager : NSObject <UITextViewDelegate>

- (BOOL)bind:(NSDictionary *)bindingOptions;
- (BOOL)unbind:(NSDictionary *)bindingOptions;
- (void)removeAllBindings;

@end
