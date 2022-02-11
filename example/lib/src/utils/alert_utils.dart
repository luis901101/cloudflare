import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ReviewCallback<T> = Function(T rate);

class AlertUtils {
  static showImagePickerModal({
    required BuildContext context,
    VoidCallback? onImageFromCamera,
    VoidCallback? onImageFromGallery,
    VoidCallback? onImageRemove,
  }) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return SafeArea(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera, color: Colors.grey.shade800),
                          VerticalDivider(),
                          Expanded(
                            child: Text(
                              'Use camera',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: onImageFromCamera,
                  ),
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.image,
                            color: Colors.grey.shade800,
                          ),
                          VerticalDivider(),
                          Expanded(
                            child: Text(
                              'Choose from gallery',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: onImageFromGallery,
                  ),
                  Visibility(
                    child: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: Text(
                                'Remove',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w300,
                                    color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: onImageRemove,
                    ),
                    visible: onImageRemove != null,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
