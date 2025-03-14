import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../texts/app_text.dart';
import 'coloors.dart';

class DoctorInfo extends StatelessWidget {
  final double height;
  final double width;
  final String name;
  final String address;
  final String url;
  final List<String> specializations;

  const DoctorInfo({
    super.key,
    required this.height,
    required this.width,
    required this.name,
    required this.address,
    required this.specializations,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: height * 0.06,
                        backgroundImage: url.isNotEmpty
                            ? CachedNetworkImageProvider(url)
                            : AssetImage('assets/illustrations/doctor-3d.png')
                                as ImageProvider, // Fallback image
                      ),
                      Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(Icons.verified_sharp,
                              color: AppColors.primaryColor,
                              size: height * 0.04)),
                    ],
                  ),
                  SizedBox(width: width * 0.04),
                  Expanded(
                    // Wrap this Column in an Expanded widget
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.01),
                        Text(
                          "Dr. $name",
                          style: AppTextStyle.body
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: height * 0.01),
                        Wrap(
                          children: [
                            Text(specializations.map((e) => e).join(", "),
                                style: AppTextStyle.caption),
                          ],
                        ),
                        SizedBox(height: height * 0.01),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.primaryColor,
                            ),
                            SizedBox(
                              width: width * 0.4,
                              child: Text(
                                address,
                                style: AppTextStyle.caption,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.map_rounded,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
