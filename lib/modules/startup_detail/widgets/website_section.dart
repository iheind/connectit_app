import 'package:connectit_app/modules/startup_detail/utils/constants.dart';
import 'package:connectit_app/utils/url_utils.dart';
import 'package:connectit_app/widgets/SectionContainer.dart';
import 'package:connectit_app/widgets/header.dart';
import 'package:flutter/material.dart';

class WebsiteSection extends StatelessWidget {
  String url;

  WebsiteSection(this.url);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        UrlUtils.launchURL(url);
      },
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Header("WEBSITE"),
            Text(url),
            SizedBox(
              height: Constants.sectionVPadding,
            ),
          ],
        ),
      ),
    );
  }
}
