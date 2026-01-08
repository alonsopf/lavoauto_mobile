import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/presentation/common_widgets/image_.dart';
import 'package:lavoauto/utils/image_utils.dart';

class ProfileImageWidget extends StatefulWidget {
  final double height;
  final double width;
  final double borderRadius;
  final String? networkImageUrl;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const ProfileImageWidget({
    super.key,
    this.height = 100.0,
    this.width = 100.0,
    this.borderRadius = 50.0,
    this.networkImageUrl,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  File? _localImageFile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocalImage();
  }

  Future<void> _loadLocalImage() async {
    try {
      final localFile = await ImageUtils.getLocalProfileImageFile();
      if (mounted) {
        setState(() {
          _localImageFile = localFile;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localImageFile = null;
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildImageContent() {
    // Priority 1: Local image file
    if (_localImageFile != null && _localImageFile!.existsSync()) {
      return Image.file(
        _localImageFile!,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      );
    }
    
    // Priority 2: Network image URL
    if (widget.networkImageUrl != null && widget.networkImageUrl!.isNotEmpty) {
      return Image.network(
        widget.networkImageUrl!,
        height: widget.height,
        width: widget.width,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          );
        },
      );
    }
    
    // Priority 3: Placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return ImagesPng.assetPNG(
      Assets.placeholderUserPhoto,
      height: widget.height,
      width: widget.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        ),
      );
    }

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: _buildImageContent(),
    );

    if (widget.showBorder) {
      imageWidget = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

/// Circular profile image widget for common use cases
class CircularProfileImage extends StatelessWidget {
  final double radius;
  final String? networkImageUrl;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const CircularProfileImage({
    super.key,
    this.radius = 50.0,
    this.networkImageUrl,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileImageWidget(
      height: radius * 2,
      width: radius * 2,
      borderRadius: radius,
      networkImageUrl: networkImageUrl,
      showBorder: showBorder,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }
}

/// Small profile image for app bars and menus
class SmallProfileImage extends StatelessWidget {
  final double size;
  final String? networkImageUrl;

  const SmallProfileImage({
    super.key,
    this.size = 40.0,
    this.networkImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileImageWidget(
      height: size,
      width: size,
      borderRadius: size / 2,
      networkImageUrl: networkImageUrl,
      showBorder: true,
      borderColor: Colors.white,
      borderWidth: 1.0,
    );
  }
}

/// Header profile image that connects to UserInfoBloc for logged-in user
class HeaderProfileImage extends StatelessWidget {
  final double size;

  const HeaderProfileImage({
    super.key,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserInfoBloc, UserInfoState>(
      listener: (context, state) {
        debugPrint("🖼️ HeaderProfileImage LISTENER - State changed: $state");
        if (state is UserInfoSuccess) {
          debugPrint("🖼️ HeaderProfileImage LISTENER - Success with imageUrl: ${state.userWorkerInfo?.data?.fotoUrl}");
        }
      },
      builder: (context, state) {
        String? imageUrl;
        
        debugPrint("🖼️ HeaderProfileImage BUILDER - Current state: $state");
        debugPrint("🖼️ HeaderProfileImage BUILDER - State type: ${state.runtimeType}");
        
        if (state is UserInfoSuccess) {
          imageUrl = state.userWorkerInfo?.data?.fotoUrl;
          debugPrint("🖼️ HeaderProfileImage BUILDER - UserInfoSuccess with imageUrl: $imageUrl");
          debugPrint("🖼️ HeaderProfileImage BUILDER - Full userWorkerInfo: ${state.userWorkerInfo?.toJson()}");
        } else if (state is UserInfoFailure) {
          debugPrint("🖼️ HeaderProfileImage BUILDER - UserInfoFailure: ${state.error}");
        } else if (state is UserInfoInitial) {
          debugPrint("🖼️ HeaderProfileImage BUILDER - UserInfoInitial - no data loaded yet");
        } else if (state is UserInfoLoading) {
          debugPrint("🖼️ HeaderProfileImage BUILDER - UserInfoLoading - data is loading");
        } else {
          debugPrint("🖼️ HeaderProfileImage BUILDER - Unknown state: $state");
        }
        
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300], // Background color for loading/error
              image: imageUrl != null && imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      onError: (exception, stackTrace) {
                        debugPrint("🖼️ Error loading image from URL '$imageUrl': $exception");
                      },
                    )
                  : null,
            ),
            child: imageUrl == null || imageUrl.isEmpty
                ? Icon(
                    Icons.person,
                    size: size * 0.6,
                    color: Colors.grey[600],
                  )
                : null,
          ),
        );
      },
    );
  }
} 