class Constants {
  ///Strings
  static String pluginName = 'navigation_controller_pkg';

  static String homePage = "sell_page"; // 'home_page';
  static String searchPage = "orders"; // 'search_page';
  static String sellPage = "wallet"; // 'sell_page';
  static String inboxPage = "products_view"; // 'inbox_page';
  static String accountPage = 'service';
  static Map<int, String> get alfaPages => {
        0: homePage,
        1: searchPage,
        2: sellPage,
        3: inboxPage,
        4: accountPage,
      };
}
