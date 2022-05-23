import 'package:flutter/material.dart';

class FaqView extends StatelessWidget {
  const FaqView({Key key}) : super(key: key);

  static const String _title = 'FAQ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Title: _title,
      appBar: AppBar(title: const Text(_title)),
      body: const MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool _customTileExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const ExpansionTile(
          title: Text('What is sustainable food?'),
          //  subtitle: Text('Trailing expansion arrow icon'),
          children: <Widget>[
            ListTile(title: Text('Answer number 1')),
          ],
        ),
        ExpansionTile(
          title: const Text('Which products have a high carbon foodprint?'),
          //   subtitle: const Text('Custom expansion arrow icon'),

          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('Answer number  2')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
        ExpansionTile(
          title: const Text('Easy swap recommendations'),
          //   subtitle: const Text('Custom expansion arrow icon'),

          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('Answer number  3')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
        ExpansionTile(
          title: const Text('is BIO more sustainable?'),
          //   subtitle: const Text('Custom expansion arrow icon'),

          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('Answer number  4')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
        ExpansionTile(
          title: const Text('What products are high in protein?'),
          //   subtitle: const Text('Custom expansion arrow icon'),

          trailing: Icon(
            _customTileExpanded
                ? Icons.arrow_drop_down_circle
                : Icons.arrow_drop_down,
          ),
          children: const <Widget>[
            ListTile(title: Text('Answer number  2')),
          ],
          onExpansionChanged: (bool expanded) {
            setState(() => _customTileExpanded = expanded);
          },
        ),
        // const ExpansionTile(
        //   title: Text('Question 3'),
        //   subtitle: Text('Leading expansion arrow icon'),
        //   controlAffinity: ListTileControlAffinity.leading,
        //   children: <Widget>[
        //     ListTile(title: Text('This is tile number 3')),
        //   ],
        // ),
      ],
    );
  }
}
