//
//  LCProfileViewController.m
//  lucky2me
//
//  Created by GanWenPeng on 16/1/13.
//  Copyright © 2016年 甘文鹏. All rights reserved.
//

#import "LCProfileViewController.h"
#import "LCInputViewController.h"
#import "LCEditHeadIconViewController.h"
#import <AliyunOSSiOS/OSSService.h>
#import <SDWebImage/SDImageCache.h>

@interface LCProfileViewController ()<UITableViewDataSource, UITableViewDelegate, LCInputViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *choicePhotoView;

- (IBAction)cameraClick;
- (IBAction)albumClick;
- (IBAction)cancelClick;

@property (nonatomic, strong)   NSArray *tableDataArr;
@property (nonatomic, weak)     UITableView *tableView;
@property (nonatomic, strong)   LCInputViewController *nickInputVc;
@property (nonatomic, weak)     UIButton *headImageBtn;

@property (nonatomic, strong)   UIImage *avatar;
@property (nonatomic, copy)     NSString *username;



@end

@implementation LCProfileViewController
#pragma mark - lazy
- (LCInputViewController *)nickInputVc{
    if (!_nickInputVc) {
        _nickInputVc = [[LCInputViewController alloc] init];
        _nickInputVc.delegate = self;
        _nickInputVc.title = [LCCommonTool sharedLCCommonTool].currentUser.username;
        _nickInputVc.placeholder = @"点击添加昵称";
        _nickInputVc.delegate = self;
    }
    return _nickInputVc;
}

- (void)reloadTableData{
        __weak typeof(self) weakSelf = self;
        LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
        
        BaseCellModel *icon = [BaseCellModel modelWithImage:nil title:nil subTitle:nil targetClass:nil clickHandler:^{
            weakSelf.choicePhotoView.hidden = NO;;
            
        }];
        
        BaseCellModel *nick = [BaseCellModel modelWithImage:[UIImage imageNamed:@"next2"] title:@"昵称" subTitle:u.username?u.username:nil targetClass:nil clickHandler:^{
            weakSelf.nickInputVc.contentStr = u.username;
            [weakSelf.navigationController pushViewController:weakSelf.nickInputVc animated:YES];
        }];
        nick.placeholder = @"点击添加昵称";
    LogMethod
        _tableDataArr = @[icon, nick];
}

#pragma mark - init system
- (instancetype)init{
    if (self = [super init]) {
        LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
        self.username = u.username;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self reloadTableData];
    [self.tableView reloadData];
}

//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor whiteColor]];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    self.title = @"个人资料";
    self.choicePhotoView.hidden = YES;
    UITableView *table = [[UITableView alloc] init];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
    [self.view insertSubview:table atIndex:0];
    self.tableView = table;
    [table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    
}


#pragma mark - action


- (IBAction)cameraClick {
    [self cancelClick];
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker=[[UIImagePickerController alloc]init];
        picker.delegate=self;
        // 设置拍照后的图片可被编辑
//        picker.allowsEditing=YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        
        [MBProgressHUD showMessage:@"相机无法使用" toView:self.view];
        GWPLog(@"模拟器中无法打开相机");
    }
}

- (IBAction)albumClick {
    [self cancelClick];

    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
    picker.delegate=self;
    // 设置选择后的图片可被编辑
//    picker.allowsEditing=YES;
    [self presentViewController:picker animated:YES completion:nil];

}

- (IBAction)cancelClick {
    self.choicePhotoView.hidden = YES;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.choicePhotoView.hidden = YES;
}
#pragma mark - UITableViewDataSource、Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    
    NSString *const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = DefaultColorGray153;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        if (model.title) {
            UIView *sep = [[UIView alloc] init];
            [cell addSubview:sep];
            sep.backgroundColor = DefaultColorGray229;
            sep.x = 16;
            sep.y = 50;
            sep.width = GWPScreenW - 32;
            sep.height = 1;
        }
    }
    
    cell.textLabel.text = model.title;
    if (model.subTitle && model.subTitle.length>0) {
        cell.detailTextLabel.text = model.subTitle;
        cell.detailTextLabel.textColor = GWPRGBColor(68, 68, 68, 1);
    } else {
        cell.detailTextLabel.text = model.placeholder;
        cell.detailTextLabel.textColor = DefaultColorGray204;
    }
    if (indexPath.row==0) {
        cell.accessoryView = nil;
        UIButton *icon = [[UIButton alloc] init];
        icon.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageBtn = icon;
        icon.userInteractionEnabled = NO;
        [cell addSubview:icon];
        
        icon.size = CGSizeMake(80, 80);
        icon.centerX = self.view.centerX;
        icon.y = 16;
        icon.backgroundColor = DefaultColorGray244;
        icon.layer.cornerRadius = icon.width/2;
        icon.clipsToBounds = YES;
        icon.titleLabel.numberOfLines = 0;
        icon.titleLabel.textAlignment = NSTextAlignmentCenter;
        icon.titleLabel.font = [UIFont systemFontOfSize:17];
        [icon setTitleColor:DefaultColorGray153 forState:UIControlStateNormal];
        [LCUserViewModel setCurrentUserAvatarForView:icon placeholder:[UIImage imageNamed:@"headicon"]];
    } else {
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
        cell.accessoryView = icon;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    
    return model.title ? 61.5 : 105;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    BaseCellModel *model = self.tableDataArr[indexPath.row];
    if (model.clickHandler) {
        model.clickHandler();
        return;
    }
}


#pragma mark - LCInputViewControllerDelegate
- (void)inputViewController:(LCInputViewController *)inputViewController completeInputWith:(NSString *)str{
    if ([inputViewController isEqual:self.nickInputVc]) self.username = str;
    
    [self modifyProfile];
    [inputViewController.navigationController popViewControllerAnimated:YES];
}


#pragma mark - networking
- (void)modifyProfile{
    if (!(self.username.length>0)) return;
    
    LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"username"]     = self.username;
    params[@"uid"] = u.user_id;
    params[@"token"] = u.token;
    DLog(@"%@", params);
    
    __weak typeof(self) weakSelf = self;
    [NetworkTool POST:API_ModifyProfile parameters:params showHUD:YES hudView:nil hudStr:nil  success:^(id data) {
        LCUser *u = [LCCommonTool sharedLCCommonTool].currentUser;
        if (self.username)              u.username  = self.username;
        [LCCommonTool sharedLCCommonTool].currentUser = u;
        [weakSelf reloadTableData];
        [weakSelf.tableView reloadData];
        [TheNotificationCenter postNotificationName:N_UserInfoDidChangeNotification object:nil];
    } tgError:nil failure:nil];
}

#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type=[info objectForKey:UIImagePickerControllerMediaType];
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        LCEditHeadIconViewController *vc = [[LCEditHeadIconViewController alloc] init];
        vc.sourceType = picker.sourceType;
        vc.headImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        __weak typeof(vc) weakVc = vc;
        vc.confirmClick = ^(UIImage *image){
            [weakVc dismissViewControllerAnimated:YES completion:nil];
            NSData *data = UIImagePNGRepresentation(image);
            // 明文设置secret的方式建议只在测试时使用，更多鉴权模式请参考后面的访问控制章节
            id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:SDK_OSS_AppKeyID secretKey:SDK_OSS_AppSecret];
            
            OSSClientConfiguration * conf = [[OSSClientConfiguration alloc] init];
            conf.maxRetryCount = 3; // 网络请求遇到异常失败后的重试次数
            conf.timeoutIntervalForRequest = 30; // 网络请求的超时时间
            conf.timeoutIntervalForResource = 24 * 60 * 60; // 允许资源传输的最长时间
            
            OSSClient *client = [[OSSClient alloc] initWithEndpoint:SDK_OSS_Endpoint credentialProvider:credential clientConfiguration:conf];
            [OSSLog enableLog];
            OSSPutObjectRequest * put = [OSSPutObjectRequest new];
            
            put.bucketName = SDK_OSS_BucketName;
            put.objectKey = [NSString stringWithFormat:@"LC/img/headIcon/%@.png", [LCCommonTool sharedLCCommonTool].currentUser.user_id.md5];
            
            put.uploadingData = data; // 直接上传NSData
            
            put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
                DLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
            };
            
            OSSTask * putTask = [client putObject:put];
            
            
            [putTask continueWithBlock:^id(OSSTask *task) {
                if (!task.error) {
                    DLog(@"upload object success!");
                    [[SDImageCache sharedImageCache] removeImageForKey:[LCCommonTool sharedLCCommonTool].currentUser.avatarURL fromDisk:YES];
                } else {
                    DLog(@"upload object failed, error: %@" , task.error);
                }
                return nil;
            }];
            [LCCommonTool sharedLCCommonTool].currentUser.avatarImage = image;
        };
        [picker pushViewController:vc animated:YES];
        
    }
}

- (NSData *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return imageData;
}
@end
