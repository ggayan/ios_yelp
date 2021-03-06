//
//  YelpFilters.h
//  Yelp
//
//  Created by Gabriel Gayan on 15/31/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YelpClient.h"

@interface YelpQuery : NSObject

@property (nonatomic) NSString *searchTerm;
@property (nonatomic) NSString *defaultSearchTerm;
@property (nonatomic) BOOL offeringDeal;
@property (nonatomic) NSInteger distance;
@property (nonatomic) YelpSortMode sortMode;
@property (nonatomic) NSMutableSet *selectedCategories;

- (void)executeWithCompletion:(void (^)(NSArray *businesses, NSError *error))completion;

@end
