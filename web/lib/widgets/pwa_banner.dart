import 'package:balzanewsweb/core/resources.dart';
import 'package:balzanewsweb/core/size.dart';
import 'package:flutter/material.dart';

class PwaInstallBanner extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onInstall;

  const PwaInstallBanner({
    super.key,
    required this.onClose,
    required this.onInstall,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: AppThemes.borderColor,
              width: 1
            )
          )
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Close icon
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: onClose,
            ),

            // App icon
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 12),
              child: Image.network(
                '/logo.png',
                width: 40,
                height: 40,
              ),
            ),
            Expanded(
              child: Text('앱으로 편리하게 이용해보세요!',
                  style: AppStyles.w700.copyWith(
                    fontSize: 16.fs
                  )),
            ),
            // Install button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppThemes.pointColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: onInstall,
              child: Text('설치', style: AppStyles.w700.copyWith(
                    fontSize: 16.fs,
                    color: Colors.white
              )),
            )
          ],
        ),
      ),
    );
  }
}
