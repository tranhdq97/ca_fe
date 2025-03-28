import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _clientFormKey = GlobalKey<FormState>();
  final _storeFormKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clientLogin() async {
    if (_clientFormKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final success = await authController.loginClient(_phoneController.text);

      if (success && mounted) {
        // Điều hướng đến trang chính khi đăng nhập thành công
        // Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  void _storeLogin() async {
    if (_storeFormKey.currentState!.validate()) {
      final authController = Provider.of<AuthController>(
        context,
        listen: false,
      );
      final success = await authController.loginStore(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        // Điều hướng đến trang quản lý cửa hàng
        // Navigator.pushReplacementNamed(context, '/store-dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng nhập'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [Tab(text: 'KHÁCH HÀNG'), Tab(text: 'NHÂN VIÊN')],
        ),
      ),
      body: Consumer<AuthController>(
        builder: (context, authController, child) {
          if (authController.isLoading) {
            return Center(child: LoadingIndicator());
          }

          if (authController.error != null) {
            // Hiển thị thông báo lỗi
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(authController.error!),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }

          return TabBarView(
            controller: _tabController,
            children: [
              // Tab Khách hàng (Client Mode)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _clientFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Đăng nhập bằng số điện thoại',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      AppTextField(
                        controller: _phoneController,
                        label: 'Số điện thoại',
                        prefixIcon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: Validators.validatePhone,
                      ),
                      SizedBox(height: 20),
                      AppButton(text: 'ĐĂNG NHẬP', onPressed: _clientLogin),
                    ],
                  ),
                ),
              ),

              // Tab Nhân viên (Store Mode)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _storeFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Đăng nhập tài khoản nhân viên',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email',
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      SizedBox(height: 16),
                      AppTextField(
                        controller: _passwordController,
                        label: 'Mật khẩu',
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                      SizedBox(height: 20),
                      AppButton(text: 'ĐĂNG NHẬP', onPressed: _storeLogin),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
