import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Current User Provider - autoDispose ekledik cache sorununu çözmek için
final currentUserProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  try {
    // AuthNotifier state'inden user'ı al
    final authState = ref.watch(authNotifierProvider);
    if (authState.user != null) {
      return authState.user;
    }
    
    // State'de yoksa API'den çek
    final authService = ref.watch(authServiceProvider);
    final user = await authService.getCurrentUser();
    return user;
  } catch (e) {
    print('❌ currentUserProvider error: $e');
    return null;
  }
});

// Is Logged In Provider - autoDispose ekledik
final isLoggedInProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    // Önce state'e bak
    final authState = ref.watch(authNotifierProvider);
    if (authState.user != null) return true;
    
    // State'de yoksa token kontrolü yap
    final authService = ref.watch(authServiceProvider);
    return await authService.isLoggedIn();
  } catch (e) {
    return false;
  }
});

// Is Admin Provider - autoDispose ekledik
final isAdminProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    final user = await ref.watch(currentUserProvider.future);
    return user?.role.toLowerCase() == 'admin';
  } catch (e) {
    return false;
  }
});

// Auth State Notifier - For managing login/logout/register states
class AuthState {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState()) {
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      state = AuthState(user: user);
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.login(email: email, password: password);
      // User state'i HEMEN güncelle
      state = AuthState(user: response.user, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> register(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final response = await _authService.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = AuthState(user: response.user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState();
  }

  Future<void> refresh() async {
    await _loadCurrentUser();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});
