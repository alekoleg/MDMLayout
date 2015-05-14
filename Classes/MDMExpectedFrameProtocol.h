//
//  MDMExpectedFrameProtocol.h
//  MDM
//
//  Created by Alekseenko Oleg on 02.06.14.
//  Copyright (c) 2014 Hyperboloid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MDMExpectedFrameProtocol <NSObject>
@optional

- (void)mdm_updateLayoutAnimated:(BOOL)animated;

@end
