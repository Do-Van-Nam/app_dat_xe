enum SplashNext {
  home,
  login,
  forceUpdate,
  maintenance,
}

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashResolved extends SplashState {
  final SplashNext next;
  final String content;

  SplashResolved({
    required this.next,
    this.content = "",
  });
}

class SplashError extends SplashState {
  final String message;
  SplashError(this.message);
}
