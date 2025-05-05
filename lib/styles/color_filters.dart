import 'dart:ui';

class ImageColorFilters {
  static const grayscale = ColorFilter.matrix(<double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const sepia = ColorFilter.matrix(<double>[
    0.393, 0.769, 0.189, 0, 0,
    0.349, 0.686, 0.168, 0, 0,
    0.272, 0.534, 0.131, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const vintage = ColorFilter.matrix(<double>[
    0.9, 0.5, 0.1, 0, 0,
    0.3, 0.7, 0.2, 0, 0,
    0.2, 0.3, 0.4, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const coolBlue = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 1.2, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const warmGlow = ColorFilter.matrix(<double>[
    1.2, 0, 0, 0, 0,
    0, 1.1, 0, 0, 0,
    0, 0, 0.9, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const fade = ColorFilter.matrix(<double>[
    0.8, 0.2, 0.2, 0, 0,
    0.2, 0.8, 0.2, 0, 0,
    0.2, 0.2, 0.8, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const highContrast = ColorFilter.matrix(<double>[
    1.5, 0, 0, 0, -0.5,
    0, 1.5, 0, 0, -0.5,
    0, 0, 1.5, 0, -0.5,
    0, 0, 0, 1, 0,
  ]);

  static const brighten = ColorFilter.matrix(<double>[
    1, 0, 0, 0, 0.1,
    0, 1, 0, 0, 0.1,
    0, 0, 1, 0, 0.1,
    0, 0, 0, 1, 0,
  ]);

  static const darken = ColorFilter.matrix(<double>[
    0.7, 0, 0, 0, 0,
    0, 0.7, 0, 0, 0,
    0, 0, 0.7, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const mono = ColorFilter.matrix(<double>[
    0.3, 0.3, 0.3, 0, 0,
    0.3, 0.3, 0.3, 0, 0,
    0.3, 0.3, 0.3, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const lofi = ColorFilter.matrix(<double>[
    1.3, 0, 0, 0, 0,
    0, 1, 0, 0, 0,
    0, 0, 0.9, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const rose = ColorFilter.matrix(<double>[
    1.1, 0.1, 0.1, 0, 0,
    0.1, 0.8, 0.1, 0, 0,
    0.4, 0.1, 1.0, 0, 0,
    0, 0, 0, 1, 0,
  ]);

  static const night = ColorFilter.matrix(<double>[
    0.7, 0.7, 1.2, 0, 0,
    0.5, 0.5, 1.0, 0, 0,
    0.4, 0.4, 0.9, 0, 0,
    0, 0, 0, 1, 0,
  ]);
}
