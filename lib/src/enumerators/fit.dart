enum Fit {
  /// cut parts of the image that doesn't fit in the given size
  crop,

  /// preserve the entire frame and decrease the size of the image within given size
  clip,

  /// distort the image to fit the given size
  scale,

  /// preserve the entire frame and fill the rest of the requested size with black background
  fill,
}