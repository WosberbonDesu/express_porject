import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:image_picker/image_picker.dart';
import '../../components/main_components.dart';
import '../../components/profile_cmp.dart';
import '../../constants/enums/dialog_enums.dart';
import '../../constants/styles/colors.dart';
import '../../constants/styles/text_styles.dart';
import '../../providers/appstate.dart';
import '../../utilities/helpers.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;
  changeLoading() => setState(() => isLoading = !isLoading);

  bool isImageLoading = false;

  changeImageLoading() => setState(() => isImageLoading = !isImageLoading);

  XFile? image;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? buildCircularProgress()
          : Consumer<AppState>(
              builder: (context, app, child) => Padding(
                padding: const EdgeInsets.only(top: 40),
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: PersonalColors.grey1)),
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: isImageLoading
                                      ? buildCircularProgress()
                                      : GestureDetector(
                                          onTap: () async {
                                            var returnType =
                                                await ppModal(context, app);

                                            changeImageLoading();
                                            if (returnType == "delete") {
                                              await app.removeUserImage(
                                                  userID: app.user!.uid,
                                                  context: context);
                                            } else if (returnType is XFile) {
                                              await app.addUserImage(
                                                  comuser: app.user!,
                                                  image: returnType,
                                                  context: context);
                                            }
                                            changeImageLoading();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: PersonalColors.blue,
                                                  //
                                                  width: 3),
                                              color: PersonalColors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            child: image != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    child: Image.file(
                                                      File(image!.path),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  )
                                                : app.user!.imageURL != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        child:
                                                            CachedNetworkImage(
                                                                imageUrl: app
                                                                    .user!
                                                                    .imageURL!,
                                                                height: 100,
                                                                width: 100,
                                                                fit: BoxFit
                                                                    .cover,
                                                                progressIndicatorBuilder:
                                                                    (context,
                                                                            url,
                                                                            progress) =>
                                                                        const Center(
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )),
                                                      )
                                                    : const Icon(
                                                        FeatherIcons.users,
                                                        color: Colors.white,
                                                      ),
                                          ),
                                        )),
                              const SizedBox(width: 20),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    app.user!.name,
                                    style: PersonalTStyles.w500s16B,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Mevcut Durum: " +
                                        app.user!.currentBudget
                                            .toStringAsFixed(2) +
                                        " ₺",
                                    style: app.user!.currentBudget < 0
                                        ? PersonalTStyles.w500s14BItalic
                                            .copyWith(
                                                color: PersonalColors.softRed)
                                        : PersonalTStyles.w500s14BItalic
                                            .copyWith(
                                                color: PersonalColors.green),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        profileRowButtons(
                            context: context,
                            label: "Ad Soyad Düzenle",
                            route: () => DialogEnum.name
                                .dialogMethod(context: context, app: app)),
                        profileRowButtons(
                            context: context,
                            label: "Tel. No Düzenle",
                            route: () => DialogEnum.phone
                                .dialogMethod(context: context, app: app)),
                        profileRowButtons(
                            context: context,
                            label: "Harcama Limiti Düzenle",
                            route: () => DialogEnum.limit
                                .dialogMethod(context: context, app: app)),
                        profileRowButtons(
                            context: context,
                            label: "İstek, Şikayet ve Talep Formu",
                            route: () => suggestionPage(
                                  context: context,
                                  label: "İstek, Şikayet ve Talep Formu",
                                  app: app,
                                )),
                        profileRowButtons(
                            context: context,
                            label: "Şifreni Değiştir",
                            route: () => DialogEnum.password
                                .dialogMethod(context: context, app: app)),
                        const Spacer(),
                        buildSignOut(context, app),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  buildSignOut(BuildContext context, AppState app) {
    return GestureDetector(
      onTap: () async {
        var returnBool = await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Uyarı"),
            content: const Text("""Çıkış yapmak istediğinize emin misiniz?"""),
            actions: [
              buildDialogActionButton(
                onPressed: () => Navigator.of(context).pop(true),
                title: "Evet",
              ),
              buildDialogActionButton(
                onPressed: () => Navigator.of(context).pop(false),
                title: "Hayır",
              ),
            ],
          ),
        );
        changeLoading();

        if (returnBool) {
          await app.signOut();
        }
        changeLoading();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        width: Provider.of<AppState>(context, listen: false).queryWidth - 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            color: PersonalColors.grey3),
        child: Stack(
          alignment: Alignment.center,
          children: const [
            Positioned(
              child: Icon(
                FeatherIcons.logOut,
                color: PersonalColors.blue,
              ),
              left: 20,
            ),
            Text(
              "Çıkış Yap",
              style: PersonalTStyles.w500s18BL,
            ),
          ],
        ),
      ),
    );
  }

  ppModal(BuildContext context, AppState app) async {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 28.0),
          child: SizedBox(
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () async {
                      image = await loadImage(ImageSource.gallery);
                      setState(() {});
                      Navigator.of(context).pop(image);
                    },
                    child: const Text("Galeriden Ekle")),
                const Divider(),
                GestureDetector(
                    onTap: () async {
                      image = await loadImage(ImageSource.camera);
                      setState(() {});
                      Navigator.of(context).pop(image);
                    },
                    child: const Text("Fotoğraf Çek")),
                const Divider(),
                if (app.user!.imageURL != null || image != null)
                  GestureDetector(
                      onTap: () {
                        setState(() => image = null);
                        Navigator.pop(context, "delete");
                      },
                      child: const Text("Fotoğrafı Sil")),
              ],
            ),
          ),
        );
      },
    );
  }
}
