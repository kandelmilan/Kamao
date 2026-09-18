import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/core/core.dart';
import 'package:kamao/src/auth/auth.dart';
import 'package:kamao/src/home/domain/usecase/get_app_config_usecase.dart';

class EditProfileController extends GetxController {
  EditProfileController(
    this._getCreatorProfileUseCase,
    this._updateProfileUseCase,
    this._getAppConfigUseCase,
  );

  final GetCreatorProfileUseCase _getCreatorProfileUseCase;
  final UpdateProfileUseCase _updateProfileUseCase;
  final GetAppConfigUseCase? _getAppConfigUseCase;

  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final genderController = TextEditingController();
  final countryController = TextEditingController();
  final cityController = TextEditingController();
  final addressController = TextEditingController();
  final shortDescriptionController = TextEditingController();

  final Rxn<DateTime> dateOfBirth = Rxn<DateTime>();
  final selectedCategories = <String>[].obs;
  final availableCategories = <String>[].obs;

  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final RxnString fieldError = RxnString();

  String get dateOfBirthLabel {
    final dob = dateOfBirth.value;
    if (dob == null) return '';
    return DateFormat('yyyy-MM-dd').format(dob);
  }

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    isLoading.value = true;
    await Future.wait([
      _loadProfile(),
      _loadCategories(),
    ]);
    isLoading.value = false;
  }

  Future<void> _loadProfile() async {
    // Prefer already-loaded profile for instant fill, then refresh.
    if (Get.isRegistered<ProfileController>()) {
      final existing = Get.find<ProfileController>().profile.value?.user;
      if (existing != null) _applyUser(existing);
    }

    final result = await _getCreatorProfileUseCase(const NoParams());
    result.fold(
      (failure) => fieldError.value = failure.message,
      (profile) => _applyUser(profile.user),
    );
  }

  Future<void> _loadCategories() async {
    final usecase = _getAppConfigUseCase;
    if (usecase == null) return;
    final result = await usecase(const NoParams());
    result.fold(
      (_) {},
      (config) => availableCategories.assignAll(config.brandCategories),
    );
  }

  void _applyUser(ProfileUserEntity user) {
    emailController.text = user.email;
    userNameController.text = user.userName;
    fullNameController.text = user.fullName;
    phoneController.text = user.phone ?? '';
    genderController.text = user.gender?.trim() ?? '';
    countryController.text = user.country ?? '';
    cityController.text = user.city ?? '';
    addressController.text = user.address ?? '';
    shortDescriptionController.text = user.shortDescription ?? '';
    dateOfBirth.value = user.dateOfBirth;
    selectedCategories.assignAll(user.niches);
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final now = DateTime.now();
    final initial = dateOfBirth.value ?? DateTime(now.year - 18, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isAfter(now) ? now : initial,
      firstDate: DateTime(1900),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.onboardingGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.heading,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      dateOfBirth.value = DateTime(picked.year, picked.month, picked.day);
    }
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
  }

  Future<void> submit() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final userName = userNameController.text.trim();
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final selectedGender = genderController.text.trim();
    final country = countryController.text.trim();
    final city = cityController.text.trim();
    final address = addressController.text.trim();
    final shortDescription = shortDescriptionController.text.trim();

    if (userName.isEmpty) {
      fieldError.value = 'Please enter a username.';
      return;
    }
    if (fullName.isEmpty) {
      fieldError.value = 'Please enter your full name.';
      return;
    }
    if (dateOfBirth.value == null) {
      fieldError.value = 'Please select your date of birth.';
      return;
    }
    if (selectedGender.isEmpty) {
      fieldError.value = 'Please enter your gender.';
      return;
    }
    if (selectedCategories.isEmpty) {
      fieldError.value = 'Please select at least one category.';
      return;
    }

    fieldError.value = null;
    isSubmitting.value = true;

    final dob = dateOfBirth.value!;
    final dateOnly = DateFormat('yyyy-MM-dd').format(dob);

    final result = await _updateProfileUseCase(
      Params(
        data: UpdateProfileRequestEntity(
          email: emailController.text.trim(),
          userName: userName,
          fullName: fullName,
          phone: phone,
          dateOfBirth: dateOnly,
          country: country,
          city: city,
          address: address,
          gender: selectedGender,
          shortDescription: shortDescription,
          niches: selectedCategories.toList(),
        ),
      ),
    );

    result.fold(
      (failure) {
        fieldError.value = failure.message;
        Get.snackbar(
          "Couldn't update profile",
          failure.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: const Color(0xFF353037),
          margin: const EdgeInsets.all(16),
        );
      },
      (_) async {
        if (Get.isRegistered<ProfileController>()) {
          await Get.find<ProfileController>().refreshProfile();
        }
        if (Get.isRegistered<AuthController>()) {
          await Get.find<AuthController>().getMe();
        }
        Get.back();
        Get.snackbar(
          'Profile updated',
          'Your profile has been saved.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.white,
          colorText: const Color(0xFF353037),
          margin: const EdgeInsets.all(16),
        );
      },
    );

    isSubmitting.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    userNameController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    genderController.dispose();
    countryController.dispose();
    cityController.dispose();
    addressController.dispose();
    shortDescriptionController.dispose();
    super.onClose();
  }
}
