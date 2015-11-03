//
//  FilterViewController.m
//  Yelp
//
//  Created by Gabriel Gayan on 15/31/10.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "SwitchCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *distances;
@property (nonatomic) NSArray *sortModes;
@property (nonatomic) NSArray *categories;

- (void)initCategories;

@end

@implementation FiltersViewController
- (id)initWithQuery:(YelpQuery *)query {
    self = [super initWithNibName:@"FiltersViewController" bundle:nil];

    if(self) {
        [self initDistances];
        [self initSortModes];
        [self initCategories];

        if (query) {
            self.query = query;
        } else {
            self.query = [YelpQuery new];
        }
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    self.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onCancelButton)
     ];
    self.navigationItem.rightBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(onApplyButton)
     ];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil]
         forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerClass:UITableViewCell.self forCellReuseIdentifier:@"NormalCell"];
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Switch cell delegate methods

- (void)switchCell:(SwitchCell *)cell didUpdateValue:(BOOL)value {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    switch (indexPath.section) {
        case 0:
            self.query.offeringDeal = value;
            break;
        case 3:
            if(value)
                [self.query.selectedCategories addObject:self.categories[indexPath.row]];
            else
                [self.query.selectedCategories removeObject:self.categories[indexPath.row]];
        default:
            break;
    }
}


#pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return 1.0f;

    return 32.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return [UIView new];

    return nil;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return nil;
        case 1:
            return @"Distance";
        case 2:
            return @"Sort By";
        case 3:
            return @"Category";
        default:
            return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.distances.count;
        case 2:
            return self.sortModes.count;
        case 3:
            return self.categories.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
            cell.titleLabel.text = @"Offering a Deal";
            cell.on = self.query.offeringDeal;
            cell.delegate = self;
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];

            cell.textLabel.text = self.distances[indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryNone];

            if (self.query.distance == indexPath.row)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];

            cell.textLabel.text = self.sortModes[indexPath.row];
            [cell setAccessoryType:UITableViewCellAccessoryNone];

            if (self.query.sortMode == indexPath.row)
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

            return cell;
        }
        case 3: {
            SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];

            cell.titleLabel.text = self.categories[indexPath.row][@"name"];
            cell.on = [self.query.selectedCategories containsObject:self.categories[indexPath.row]];
            cell.delegate = self;

            return cell;
        }
        default:
            return [tableView dequeueReusableCellWithIdentifier:@"NormalCell"];;
    }
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    switch (indexPath.section) {
        case 1:
            self.query.distance = indexPath.row;
            [self.tableView reloadData];
            break;
        case 2:
            self.query.sortMode = indexPath.row;
            [self.tableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark - Private methods

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onApplyButton {
    [self.delegate filterViewsController:self didChangeQuery:self.query];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initDistances {
    self.distances = @[
                       @"Auto",
                       @"0.3 Miles",
                       @"1 Mile",
                       @"5 Miles",
                       @"20 Miles"
                       ];
}

- (void)initSortModes {
    self.sortModes = @[@"Best Match", @"Distance", @"Highest Rated"];
}

- (void)initCategories {
    self.categories =
    @[@{@"name": @"Burgers", @"code": @"burgers"},
      @{@"name": @"Chinese", @"code": @"chinese"},
      @{@"name": @"Israeli", @"code": @"israeli"},
      @{@"name": @"Korean", @"code": @"korean"},
      @{@"name": @"Peruvian", @"code": @"peruvian"},
      @{@"name": @"Pita", @"code": @"pita"},
      @{@"name": @"Pizza", @"code": @"pizza"}];
}


@end
