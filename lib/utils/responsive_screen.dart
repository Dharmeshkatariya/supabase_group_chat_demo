import 'package:get/get.dart';
import 'export.dart';

class Screen {
  static const double mobile = 300;
  static const double tablet = 600;
  static const double desktop = 1200;

  static bool get isDesktop {
    var context = Get.context!;
    return MediaQuery.of(context).size.width >= desktop;
  }

  static bool get isTablet {
    var context = Get.context!;
    return MediaQuery.of(context).size.width >= tablet &&
        MediaQuery.of(context).size.width < desktop;
  }

  static bool get isMobile {
    var context = Get.context!;
    return MediaQuery.of(context).size.width < tablet;
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= Screen.desktop) {
          return desktop;
        } else if (constraints.maxWidth >= Screen.tablet) {
          return tablet;
        } else {
          return mobile;
        }
      },
    );
  }
}
