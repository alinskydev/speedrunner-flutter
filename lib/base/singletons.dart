import '/libraries/services.dart' as services;
import '/libraries/singletons.dart' as singletons;

class Singletons {
  static late singletons.Cart cart;
  static late singletons.FileStorage fileStorage;
  static late singletons.Intl intl;
  static late singletons.Settings settings;
  static late singletons.SharedStorage sharedStorage;
  static late singletons.Style style;
  static late singletons.User user;

  static Future<void> init() async {
    sharedStorage = await singletons.SharedStorage.init();
    fileStorage = await singletons.FileStorage.init();

    settings = await singletons.Settings.init();
    cart = await singletons.Cart.init();
    user = await singletons.User.init();
    style = await singletons.Style.init();

    intl = await singletons.Intl.init();
    intl.messages = await services.AppNetwork(
      uri: Uri(path: 'information/translations'),
    ).sendRequest().then((value) {
      if (value.data is Map) {
        return Map<String, Map>.from(value.data);
      } else {
        return <String, Map>{};
      }
    });
  }
}
