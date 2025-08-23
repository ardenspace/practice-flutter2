import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Performance utilities for the TikTok Clone app
class PerformanceUtils {
  /// Debounce function to prevent excessive API calls or UI updates
  static void debounce(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    Timer? _timer;
    _timer?.cancel();
    _timer = Timer(duration, callback);
  }

  /// Lazy loading wrapper for heavy widgets
  static Widget lazyWidget({
    required Widget Function() builder,
    Widget placeholder = const SizedBox.shrink(),
  }) {
    return FutureBuilder<Widget>(
      future: Future.microtask(builder),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data!;
        }
        return placeholder;
      },
    );
  }

  /// Memory-efficient image loading with caching
  static Widget optimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return placeholder ??
            Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            const Icon(
              Icons.error_outline,
              color: Colors.grey,
            );
      },
      // Enable memory optimization
      cacheWidth: width?.toInt(),
      cacheHeight: height?.toInt(),
    );
  }

  /// Performance monitor for debug builds
  static void logPerformanceMetrics(String operation, VoidCallback callback) {
    if (kDebugMode) {
      final stopwatch = Stopwatch()..start();
      callback();
      stopwatch.stop();
      debugPrint('⚡ Performance: $operation took ${stopwatch.elapsedMilliseconds}ms');
    } else {
      callback();
    }
  }

  /// Widget recycling for list performance
  static Widget buildOptimizedListItem({
    required int index,
    required Widget Function(BuildContext context, int index) itemBuilder,
    Key? key,
  }) {
    return RepaintBoundary(
      key: key ?? ValueKey(index),
      child: Builder(
        builder: (context) => itemBuilder(context, index),
      ),
    );
  }

  /// Check if device has sufficient memory for heavy operations
  static bool get hasHighMemory {
    // This is a simplified check. In production, you might want to use
    // platform-specific methods to check actual device capabilities
    return !kIsWeb; // Assume native apps have more memory than web
  }

  /// Conditional rendering based on device capabilities
  static Widget conditionalWidget({
    required Widget highPerformanceWidget,
    required Widget lowPerformanceWidget,
  }) {
    return hasHighMemory ? highPerformanceWidget : lowPerformanceWidget;
  }

  /// Optimized scroll physics for better performance
  static ScrollPhysics get optimizedScrollPhysics {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  /// Memory-efficient text styling
  static TextStyle getOptimizedTextStyle({
    double fontSize = 14.0,
    FontWeight fontWeight = FontWeight.normal,
    Color color = Colors.black,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: fontFamily,
      // Disable expensive text features in low-end devices
      decorationThickness: kIsWeb ? null : 0,
    );
  }
}

/// Timer utility for debouncing
class Timer {
  static void Function()? _callback;
  static Future<void>? _future;

  Timer(Duration duration, void Function() callback) {
    _callback?.call(); // Cancel previous timer
    _callback = null;
    
    _future = Future.delayed(duration).then((_) {
      if (_callback == null) {
        callback();
      }
    });
    
    _callback = () {
      _future = null;
    };
  }

  void cancel() {
    _callback?.call();
    _callback = null;
  }
}