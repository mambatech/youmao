/// date : 2020/3/29 
/// created by william yuan

import 'package:flutter/material.dart';
import 'package:youmao/model/model.dart';

//宠物头信息
class PetBanner extends StatelessWidget {
  Pet mPet;
  PetBanner(this.mPet);

  @override
  Widget build(BuildContext context) {
    return
    Container(
        width: MediaQuery.of(context).size.width,
        height: 160,
        margin: EdgeInsets.only(top:8),
    );
  }
}