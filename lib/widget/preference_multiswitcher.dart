import 'package:flutter/material.dart';
import 'package:good_movie_fan/preferences/preference_switcher_data.dart';
import 'package:good_movie_fan/strings.dart';

class PreferenceMultiSwitcher extends StatefulWidget {
  String title;
  PreferenceSwitcherData Function(BuildContext) preferenceSelector;
  PreferenceSwitcherData Function(BuildContext) preferenceReader;
  void Function(int) preferenceSetter;
  List<PreferenceSwitcherData> values;

  PreferenceMultiSwitcher(
      {@required this.title,
      @required this.preferenceSelector,
      @required this.preferenceReader,
      @required this.preferenceSetter,
      @required this.values});
  @override
  _PreferenceMultiSwitcherState createState() =>
      _PreferenceMultiSwitcherState();
}

class _PreferenceMultiSwitcherState extends State<PreferenceMultiSwitcher> {
  bool _switchValueExpanded = false;
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return _switchValueExpanded
        ? Expanded(
            child: SingleChildScrollView(
              child: ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  _switcher(),
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      child: _expandedValue()),
                ],
              ),
            ),
          )
        : _switcher();
  }

  Widget _switcher() {
    return ListTile(
      title: Text(
        widget.title,
      ),
      subtitle: _multiswitchButton(),
      trailing: IconButton(
        icon: Icon(
          _switchValueExpanded ? Icons.expand_less : Icons.expand_more,
          color: _theme.textTheme.headline5.color,
        ),
        onPressed: () {
          setState(() {
            _switchValueExpanded = !_switchValueExpanded;
          });
        },
      ),
    );
  }

  Widget _multiswitchButton() {
    var currentValue = widget.preferenceSelector(context);

    return Tooltip(
      message: Strings.multiswitcherTip,
      child: ElevatedButton(
        child: Row(
          children: [
            Icon(currentValue.icon),
            const SizedBox(width: 15.0),
            Text(
              currentValue.name,
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        onPressed: _switchValue,
      ),
    );
  }

  Widget _expandedValue() {
    var currentValue = widget.preferenceSelector(context);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.values.length,
      itemBuilder: (context, index) => _radioListTile(
        value: widget.values[index].value,
        groupValue: currentValue.value,
        title: widget.values[index].name,
        hint: widget.values[index].hint,
      ),
    );
  }

  Widget _radioListTile(
      {@required int value,
      @required int groupValue,
      @required String title,
      @required String hint}) {
    return RadioListTile(
      value: value,
      groupValue: groupValue,
      title: Text(title),
      subtitle: Text(hint),
      onChanged: (newValue) => widget.preferenceSetter(newValue),
    );
  }

  void _switchValue() {
    int currentValueIndex = widget.preferenceReader(context).value;
    var nextValue =
        widget.values[++currentValueIndex % widget.values.length].value;
    widget.preferenceSetter(nextValue);
  }
}
