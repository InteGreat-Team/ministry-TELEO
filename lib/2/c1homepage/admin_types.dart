enum AdminView {
  home,
  profile,
  settings,
  accountSettings,
  securitySettings,
  changeEmail,
  changePassword,
  changePhone,
  authenticator,
  events,
  community,
  posts,
  setRoles,
  faqs,
  notificationSettings,
  massSchedule,
  reportIssue,
  termsAndConditions,
  contactUs,
}

class AdminData {
  String churchName;
  String posts;
  String following;
  String followers;
  String loginActivity;
  String loginActivityPercentage;
  String dailyFollows;
  String dailyFollowsPercentage;
  String dailyVisits;
  String dailyVisitsPercentage;
  String bookings;
  String bookingsPercentage;
  String email;
  String phoneNumber;
  String password;

  AdminData({
    required this.churchName,
    required this.posts,
    required this.following,
    required this.followers,
    required this.loginActivity,
    required this.loginActivityPercentage,
    required this.dailyFollows,
    required this.dailyFollowsPercentage,
    required this.dailyVisits,
    required this.dailyVisitsPercentage,
    required this.bookings,
    required this.bookingsPercentage,
    required this.email,
    required this.phoneNumber,
    required this.password,
  });
}
