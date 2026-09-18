import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kamao/app/app.dart';
import 'package:kamao/src/auth/presentation/controllers/edit_profile_controller.dart';
import 'package:kamao/src/help_support/presentation/widgets/support_ui.dart';
import 'package:remixicon/remixicon.dart';

/// Edit creator profile — email read-only; niches shown as categories.
class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 220,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.onboardingBgTop,
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const _EditProfileHeader(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        24 + (bottomInset > 0 ? 12 : 0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFF2F5F9)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A1A153B),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _LabeledField(
                              label: 'EMAIL',
                              child: TextField(
                                controller: controller.emailController,
                                readOnly: true,
                                enableInteractiveSelection: false,
                                style: const TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF6E6971),
                                ),
                                decoration: supportInputDecoration(
                                  hint: '',
                                  prefixIcon: const Icon(
                                    RemixIcons.mail_line,
                                    size: 18,
                                    color: Color(0xFF8A9A86),
                                  ),
                                ).copyWith(
                                  fillColor: const Color(0xFFF2F5F9),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'USERNAME',
                              child: TextField(
                                controller: controller.userNameController,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Your username',
                                  prefixIcon: const Icon(
                                    RemixIcons.user_3_line,
                                    size: 18,
                                    color: Color(0xFF8A9A86),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'FULL NAME',
                              child: TextField(
                                controller: controller.fullNameController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Full name',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'PHONE',
                              child: TextField(
                                controller: controller.phoneController,
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: '98XXXXXXXX',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'DATE OF BIRTH',
                              child: Obx(
                                () => InkWell(
                                  onTap: () =>
                                      controller.pickDateOfBirth(context),
                                  borderRadius: BorderRadius.circular(14),
                                  child: InputDecorator(
                                    decoration: supportInputDecoration(
                                      hint: 'YYYY-MM-DD',
                                      suffixIcon: const Icon(
                                        RemixIcons.calendar_line,
                                        size: 18,
                                        color: Color(0xFF8A9A86),
                                      ),
                                    ),
                                    child: Text(
                                      controller.dateOfBirthLabel.isEmpty
                                          ? 'Select date'
                                          : controller.dateOfBirthLabel,
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: controller.dateOfBirthLabel.isEmpty
                                            ? const Color(0xFF9A949E)
                                            : AppColors.heading,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'GENDER',
                              child: TextField(
                                controller: controller.genderController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Male / Female / Other',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'COUNTRY',
                              child: TextField(
                                controller: controller.countryController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Country',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'CITY',
                              child: TextField(
                                controller: controller.cityController,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'City',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'ADDRESS',
                              child: TextField(
                                controller: controller.addressController,
                                textCapitalization: TextCapitalization.sentences,
                                textInputAction: TextInputAction.next,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Street / area',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'SHORT DESCRIPTION',
                              child: TextField(
                                controller:
                                    controller.shortDescriptionController,
                                textCapitalization:
                                    TextCapitalization.sentences,
                                minLines: 3,
                                maxLines: 5,
                                style: _fieldStyle,
                                decoration: supportInputDecoration(
                                  hint: 'Tell brands about yourself',
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _LabeledField(
                              label: 'CATEGORY',
                              child: Obx(() {
                                final options =
                                    controller.availableCategories.toList();
                                final selected =
                                    controller.selectedCategories.toList();
                                if (options.isEmpty) {
                                  return const Text(
                                    'No categories available yet.',
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 13,
                                      color: AppColors.bodyGrey,
                                    ),
                                  );
                                }
                                return Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: options.map((category) {
                                    final isSelected =
                                        selected.contains(category);
                                    return FilterChip(
                                      label: Text(category),
                                      selected: isSelected,
                                      onSelected: (_) =>
                                          controller.toggleCategory(category),
                                      selectedColor: AppColors.walletButton,
                                      checkmarkColor: Colors.white,
                                      labelStyle: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.heading,
                                      ),
                                      backgroundColor:
                                          const Color(0xFFF7FAF6),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColors.walletButton
                                            : const Color(0xFFE4EBE1),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                            ),
                            Obx(() {
                              final err = controller.fieldError.value;
                              if (err == null || err.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Text(
                                  err,
                                  style: const TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFDC2626),
                                  ),
                                ),
                              );
                            }),
                            const SizedBox(height: 24),
                            Obx(() {
                              final busy = controller.isSubmitting.value;
                              return SizedBox(
                                height: 52,
                                child: ElevatedButton(
                                  onPressed:
                                      busy ? null : controller.submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.walletButton,
                                    foregroundColor: Colors.white,
                                    disabledBackgroundColor: AppColors
                                        .walletButton
                                        .withValues(alpha: 0.5),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: busy
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'Save changes',
                                          style: TextStyle(
                                            fontFamily: 'Roboto',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const _fieldStyle = TextStyle(
  fontFamily: 'Roboto',
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: AppColors.heading,
);

class _EditProfileHeader extends StatelessWidget {
  const _EditProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 12, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              RemixIcons.arrow_left_s_line,
              size: 28,
              color: AppColors.heading,
            ),
          ),
          const Expanded(
            child: Text(
              'Edit profile',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: Color(0xFF6E6971),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
