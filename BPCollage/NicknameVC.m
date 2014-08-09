//
//  NicknameVC.m
//  BPCollage
//
//  Created by Administrator on 08.08.14.
//  Copyright (c) 2014 Administrator. All rights reserved.
//

#import "NicknameVC.h"
#import "Photo.h"
#import "BestCollectionVC.h"

@interface NicknameVC ()<NSURLSessionDownloadDelegate, UITextFieldDelegate, UIAlertViewDelegate>

///////////////////////////////////////////
///////////////////////////////////////////

@property (weak, nonatomic) IBOutlet UITextField *nickname;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (strong,nonatomic) NSMutableArray *photos;  // array with parsed Photo* objects
@property (strong,nonatomic) NSString *name;          // nickname used for search last time
@end

///////////////////////////////////////////
///////////////////////////////////////////

@implementation NicknameVC

///////////////////////////////////////////
#pragma mark - ViewDidLoad
///////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nickname.delegate=self;
    self.spinner.hidden=YES;
    // Do any additional setup after loading the view.
}

///////////////////////////////////////////
#pragma mark - Getters
///////////////////////////////////////////

-(NSString *)name
{
    if (!_name) {
        _name=[[NSString alloc]init];
    }
    return _name;
}

-(NSMutableArray *)photos
{
    if (!_photos) {
        _photos=[[NSMutableArray alloc]init];
    }
    return _photos;
}

////////////////////////////////////////////////////////////////// Get sorted and limited array using already parsed array with Photo* objects
-(NSArray *) sortedPhotosByPopularity
{
    NSArray *sortedArray=[self.photos sortedArrayUsingSelector:@selector(photoCompare:)];
    if ([sortedArray count]>LIMITPHOTOS) {
        NSArray *limitedArray=[sortedArray subarrayWithRange:NSMakeRange(0, LIMITPHOTOS)];
        return limitedArray;
    }else{
        return sortedArray;
    }
}

///////////////////////////////////////////
#pragma mark - IBAction
///////////////////////////////////////////

////////////////////////////////////////////////////////////////// Handle user request
- (IBAction)clickCreate:(id)sender
{
    [self textFieldShouldReturn:self.nickname];
    if ([self.nickname.text length]) {                         //if request exists
        NSLog(@"%@ - %@",self.nickname.text,self.name);
        if (![self.nickname.text isEqualToString:self.name]) { // -> if request name is not the same with last one
            self.photos=nil;                                         //then clear last results and create new fetch
            self.name=nil;
            [self fetchUser];
        }
    }else{                                                     //else (not exists) call alert
        [self cancelWithAlert:4];
    }
}

///////////////////////////////////////////
#pragma mark - PrepareForSegue
///////////////////////////////////////////

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PushToCollection"]) {
        if ([segue.destinationViewController isKindOfClass:[BestCollectionVC class]]){
            BestCollectionVC *bcvc=(BestCollectionVC *)segue.destinationViewController;
            bcvc.photos=[self sortedPhotosByPopularity];        //send sorted array with Photo* object to next VC
        }
    }
}

////////////////////////////////////////////////////////////////// Seque pause for Network Downloading
-(BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"PushToCollection"]) {
        if ([self.photos count]&&[self.nickname.text isEqualToString:self.name]) { //if request name is the same with last one
            return YES;                                                            //then perform segue with already downloaded data
        }else return NO;
    }
    return YES;
}

////////////////////////////////////////////////////////////////// After Network Downloading Let's perform Segue via Code
-(void) readyForSeque
{
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    self.name=[NSString stringWithString:self.nickname.text];
    [self performSegueWithIdentifier:@"PushToCollection" sender:self];
}

///////////////////////////////////////////
#pragma mark - Alerts settings
///////////////////////////////////////////

-(void) cancelWithAlert:(NSInteger) alertCode
{
    [self.spinner stopAnimating];
    self.spinner.hidden=YES;
    UIAlertView *alert;
    switch (alertCode) {
        case 1:
            alert=[[UIAlertView alloc]initWithTitle:@"Нет соединения" message:@"Не удалось подключиться к Instagram. Проверьте интернет соединение." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        case 2:
            alert=[[UIAlertView alloc]initWithTitle:@"Нет такого ника" message:@"Не удалось найти пользователя с таким ником. Попробуйте еще раз." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            self.nickname.text=@"";
            break;
        case 3:
            alert=[[UIAlertView alloc]initWithTitle:@"Пусто" message:@"К сожалению, у пользователя нет доступных фотографий." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        case 4:
            alert=[[UIAlertView alloc]initWithTitle:@"Необходим ник" message:@"Пожалуйста, введите имя пользователя." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
        case 5:
            alert=[[UIAlertView alloc]initWithTitle:@"Bad food" message:@"Пожалуйста, введите другое имя пользователя." delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            self.nickname.text=@"";
            break;
        default:
            alert=[[UIAlertView alloc]initWithTitle:@"Ошибка" message:@"Неожиданно возникла ошибка(" delegate:self cancelButtonTitle:@"ОК" otherButtonTitles: nil];
            break;
    }
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}


///////////////////////////////////////////
#pragma mark - Downloading
///////////////////////////////////////////

////////////////////////////////////////////////////////////////// Network Request for search nickname
- (void) fetchUser
{
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@%@%@%s", APIINSTAGRAM,@"search?q=",self.nickname.text,@"&count=1&client_id=",CLIENTID]]];
    bool valid = [NSURLConnection canHandleRequest:request];                    //is it a good nickname for user?
    NSLog(@"%i",valid);
    NSLog(@"%@",[NSString stringWithFormat:@"%s%@%@%@%s", APIINSTAGRAM,@"search?q=",self.nickname.text,@"&count=1&client_id=",CLIENTID]);
    if (valid) {
        NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration ephemeralSessionConfiguration];
        NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
        NSURLSessionDownloadTask *task=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
            
            [self loadUserInfoFromLocalURL:location andThenExecuteBlock:nil];   //download completed, Lets parse
        }];
        [task resume];
    } else{
        [self cancelWithAlert:5];
    }

}

////////////////////////////////////////////////////////////////// Parsing user search results
- (void)loadUserInfoFromLocalURL:(NSURL *)localFile
             andThenExecuteBlock:(void(^)())blockExe
{
    NSDictionary *dictonaryOfUserInfo = [self dictionaryFromURL:localFile]; //Parsing via NSJSONSerialization
    NSArray *array=[dictonaryOfUserInfo valueForKeyPath:@"data.id"];
    NSString *nickID=@"";
    
    if ([array count]) {
        if ([[array objectAtIndex:0] isKindOfClass:[NSString class]]) {
            nickID=[NSString stringWithFormat:@"%@",[array objectAtIndex:0]];
        }
    }
    
    if ([nickID length]) {                                //If Nick is founded
        [self fetchPhotosByUserID:nickID];                //   then search photos with this userID
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancelWithAlert:2];                     //Else (user is not founded) -> call alert and end operation
        });
    }
    if (blockExe) blockExe();
}

////////////////////////////////////////////////////////////////// Network Request for search Nickname's photos via userID
- (void) fetchPhotosByUserID:(NSString *)userID
{
    self.spinner.hidden=NO;
    [self.spinner startAnimating];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%s%@%@%s", APIINSTAGRAM,userID,@"/media/recent?count=50&client_id=",CLIENTID]]];
    NSLog(@"%@",[NSString stringWithFormat:@"%s%@%@%s", APIINSTAGRAM,userID,@"/media/recent?count=50&client_id=",CLIENTID]);
    NSURLSessionConfiguration *configuration=[NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task=[session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        [self loadPhotosInfoFromLocalURL:location andThenExecuteBlock:nil]; //download completed, Lets parse
    }];
    [task resume];
}


////////////////////////////////////////////////////////////////// Network Request for search Nickname's photos via userID
- (void)loadPhotosInfoFromLocalURL:(NSURL *)localFile
             andThenExecuteBlock:(void(^)())blockExe
{
    NSDictionary *dictonaryOfPhotoInfo = [self dictionaryFromURL:localFile]; //Parsing via NSJSONSerialization
    NSArray *array=[dictonaryOfPhotoInfo valueForKeyPath:@"data"];
    if ([array count]){                                                      //IF Photos founded
        for (NSDictionary *photoDict in array) {
            
            Photo *photo=[[Photo alloc]init];                                      //then creating Photo* objects
                                                                                   //and save url and number of "like"
            id likes=[photoDict valueForKeyPath:@"likes.count"];
            id url=[photoDict valueForKeyPath:@"images.thumbnail.url"];
            if (url) {
                photo.likes=[NSNumber numberWithInt:[likes intValue]];
                NSLog(@"LIKES: %@",photo.likes);
                NSString *string=[NSString stringWithFormat:@"%@",url];
                NSString *imageName=[string lastPathComponent];
                photo.imageURL=[NSString stringWithFormat:@"%s%@",WEBIMAGE,imageName];
                
                [self.photos addObject:photo];
            }
        }//end for
        
        if ([self.photos count]) {                                                  // -> IF there are any photos then perform SEGUE
             [self performSelectorOnMainThread:@selector(readyForSeque) withObject:nil waitUntilDone:NO];
        }
    }else{                                                                   //ELSE (no photo data in parsed array) -> call alert and end operation
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cancelWithAlert:3];
        });
    }
    if (blockExe) blockExe();
}

////////////////////////////////////////////////////////////////// Parsing JSON to NSDictionary
- (NSDictionary *)dictionaryFromURL:(NSURL *)url
{
    NSDictionary *fullData;
    NSData *downloadedData = [NSData dataWithContentsOfURL:url];
    
    if (downloadedData) {
        fullData = [NSJSONSerialization JSONObjectWithData:downloadedData
                                                   options:0 error:NULL];
        return fullData;
    }else return nil;
}



///////////////////////////////////////////
#pragma mark - NSURLSessionDownloadDelegate
///////////////////////////////////////////

// required by the protocol
- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)localFile
{
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
}


- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
}

///////////////////////////////////////////
#pragma mark - UITextFieldDelegate
///////////////////////////////////////////

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
}

///////////////////////////////////////////
#pragma mark - Other VC methods
///////////////////////////////////////////

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

///////////////////////////////////////////
///////////////////////////////////////////
@end
///////////////////////////////////////////
///////////////////////////////////////////
