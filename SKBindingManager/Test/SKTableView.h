//
//  SKTableView.h
//  SKBindingManager
//
//  Created by Slavko Krucaj on 26.9.2012..
//  Copyright (c) 2012. slavko.krucaj@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKBindingManager.h"

@interface SKTableView : UITableView <UITableViewDelegate, UITableViewDataSource, SKBindingProtocol>

- (void)initialize;

@end