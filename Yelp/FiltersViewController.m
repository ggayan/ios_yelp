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
    @[@{@"name": @"Afghan", @"code": @"afghani"},
      @{@"name": @"African", @"code": @"african"},
      @{@"name": @"American, New", @"code": @"newamerican"},
      @{@"name": @"American, Traditional", @"code": @"tradamerican"},
      @{@"name": @"Arabian", @"code": @"arabian"},
      @{@"name": @"Argentine", @"code": @"argentine"},
      @{@"name": @"Armenian", @"code": @"armenian"},
      @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
      @{@"name": @"Asturian", @"code": @"asturian"},
      @{@"name": @"Australian", @"code": @"australian"},
      @{@"name": @"Austrian", @"code": @"austrian"},
      @{@"name": @"Baguettes", @"code": @"baguettes"},
      @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
      @{@"name": @"Barbeque", @"code": @"bbq"},
      @{@"name": @"Basque", @"code": @"basque"},
      @{@"name": @"Bavarian", @"code": @"bavarian"},
      @{@"name": @"Beer Garden", @"code": @"beergarden"},
      @{@"name": @"Beer Hall", @"code": @"beerhall"},
      @{@"name": @"Beisl", @"code": @"beisl"},
      @{@"name": @"Belgian", @"code": @"belgian"},
      @{@"name": @"Bistros", @"code": @"bistros"},
      @{@"name": @"Black Sea", @"code": @"blacksea"},
      @{@"name": @"Brasseries", @"code": @"brasseries"},
      @{@"name": @"Brazilian", @"code": @"brazilian"},
      @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
      @{@"name": @"British", @"code": @"british"},
      @{@"name": @"Buffets", @"code": @"buffets"},
      @{@"name": @"Bulgarian", @"code": @"bulgarian"},
      @{@"name": @"Burgers", @"code": @"burgers"},
      @{@"name": @"Burmese", @"code": @"burmese"},
      @{@"name": @"Cafes", @"code": @"cafes"},
      @{@"name": @"Cafeteria", @"code": @"cafeteria"},
      @{@"name": @"Cajun/Creole", @"code": @"cajun"},
      @{@"name": @"Cambodian", @"code": @"cambodian"},
      @{@"name": @"Canadian", @"code": @"New)"},
      @{@"name": @"Canteen", @"code": @"canteen"},
      @{@"name": @"Caribbean", @"code": @"caribbean"},
      @{@"name": @"Catalan", @"code": @"catalan"},
      @{@"name": @"Chech", @"code": @"chech"},
      @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
      @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
      @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
      @{@"name": @"Chilean", @"code": @"chilean"},
      @{@"name": @"Chinese", @"code": @"chinese"},
      @{@"name": @"Comfort Food", @"code": @"comfortfood"},
      @{@"name": @"Corsican", @"code": @"corsican"},
      @{@"name": @"Creperies", @"code": @"creperies"},
      @{@"name": @"Cuban", @"code": @"cuban"},
      @{@"name": @"Curry Sausage", @"code": @"currysausage"},
      @{@"name": @"Cypriot", @"code": @"cypriot"},
      @{@"name": @"Czech", @"code": @"czech"},
      @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
      @{@"name": @"Danish", @"code": @"danish"},
      @{@"name": @"Delis", @"code": @"delis"},
      @{@"name": @"Diners", @"code": @"diners"},
      @{@"name": @"Dumplings", @"code": @"dumplings"},
      @{@"name": @"Eastern European", @"code": @"eastern_european"},
      @{@"name": @"Ethiopian", @"code": @"ethiopian"},
      @{@"name": @"Fast Food", @"code": @"hotdogs"},
      @{@"name": @"Filipino", @"code": @"filipino"},
      @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
      @{@"name": @"Fondue", @"code": @"fondue"},
      @{@"name": @"Food Court", @"code": @"food_court"},
      @{@"name": @"Food Stands", @"code": @"foodstands"},
      @{@"name": @"French", @"code": @"french"},
      @{@"name": @"French Southwest", @"code": @"sud_ouest"},
      @{@"name": @"Galician", @"code": @"galician"},
      @{@"name": @"Gastropubs", @"code": @"gastropubs"},
      @{@"name": @"Georgian", @"code": @"georgian"},
      @{@"name": @"German", @"code": @"german"},
      @{@"name": @"Giblets", @"code": @"giblets"},
      @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
      @{@"name": @"Greek", @"code": @"greek"},
      @{@"name": @"Halal", @"code": @"halal"},
      @{@"name": @"Hawaiian", @"code": @"hawaiian"},
      @{@"name": @"Heuriger", @"code": @"heuriger"},
      @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
      @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
      @{@"name": @"Hot Dogs", @"code": @"hotdog"},
      @{@"name": @"Hot Pot", @"code": @"hotpot"},
      @{@"name": @"Hungarian", @"code": @"hungarian"},
      @{@"name": @"Iberian", @"code": @"iberian"},
      @{@"name": @"Indian", @"code": @"indpak"},
      @{@"name": @"Indonesian", @"code": @"indonesian"},
      @{@"name": @"International", @"code": @"international"},
      @{@"name": @"Irish", @"code": @"irish"},
      @{@"name": @"Island Pub", @"code": @"island_pub"},
      @{@"name": @"Israeli", @"code": @"israeli"},
      @{@"name": @"Italian", @"code": @"italian"},
      @{@"name": @"Japanese", @"code": @"japanese"},
      @{@"name": @"Jewish", @"code": @"jewish"},
      @{@"name": @"Kebab", @"code": @"kebab"},
      @{@"name": @"Korean", @"code": @"korean"},
      @{@"name": @"Kosher", @"code": @"kosher"},
      @{@"name": @"Kurdish", @"code": @"kurdish"},
      @{@"name": @"Laos", @"code": @"laos"},
      @{@"name": @"Laotian", @"code": @"laotian"},
      @{@"name": @"Latin American", @"code": @"latin"},
      @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
      @{@"name": @"Lyonnais", @"code": @"lyonnais"},
      @{@"name": @"Malaysian", @"code": @"malaysian"},
      @{@"name": @"Meatballs", @"code": @"meatballs"},
      @{@"name": @"Mediterranean", @"code": @"mediterranean"},
      @{@"name": @"Mexican", @"code": @"mexican"},
      @{@"name": @"Middle Eastern", @"code": @"mideastern"},
      @{@"name": @"Milk Bars", @"code": @"milkbars"},
      @{@"name": @"Modern Australian", @"code": @"modern_australian"},
      @{@"name": @"Modern European", @"code": @"modern_european"},
      @{@"name": @"Mongolian", @"code": @"mongolian"},
      @{@"name": @"Moroccan", @"code": @"moroccan"},
      @{@"name": @"New Zealand", @"code": @"newzealand"},
      @{@"name": @"Night Food", @"code": @"nightfood"},
      @{@"name": @"Norcinerie", @"code": @"norcinerie"},
      @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
      @{@"name": @"Oriental", @"code": @"oriental"},
      @{@"name": @"Pakistani", @"code": @"pakistani"},
      @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
      @{@"name": @"Parma", @"code": @"parma"},
      @{@"name": @"Persian/Iranian", @"code": @"persian"},
      @{@"name": @"Peruvian", @"code": @"peruvian"},
      @{@"name": @"Pita", @"code": @"pita"},
      @{@"name": @"Pizza", @"code": @"pizza"},
      @{@"name": @"Polish", @"code": @"polish"},
      @{@"name": @"Portuguese", @"code": @"portuguese"},
      @{@"name": @"Potatoes", @"code": @"potatoes"},
      @{@"name": @"Poutineries", @"code": @"poutineries"},
      @{@"name": @"Pub Food", @"code": @"pubfood"},
      @{@"name": @"Rice", @"code": @"riceshop"},
      @{@"name": @"Romanian", @"code": @"romanian"},
      @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
      @{@"name": @"Rumanian", @"code": @"rumanian"},
      @{@"name": @"Russian", @"code": @"russian"},
      @{@"name": @"Salad", @"code": @"salad"},
      @{@"name": @"Sandwiches", @"code": @"sandwiches"},
      @{@"name": @"Scandinavian", @"code": @"scandinavian"},
      @{@"name": @"Scottish", @"code": @"scottish"},
      @{@"name": @"Seafood", @"code": @"seafood"},
      @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
      @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
      @{@"name": @"Singaporean", @"code": @"singaporean"},
      @{@"name": @"Slovakian", @"code": @"slovakian"},
      @{@"name": @"Soul Food", @"code": @"soulfood"},
      @{@"name": @"Soup", @"code": @"soup"},
      @{@"name": @"Southern", @"code": @"southern"},
      @{@"name": @"Spanish", @"code": @"spanish"},
      @{@"name": @"Steakhouses", @"code": @"steak"},
      @{@"name": @"Sushi Bars", @"code": @"sushi"},
      @{@"name": @"Swabian", @"code": @"swabian"},
      @{@"name": @"Swedish", @"code": @"swedish"},
      @{@"name": @"Swiss Food", @"code": @"swissfood"},
      @{@"name": @"Tabernas", @"code": @"tabernas"},
      @{@"name": @"Taiwanese", @"code": @"taiwanese"},
      @{@"name": @"Tapas Bars", @"code": @"tapas"},
      @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
      @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
      @{@"name": @"Thai", @"code": @"thai"},
      @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
      @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
      @{@"name": @"Trattorie", @"code": @"trattorie"},
      @{@"name": @"Turkish", @"code": @"turkish"},
      @{@"name": @"Ukrainian", @"code": @"ukrainian"},
      @{@"name": @"Uzbek", @"code": @"uzbek"},
      @{@"name": @"Vegan", @"code": @"vegan"},
      @{@"name": @"Vegetarian", @"code": @"vegetarian"},
      @{@"name": @"Venison", @"code": @"venison"},
      @{@"name": @"Vietnamese", @"code": @"vietnamese"},
      @{@"name": @"Wok", @"code": @"wok"},
      @{@"name": @"Wraps", @"code": @"wraps"},
      @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
}


@end
