import 'package:flutter/material.dart';

typedef ReviewCallback<T> = Function(T rate);

class AlertUtils {
  static showPickerModal({
    required BuildContext context,
    VoidCallback? onFromCamera,
    VoidCallback? onFromGallery,
    VoidCallback? onRemove,
  }) {
    showModalBottomSheet(
        context: context,
        clipBehavior: Clip.hardEdge,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return SafeArea(
            child: IntrinsicHeight(
              child: Column(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera, color: Colors.grey.shade800),
                          const VerticalDivider(),
                          const Expanded(
                            child: Text(
                              'Use camera',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: onFromCamera,
                  ),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.image,
                            color: Colors.grey.shade800,
                          ),
                          const VerticalDivider(),
                          const Expanded(
                            child: Text(
                              'Choose from gallery',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w300),
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: onFromGallery,
                  ),
                  Visibility(
                    child: InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: const Row(
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
                      onTap: onRemove,
                    ),
                    visible: onRemove != null,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
