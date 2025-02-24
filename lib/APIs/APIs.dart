class APIs {
  static Uri baseUrl = Uri.parse('https://api.stuedic.com/');
  static Uri socketBaseUrl = Uri.parse('ws://15.207.10.0:8080/');

  //auth
  static Uri onBoardUrl = Uri.parse('${baseUrl}api/v1/User/onBoard');
  static Uri grantAccessTokenUrl = Uri.parse('${baseUrl}api/v1/User/grantAccessToken');
  static Uri loginUrl = Uri.parse('${baseUrl}api/v1/User/login');
  static Uri forgotPasswordUrl = Uri.parse('${baseUrl}api/v1/User/logoutusern');

  //post
  static Uri addPostUrl = Uri.parse('${baseUrl}api/v1/Post/addNewPost');
  static Uri uploadPicForPost = Uri.parse('${baseUrl}api/v1/Post/UploadPicForPost');
  static Uri deletePost = Uri.parse('${baseUrl}api/v1/Post/deletePost');
  static Uri homeFeedAPI = Uri.parse('${baseUrl}api/v1/Post/homeFeed?page=1&limit=20');

  //profile
  static Uri profileGridUrl = Uri.parse('${baseUrl}api/v1/Profile/getProfileGrid');
  static Uri getAllPostsOfUser = Uri.parse('${baseUrl}api/v1/Post/getAllPostsOfUser?userId=');
  static Uri getUserDetail = Uri.parse('${baseUrl}api/v1/Profile/getUserDetails');
  static Uri logoutUser = Uri.parse('${baseUrl}api/v1/User/logoutuser');
  static Uri uploadProfilePic = Uri.parse('${baseUrl}api/v1/Profile/uploadProfilePic');

  //product
  static Uri addNewProduct = Uri.parse('${baseUrl}api/v1/Marketplace/addNewProduct');
  static Uri getAllProducts = Uri.parse('${baseUrl}api/v1/Marketplace/getAllProducts');

  //story
  static Uri addStory = Uri.parse('${baseUrl}api/v1/story/addNewStory');

  //search
  static Uri searchApi = Uri.parse('${baseUrl}api/v1/Search/searchUser');

  //Notification
  static Uri checkNotifications = Uri.parse('${baseUrl}api/v1/Profile/hasNotifications');
  static Uri getNotification = Uri.parse('${baseUrl}api/v1/Profile/notifications');

  //bookmark
  static Uri addBookmark = Uri.parse('${baseUrl}api/v1/Post/addBookmark');

  //chat
  static Uri chatList = Uri.parse('${baseUrl}api/v1/chat/screen');

}