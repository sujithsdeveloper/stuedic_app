class ApiUrls {
  static Uri baseUrl = Uri.parse('https://api.stuedic.com/');
  static Uri socketBaseUrl = Uri.parse('ws://api.stuedic.com/');

  //auth
  static Uri onBoardUrl = Uri.parse('${baseUrl}api/v1/User/onBoard');
  static Uri grantAccessTokenUrl =
      Uri.parse('${baseUrl}api/v1/User/grantAccessToken');
  static Uri loginUrl = Uri.parse('${baseUrl}api/v1/User/login');
  static Uri forgotPasswordUrl = Uri.parse('${baseUrl}api/v1/User/logoutusern');
  //College
  static Uri getCollegeList = Uri.parse('${baseUrl}api/v1/Collage/list');

  //post
  static Uri addPostUrl = Uri.parse('${baseUrl}api/v1/Post/addNewPost');
  static Uri uploadPicForPost =
      Uri.parse('${baseUrl}api/v1/Post/UploadPicForPost');
  static Uri deletePost = Uri.parse('${baseUrl}api/v1/Post/deletePost');
  static Uri homeFeedAPI =
      Uri.parse('${baseUrl}api/v1/Post/homeFeed?page=1&limit=50');

  //reel
  static Uri reelAPI =
      Uri.parse('${baseUrl}api/v1/Post/homeFeed?page=1&limit=20&reelonly=true');

  //profile
  static Uri profileGridUrl =
      Uri.parse('${baseUrl}api/v1/Profile/getProfileGrid');
  static Uri uploadProfile =
      Uri.parse('${baseUrl}api/v1/Profile/uploadProfilePic');
  static Uri editProfile =
      Uri.parse('${baseUrl}api/v1/Profile/editUserDetails');
  static Uri getAllPostsOfUser =
      Uri.parse('${baseUrl}api/v1/Post/getAllPostsOfUser?userId=');
  static Uri getUserDetail =
      Uri.parse('${baseUrl}api/v1/Profile/getUserDetails');
  static Uri logoutUser = Uri.parse('${baseUrl}api/v1/User/logoutuser');
  static Uri changePassword = Uri.parse('${baseUrl}api/v1/User/changePassword');

  //product
  static Uri addNewProduct =
      Uri.parse('${baseUrl}api/v1/Marketplace/addNewProduct');
  static Uri getAllProducts =
      Uri.parse('${baseUrl}api/v1/Marketplace/getAllProducts');

  //story
  static Uri addStory = Uri.parse('${baseUrl}api/v1/story/addNewStory');
  static Uri getStoryList = Uri.parse('${baseUrl}api/v1/story/listStories');

  //search
  static Uri searchApi = Uri.parse('${baseUrl}api/v1/Search/searchUser');

  //Notification
  static Uri checkNotifications =
      Uri.parse('${baseUrl}api/v1/Profile/hasNotifications');
  static Uri getNotification =
      Uri.parse('${baseUrl}api/v1/Profile/notifications');

  //bookmark
  static Uri addBookmark = Uri.parse('${baseUrl}api/v1/Post/addBookmark');
  static Uri getBookmark = Uri.parse('${baseUrl}api/v1/Post/getbookmarks');
  static Uri deleteBookmark = Uri.parse('${baseUrl}api/v1/Post/deleteBookmark');

  //chat
  static Uri chatList = Uri.parse('${baseUrl}api/v1/chat/screen');
  static Uri clearChat = Uri.parse('${baseUrl}api/v1/chat/clear');
  static Uri deleteMessages = Uri.parse('${baseUrl}api/v1/chat/deleteMessages');

  //Upload video
  static Uri uploadVideo = Uri.parse('${baseUrl}api/v1/Post/uploadVideo');

//Discover
  static Uri discover = Uri.parse('${baseUrl}api/v1/Post/discover');

  //OTP
  static Uri getOtp = Uri.parse('${baseUrl}api/v1/auth/generateOtp');
  static Uri checkOtp = Uri.parse('${baseUrl}api/v1/auth/verifyOtp');
}
