//
//  YelpFilters.m
//  Yelp
//
//  Created by Gabriel Gayan on 15/31/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "YelpBusiness.h"
#import "YelpQuery.h"

@interface YelpQuery ()

@end

@implementation YelpQuery

- (instancetype)init
{
    self = [super init];

    if (self) {
        self.defaultSearchTerm = @"Restaurants";
        self.searchTerm = self.defaultSearchTerm;
        self.selectedCategories = [NSMutableSet set];
    }

    return self;
}

- (void)executeWithCompletion:(void (^)(NSArray *businesses, NSError *error))completion {
    [YelpBusiness searchWithTerm:self.searchTerm
                        sortMode:YelpSortModeBestMatched
                      categories:[self categories]
                           deals:NO
                      completion:completion
     ];
}

#pragma mark - Private instance methods

- (void)setSearchTerm:(NSString *)searchTerm {
    if (searchTerm.length > 0) {
        _searchTerm = searchTerm;
    } else {
        _searchTerm = self.defaultSearchTerm;
    }
}

- (NSArray *)categories {
    NSMutableArray *categories = [NSMutableArray array];

    for (NSDictionary *category in self.selectedCategories) {
        [categories addObject:category[@"code"]];
    }

    return [categories copy];
}

@end
