import 'package:get/get.dart';

import '../modules/album/bindings/album_binding.dart';
import '../modules/album/views/album_view.dart';
import '../modules/audio_player/bindings/audio_player_binding.dart';
import '../modules/audio_player/views/audio_player_view.dart';
import '../modules/authentication/bindings/authentication_binding.dart';
import '../modules/authentication/views/authentication_view.dart';
import '../modules/discover/bindings/discover_binding.dart';
import '../modules/discover/views/discover_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/live/bindings/live_binding.dart';
import '../modules/live/views/live_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/offline/bindings/offline_binding.dart';
import '../modules/offline/views/offline_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/favorites/bindings/favorites_binding.dart';
import '../modules/profile/favorites/views/favorites_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/send_prayer/bindings/send_prayer_binding.dart';
import '../modules/send_prayer/views/send_prayer_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LIVE,
      page: () => const LiveView(),
      binding: LiveBinding(),
    ),
    GetPage(
      name: _Paths.ALBUM,
      page: () => const AlbumView(),
      binding: AlbumBinding(),
    ),
    GetPage(
      name: _Paths.DISCOVER,
      page: () => const DiscoverView(),
      binding: DiscoverBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const MyProfileView(),
      binding: ProfileBinding(),
      children: [
        GetPage(
          name: _Paths.FAVORITES,
          page: () => const FavoritesView(),
          binding: FavoritesBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.AUTHENTICATION,
      page: AuthenticationView.new,
      binding: AuthenticationBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_PLAYER,
      page: () => AudioPlayerView(),
      binding: AudioPlayerBinding(),
    ),
    GetPage(
      name: _Paths.OFFLINE,
      page: () => const OfflineView(),
      binding: OfflineBinding(),
    ),
  ];
}
