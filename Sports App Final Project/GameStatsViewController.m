//
//  GameStatsViewController.m
//  Sports App Final Project
//
//  Created by Nikhil Raman on 4/21/16.
//  Copyright © 2016 cis195. All rights reserved.
//

#import "GameStatsViewController.h" 

#define baseMlbURL @"https://www.stattleship.com/baseball/mlb/team_game_logs?team_id="
#define baseNbaURL @"https://www.stattleship.com/basketball/nba/team_game_logs?team_id="
#define contentType @"application/json" 
#define authorization @"574b304415b0573a45087d3df6326f07" 
#define accept @"application/vnd.stattleship.com; version=1"

@interface GameStatsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *homeGameLogArray;
@property NSMutableArray *awayGameLogArray;
@property NSDictionary *teamMap;

@end

@implementation GameStatsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.homeGameLogArray = [[NSMutableArray alloc] init];
    self.awayGameLogArray = [[NSMutableArray alloc] init];
    
    if ([self.sport isEqualToString:@"mlb"]) {
        self.teamMap = @{
            @"San Francisco Giants" : @"mlb-sf",
            @"San Diego Padres" : @"mlb-sd",
            @"Arizona Diamondbacks" : @"mlb-ari",
            @"Los Angeles Dodgers" : @"mlb-la",
            @"Los Angeles Angels" : @"mlb-laa",
            @"Chicago Cubs" : @"mlb-chc",
            @"Atlanta Braves" : @"mlb-atl",
            @"Pittsburgh Pirates" : @"mlb-pit",
            @"Cincinnati Reds" : @"mlb-cin",
            @"Baltimore Orioles" : @"mlb-bal",
            @"Chicago White Sox" : @"mlb-chw",
            @"Philadelphia Phillies" : @"mlb-phi",
            @"Cleveland Indians" : @"mlb-cle",
            @"New York Mets" : @"mlb-nym",
            @"Boston Red Sox" : @"mlb-bos",
            @"New York Yankees" : @"mlb-nyy",
            @"Tampa Bay Rays" : @"mlb-tb",
            @"Toronto Blue Jays" : @"mlb-tor",
            @"Texas Rangers" : @"mlb-tex",
            @"Milwaukee Brewers" : @"mlb-mil",
            @"Miami Marlins" : @"mlb-mia",
            @"Minnesota Twins" : @"mlb-min",
            @"Detroit Tigers" : @"mlb-det",
            @"St. Louis Cardinals" : @"mlb-stl",
            @"Washington Nationals" : @"mlb-was",
            @"Colorado Rockies" : @"mlb-col",
            @"Oakland Athletics" : @"mlb-oak",
            @"Houston Astros" : @"mlb-hou",
            @"Seattle Mariners" : @"mlb-sea",
            @"Kansas City Royals" : @"mlb-kc",
                                    };
    }
    else if ([self.sport isEqualToString:@"nba"]) {
        self.teamMap = @{
             @"Golden State Warriors" : @"nba-gs",
             @"Oklahoma City Thunder" : @"nba-okc",
             @"San Antonio Spurs" : @"nba-sa",
             @"Los Angeles Clippers" : @"nba-lac",
             @"Portland Trail Blazers" : @"nba-por",
             @"Indiana Pacers" : @"nba-ind",
             @"Toronto Raptors" : @"nba-tor",
             @"Charlotte Hornets" : @"nba-cha",
             @"Miami Heat" : @"nba-mia",
             @"Cleveland Cavaliers" : @"nba-cle",
             @"Atlanta Hawks" : @"nba-atl",
                         };
    }
    else {
        NSLog(@"Team name not proper");
    }
    [self loadGameLogForHomeTeam];
    [self loadGameLogForAwayTeam];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
}

- (void) loadGameLogForHomeTeam {
    // TO DO: Get stats from NBA API
    NSLog(@"Entering game log 1 loading");
    
    NSString *fullURL;
    
    if (!self.homeTeamName || !self.awayTeamName) {
        NSLog(@"Team Name(s) passed in are null!!!!");
    }
    
    if ([self.sport isEqualToString:@"mlb"]) {
        fullURL = [baseMlbURL stringByAppendingString:[self.teamMap objectForKey:self.homeTeamName]];
    }
    else if ([self.sport isEqualToString:@"nba"]) {
         fullURL = [baseNbaURL stringByAppendingString:[self.teamMap objectForKey:self.homeTeamName]];
    }
    else {
        NSLog(@"Team name not proper");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:accept forHTTPHeaderField:@"Accept"];
    //[request setValue:@"Game" forKey:@"oddType"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSArray *games = [json objectForKey:@"games"];
                    self.homeGameLogArray = [games mutableCopy];
                    NSLog(@"Obtained homeGameLog data");
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_async(mainQueue, ^{
                        [self.tableView reloadData];
                    });
                }] resume];
}

- (void) loadGameLogForAwayTeam {
    // TO DO: Get stats from NBA API
    NSLog(@"Entering game log 2 loading");
    NSString *fullURL;
    
    if ([self.sport isEqualToString:@"mlb"]) {
        fullURL = [baseMlbURL stringByAppendingString:[self.teamMap objectForKey:self.awayTeamName]];
    }
    else if ([self.sport isEqualToString:@"nba"]) {
        fullURL = [baseNbaURL stringByAppendingString:[self.teamMap objectForKey:self.awayTeamName]];
    }
    else {
        NSLog(@"Team name not proper");
        return;
    }
    
    NSURL *url = [NSURL URLWithString:fullURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setValue:authorization forHTTPHeaderField:@"Authorization"];
    [request setValue:accept forHTTPHeaderField:@"Accept"];
    //[request setValue:@"Game" forKey:@"oddType"];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData * data, NSURLResponse *response, NSError *error) {
                    NSMutableDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                    NSArray *games = [json objectForKey:@"games"];
                    self.awayGameLogArray = [games mutableCopy];
                    NSLog(@"Obtained awayGameLog data");
                    dispatch_queue_t mainQueue = dispatch_get_main_queue();
                    dispatch_async(mainQueue, ^{
                        [self.tableView reloadData];
                    });
                }] resume];
}


- (IBAction)backButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.awayGameLogArray.count;
    }
    else {
        return self.homeGameLogArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return self.awayTeamName;
    else
        return self.homeTeamName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recentGamesCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentGamesCell"];
    }
    
    NSDictionary *game;
    if (indexPath.section == 0) {
        game = self.awayGameLogArray[indexPath.row];
    }
    else {
        game = self.homeGameLogArray[indexPath.row];
    }
    
    NSString *scoreLine = [game objectForKey:@"scoreline"];
    UILabel *scorelineLabel = (UILabel *)[cell viewWithTag:1];
    if (indexPath.section == 0) {
        scorelineLabel.textColor = [UIColor orangeColor];
    }
    else {
        scorelineLabel.textColor = [UIColor blueColor];
    }
    scorelineLabel.text = scoreLine;
    
    NSString *dateStringRaw = [game objectForKey:@"started_at"];
    NSString *dateString = [dateStringRaw substringToIndex:10];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *gameTime = [dateFormatter dateFromString:dateString];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"EDT"]];
    [dateFormatter setDateFormat:@"MM/dd"];
    NSString *newDateString = [dateFormatter stringFromDate:gameTime];
    UILabel *dateLabel = (UILabel *)[cell viewWithTag:2];
    dateLabel.text = newDateString;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
