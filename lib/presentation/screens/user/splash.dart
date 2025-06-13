part of '../screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  goScreen(String screen) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offAndToNamed(screen);
    });
  }

  @override
  void initState() {
    super.initState();
    print("DEBUG: SplashScreen initState called");
    
    // Add a direct navigation option for testing
    Future.delayed(const Duration(seconds: 10), () {
      print("DEBUG: Forcing navigation to Welcome screen after timeout");
      Get.offAndToNamed(screenWelcome);
    });
    
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        print("DEBUG: SplashScreen post frame callback");
        
        // Temporarily allow all orientations for testing
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
        
        print("DEBUG: Getting settings code");
        context.read<SettingsCubit>().getSettingsCode();
        
        print("DEBUG: Requesting user authentication");
        context.read<AuthBloc>().add(AuthGetUser());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("width: ${MediaQuery.of(context).size.width}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        //bool isPortrait = orientation == Orientation.portrait;

        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<LiveCatyBloc>().add(GetLiveCategories());
              context.read<MovieCatyBloc>().add(GetMovieCategories());
              context.read<SeriesCatyBloc>().add(GetSeriesCategories());
              goScreen(screenWelcome);
            } else if (state is AuthFailed) {
              if (isTv(context)) {
                goScreen(screenRegisterTv);
              } else {
                //goScreen(screenRegisterTv);
                goScreen(screenIntro);
              }
            }
          },
          child: const LoadingWidget(),
        );
      }),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Use a bright background color for better visibility during testing
    return Container(
      width: getSize(context).width,
      height: getSize(context).height,
      // Use a bright color instead of the default background
      color: Colors.lightBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App logo
          Image(
            width: getSize(context).height * .22,
            height: getSize(context).height * .22,
            image: const AssetImage(kIconSplash),
          ),
          const SizedBox(height: 10),
          // App name with larger, more visible text
          Text(
            "$kAppName - TESTING",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          // Debug text to show we're on the splash screen
          Text(
            "Splash Screen - If you see this, the app is working!",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Auth state indicator
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      child: const CircularProgressIndicator(color: Colors.white),
                    ),
                    Text(
                      "Loading authentication...",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                );
              } else if (state is AuthFailed) {
                return Text(
                  "Authentication failed - will redirect soon",
                  style: TextStyle(color: Colors.white),
                );
              } else if (state is AuthSuccess) {
                return Text(
                  "Authentication successful - will redirect soon",
                  style: TextStyle(color: Colors.white),
                );
              }
              return Text(
                "Waiting for authentication state",
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ],
      ),
    );
  }
}
