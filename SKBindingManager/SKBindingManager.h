//
//  SKBindingManager.h
//  BindableTableViewProject
//
//  Created by Slavko Krucaj on 21.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBindingOptionFromObject    @"fromObject"
#define kBindingOptionToObject      @"toObject"
#define kBindingOptionFromKeyPath   @"fromKeyPath"
#define kBindingOptionToKeyPath     @"toKeyPath"
#define kBindingOptionBindId        @"bindId"
#define kBindingOptionTwoWayBinding @"twoWay"

#define kLabelObservableProperty        @"text"
#define kTextFieldObservableProperty    @"text"
#define kTextViewObservableProperty     @"text"


@interface SKBindingManager : NSObject <UITextViewDelegate>

- (BOOL)bind:(NSDictionary *)bindingOptions;
- (BOOL)unbind:(NSDictionary *)bindingOptions;
- (void)removeAllBindings;

@end
