import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';

class CommentItem extends StatelessWidget {
  final CommentEntity comment;
  const CommentItem({
    Key? key,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: themeData.dividerColor, width: 1),
          borderRadius: BorderRadius.circular(4)),
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(comment.title),
                  Text(comment.email, style: themeData.textTheme.caption)
                ],
              ),
              Text(
                comment.date,
                style: themeData.textTheme.caption,
              )
            ],
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            comment.content,
            style: TextStyle(height: 1.4),
          ),
        ],
      ),
    );
  }
}
