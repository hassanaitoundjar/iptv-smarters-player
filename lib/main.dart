import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Simple main function for diagnostic purposes
void main() {
  try {
    print("DEBUG: Starting simplified app");
    WidgetsFlutterBinding.ensureInitialized();
    print("DEBUG: Flutter binding initialized");
    
    // Enable system UI for visibility
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual, 
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]
    );
    print("DEBUG: System UI enabled");
    
    print("DEBUG: Running simplified app");
    runApp(const SimpleApp());
    print("DEBUG: Simple app started successfully");
  } catch (e, stackTrace) {
    print("ERROR during app initialization: $e");
    print("Stack trace: $stackTrace");
  }
}

// A very simple app for diagnostic purposes
class SimpleApp extends StatelessWidget {
  const SimpleApp({Key? key}) : super(key: key);
  final WatchingLocale watchingLocale;
  final FavoriteLocale favoriteLocale;
  const MyApp(
      {super.key,
      required this.iptv,
      required this.authApi,
      required this.watchingLocale,
      required this.favoriteLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    //Enable FullScreen - temporarily disabled for testing
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    
    // Instead, show system UI for testing
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    
    print("DEBUG: MyApp initialized, system UI enabled for testing");
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: <LogicalKeySet, Intent>{
        LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (BuildContext context) => AuthBloc(widget.authApi),
          ),
          BlocProvider<LiveCatyBloc>(
            create: (BuildContext context) => LiveCatyBloc(widget.iptv),
          ),
          BlocProvider<ChannelsBloc>(
            create: (BuildContext context) => ChannelsBloc(widget.iptv),
          ),
          BlocProvider<MovieCatyBloc>(
            create: (BuildContext context) => MovieCatyBloc(widget.iptv),
          ),
          BlocProvider<SeriesCatyBloc>(
            create: (BuildContext context) => SeriesCatyBloc(widget.iptv),
          ),
          BlocProvider<VideoCubit>(
            create: (BuildContext context) => VideoCubit(),
          ),
          BlocProvider<SettingsCubit>(
            create: (BuildContext context) => SettingsCubit(),
          ),
          BlocProvider<WatchingCubit>(
            create: (BuildContext context) =>
                WatchingCubit(widget.watchingLocale),
          ),
          BlocProvider<FavoritesCubit>(
            create: (BuildContext context) =>
                FavoritesCubit(widget.favoriteLocale),
          ),
        ],
        child: ResponsiveSizer(
          builder: (context, orient, type) {
            return GetMaterialApp(
              title: kAppName,
              // Use a simple, high-contrast theme for better visibility
              theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: Colors.blue,
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  secondary: Colors.orange,
                ),
                scaffoldBackgroundColor: Colors.white,
              ),
              debugShowCheckedModeBanner: true, // Enable debug banner for visibility
              initialRoute: "/",
              getPages: [
                GetPage(name: screenSplash, page: () => const SplashScreen()),
                GetPage(name: screenWelcome, page: () => const WelcomeScreen()),
                GetPage(name: screenIntro, page: () => const IntroScreen()),
                GetPage(
                    name: screenLiveCategories,
                    page: () => const LiveCategoriesScreen()),
                GetPage(
                    name: screenRegister, page: () => const RegisterScreen()),
                GetPage(
                    name: screenRegisterTv, page: () => const RegisterUserTv()),
                GetPage(
                    name: screenRegisterTv, page: () => const RegisterUserTv()),
                GetPage(
                    name: screenMovieCategories,
                    page: () => const MovieCategoriesScreen()),
                GetPage(
                    name: screenSeriesCategories,
                    page: () => const SeriesCategoriesScreen()),
                GetPage(
                    name: screenSettings, page: () => const SettingsScreen()),
                GetPage(
                    name: screenFavourite, page: () => const FavouriteScreen()),
                GetPage(name: screenCatchUp, page: () => const CatchUpScreen()),
              ],
            );
          },
        ),
      ),
    );
  }
}
