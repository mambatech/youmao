/// date : 2020/3/29 
/// created by william yuan

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeBanner extends StatelessWidget {
  final bannerList;
  HomeBanner(this.bannerList);

  @override
  Widget build(BuildContext context) {
    return bannerList == null
        ?
    Container(
      width: MediaQuery.of(context).size.width,
      height: 160,
      color: Colors.grey,
        margin: EdgeInsets.only(top:0),
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 100, 0, MediaQuery.of(context).size.width / 100, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset("images/launch.png", height:200, width: 200, fit: BoxFit.cover,),
                  )
              );
            },
            itemCount: 3,
            control: SwiperControl(
                iconNext: null,
                iconPrevious: null
            ),
            autoplay: true,
            scale: 0.9,
            viewportFraction: 0.9
        )
    )
        :
    Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        margin: EdgeInsets.only(top:8),
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  margin: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width / 100, 0, MediaQuery.of(context).size.width / 100, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: bannerList[index]['imageUrl'],
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.width / 3,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width / 3,
                        color: Colors.grey,
                      ),
                    ),
                  )
              );
            },
            itemCount: bannerList.length,
            control: SwiperControl(
                iconNext: null,
                iconPrevious: null
            ),
            autoplay: true,
            scale: 0.9,
            viewportFraction: 0.9
        )
    );
  }
}