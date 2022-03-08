import 'package:flutter/material.dart';

void Navto(context, Widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => Widget));
}

void NavtoAndFinsh(context, Widget) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => Widget), (route) {
    return false;
  });
}

Widget productListItemBuilder({model, favorites, context, isOldPrice = true}) =>
    Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image.network(
            model.image!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name!,
                  style: TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      '${model.price}',
                      style: TextStyle(
                          fontSize: 12, color: Colors.lightBlueAccent),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    if (model.discount != 0 && isOldPrice)
                      Text(
                        '${model.old_price}',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                    Spacer(),
                    CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          favorites[model.id!] ? Colors.lightBlue : Colors.grey,
                      child: IconButton(
                          onPressed: () {
//                            AppCubit.get(context).editFavorit(model.id!);
                          },
                          icon: Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: Colors.white,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) {
  return AppBar(
    actions: actions,
    title: Text(title!),
    leading: IconButton(onPressed: () {}, icon: Icon(Icons.chevron_left)),
    leadingWidth: 0,
  );
}
