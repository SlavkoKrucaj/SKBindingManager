//
//  SKTextView.h
//  SKBindingManager
//
//  Created by Slavko Krucaj on 29.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKBindingManager.h"

@interface SKTextView : UITextView <SKBindingProtocol, UITextViewDelegate>

- (void)initialize;
@end
