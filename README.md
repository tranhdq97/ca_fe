# Ca_Fe - Ứng dụng đăng nhập hai chế độ

Ứng dụng Flutter với hai chế độ đăng nhập: Khách hàng (Client Mode) và Nhân viên (Store Mode).

## Tổng quan

- **Client Mode:** Đăng nhập bằng số điện thoại, không yêu cầu mật khẩu
- **Store Mode:** Đăng nhập bằng email và mật khẩu
- **Backend API:** http://gagaallall.pythonanywhere.com

## Cấu trúc dự án

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart
│   │   ├── api_endpoints.dart
│   │   └── api_exception.dart
│   ├── config/
│   │   └── app_config.dart
│   ├── services/
│   │   └── storage_service.dart
│   └── utils/
│       └── validators.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── controllers/
│   │       │   └── auth_controller.dart
│   │       └── screens/
│   │           └── login_screen.dart
│   └── [other features...]
├── shared/
│   └── widgets/
│       ├── app_button.dart
│       ├── app_text_field.dart
│       └── loading_indicator.dart
└── main.dart
```

## Nhiệm vụ của từng file

### Core Layer

#### API
- **api_client.dart**: Quản lý HTTP requests, xử lý responses và errors
- **api_endpoints.dart**: Định nghĩa tất cả API endpoints tập trung
- **api_exception.dart**: Định nghĩa exceptions cho API calls

#### Config
- **app_config.dart**: Quản lý cấu hình theo môi trường (dev/staging/prod)

#### Services
- **storage_service.dart**: Quản lý lưu trữ local (token, user data, login state)

#### Utils
- **validators.dart**: Hàm validate form (email, phone, password)

### Features Layer

#### Auth Feature
- **user_model.dart**: Model dữ liệu người dùng
- **auth_repository.dart**: Xử lý logic đăng nhập, kết nối API
- **auth_controller.dart**: Quản lý state đăng nhập, kết nối UI với repository
- **login_screen.dart**: UI màn hình đăng nhập với hai tab

### Shared Layer
- **app_button.dart**: Button tùy chỉnh, tái sử dụng
- **app_text_field.dart**: Text field tùy chỉnh với validation
- **loading_indicator.dart**: Component loading

### Main file
- **main.dart**: Khởi chạy ứng dụng, cấu hình toàn cục

## Luồng hoạt động

1. User nhập thông tin đăng nhập trên `login_screen.dart`
2. `auth_controller.dart` xử lý logic đăng nhập
3. `auth_repository.dart` gọi API thông qua `api_client.dart`
4. Kết quả được chuyển đổi thành `user_model.dart`
5. Token và thông tin người dùng được lưu bởi `storage_service.dart`
6. User được chuyển hướng đến màn hình tương ứng

## Cài đặt và chạy

1. Đảm bảo đã cài đặt Flutter SDK
2. Clone repository
3. Chạy `flutter pub get` để cài đặt dependencies
4. Chạy `flutter run` để khởi động ứng dụng

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.5
  shared_preferences: ^2.2.0
```

## Môi trường phát triển

Ứng dụng được thiết kế để chạy trên cả iOS và Android, hỗ trợ các phiên bản mới nhất.
