import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_profile.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/custom_button.dart';
import '../home/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedRole = UserRole.individual;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text.trim(),
      role: _selectedRole,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account successfully created! Welcome to Waste2Worth.'),
          backgroundColor: AppColors.primary,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create Account',
                  style: AppTypography.displayLarge.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 6),
                Text(
                  'Join the Waste2Worth circular economy ecosystem.',
                  style: AppTypography.bodyMedium,
                ),

                const SizedBox(height: 24),

                // Name
                Text('Full Name', style: AppTypography.titleSmall),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? 'Please enter your name'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Anuj Sharma',
                    prefixIcon: Icon(Icons.person_outline, size: 20),
                  ),
                ),

                const SizedBox(height: 16),

                // Email
                Text('Email Address', style: AppTypography.titleSmall),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => val == null || !val.contains('@')
                      ? 'Please enter a valid email'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. anuj@waste2worth.org',
                    prefixIcon: Icon(Icons.email_outlined, size: 20),
                  ),
                ),

                const SizedBox(height: 16),

                // Phone
                Text('Phone Number', style: AppTypography.titleSmall),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => val == null || val.trim().length < 10
                      ? 'Please enter a valid 10-digit mobile number'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'e.g. +91 98765 43210',
                    prefixIcon: Icon(Icons.phone_outlined, size: 20),
                  ),
                ),

                const SizedBox(height: 16),

                // Role Selector
                Text('I am registering as a', style: AppTypography.titleSmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleCard(
                        role: UserRole.individual,
                        title: 'Recycler',
                        subtitle: 'Household & DIY',
                        icon: Icons.person_rounded,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildRoleCard(
                        role: UserRole.dealer,
                        title: 'Scrap Dealer',
                        subtitle: 'Kabadiwala / Center',
                        icon: Icons.storefront_rounded,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Password
                Text('Password', style: AppTypography.titleSmall),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: (val) => val == null || val.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                  decoration: const InputDecoration(
                    hintText: 'Create a secure password',
                    prefixIcon: Icon(Icons.lock_outline, size: 20),
                  ),
                ),

                const SizedBox(height: 28),

                CustomButton(
                  text: 'Create Account',
                  isLoading: auth.isLoading,
                  onPressed: _handleRegister,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required UserRole role,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;
    return InkWell(
      onTap: () => setState(() => _selectedRole = role),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primaryDark : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
