import 'package:flutter/material.dart';
import 'package:good_movie_fan/model/catalog.dart';
import 'package:good_movie_fan/strings.dart';
import 'package:provider/provider.dart';

class SearchDialog extends StatefulWidget {
  @override
  _SearchDialogState createState() => _SearchDialogState();
}

class _SearchDialogState extends State<SearchDialog> {
  static const _yearsNumber = 100;
  static const _voteNumber = 10;
  static final _validCastListCharacters = RegExp(r"^[0-9,]+$");
  static final _currentYear = DateTime.now().year;

  //TODO init from SearchCriteria
  int _year = _currentYear;
  int _vote = 7;
  String _castList = '';
  bool _checkedYear = false;
  bool _checkedVote = false;
  bool _checkedCast = false;
  String _sortBy = Strings.popularitySortBy;
  final _formKey = GlobalKey<FormState>();
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _filterByYear(),
                _filterByVote(),
                _filterByCast(),
                //TODO filter by genres
                const SizedBox(
                  height: 20.0,
                ),
                _sort(),
                _buttons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterByYear() {
    return _filterProperty(
        checked: _checkedYear,
        toggleCheck: (value) => _checkedYear = value,
        body: _dropdownFilterProperty(
            enabled: _checkedYear,
            selectedValue: _year,
            valuesNumber: _yearsNumber,
            valueGenerator: (int index) => _currentYear - index,
            dropdownItem: (value) => Text(value.toString()),
            onItemSelected: (value) => setState(() => _year = value)),
        hint: Strings.filterYearHint,
        icon: Icons.date_range);
  }

  Widget _filterByVote() {
    return _filterProperty(
        checked: _checkedVote,
        toggleCheck: (value) => _checkedVote = value,
        body: _dropdownFilterProperty(
            enabled: _checkedVote,
            selectedValue: _vote,
            valuesNumber: _voteNumber,
            valueGenerator: (int index) => ++index,
            dropdownItem: (value) => Row(
                  children: <Widget>[
                    Icon(_getIconForVote(value)),
                    Text(value.toString()),
                  ],
                ),
            onItemSelected: (value) => setState(() => _vote = value)),
        hint: Strings.voteAverageTitle,
        icon: Icons.star);
  }

  Widget _filterByCast() {
    return _filterProperty(
        checked: _checkedCast,
        toggleCheck: (value) => _checkedCast = value,
        body: TextFormField(
          enabled: _checkedCast,
          decoration: InputDecoration(
            helperText: Strings.filterCastHelp,
            fillColor: _checkedCast
                ? _theme.inputDecorationTheme.fillColor
                : Colors.black12,
          ),
          onChanged: _checkedCast
              ? (text) {
                  setState(() => _castList = text);
                }
              : null,
          validator: (value) {
            if (_checkedCast && !_validCastListCharacters.hasMatch(value)) {
              return Strings.filterCastInvalid;
            }
            return null;
          },
        ),
        hint: Strings.filterCastHint,
        icon: Icons.people);
  }

  Widget _filterProperty(
      {@required bool checked,
      @required Function(bool) toggleCheck,
      @required Widget body,
      @required String hint,
      @required IconData icon}) {
    return CheckboxListTile(
      value: checked,
      onChanged: (value) {
        setState(() => toggleCheck(value));
      },
      title: body,
      subtitle: Text(hint),
      secondary: Icon(icon, color: _theme.iconTheme.color),
    );
  }

  Widget _dropdownFilterProperty(
      {@required bool enabled,
      @required int selectedValue,
      @required int valuesNumber,
      @required Function(int) valueGenerator,
      @required Widget Function(int) dropdownItem,
      @required Function(int) onItemSelected}) {
    return DropdownButtonFormField(
      items:
          List<int>.generate(valuesNumber, (int index) => valueGenerator(index))
              .map((int value) {
        return new DropdownMenuItem(
          value: value,
          child: dropdownItem(value),
        );
      }).toList(),
      onChanged: enabled
          ? (newValue) {
              onItemSelected(newValue);
            }
          : null,
      value: selectedValue,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10.0),
        filled: true,
        fillColor:
            enabled ? _theme.inputDecorationTheme.fillColor : Colors.black12,
      ),
    );
  }

  Widget _sort() {
    return ListTile(
        title: DropdownButtonFormField(
          items: [
            Strings.popularitySortBy,
            Strings.releaseDateSortBy,
            Strings.titleSortBy,
            Strings.voteAverageSortBy
          ].map((String sortBy) {
            return new DropdownMenuItem(
              value: sortBy,
              child: Text(sortBy),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() => _sortBy = newValue);
          },
          value: _sortBy,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10.0),
          ),
        ),
        subtitle: Text(Strings.sortByTitle),
        leading: Icon(Icons.sort_by_alpha, color: _theme.iconTheme.color));
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          color: _theme.bottomNavigationBarTheme.backgroundColor,
          icon: Icon(Icons.cancel_outlined),
          onPressed: () => Navigator.of(context).pop(),
        ),
        IconButton(
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.check_circle_outline),
          onPressed: () {
            if (_formKey.currentState.validate()) {
              _apply();
              Navigator.of(context).pop();
            }
          },
        ),
      ],
    );
  }

  void _apply() {
    final catalog = context.read<Catalog>();
    catalog.searchCriteria = SearchCriteria(
      filterByVote: _checkedVote,
      filterByYear: _checkedYear,
      filterByCast: _checkedCast,
      filterVote: _vote,
      filterYear: _year,
      filterCastList: _castList,
      sortBy: _sortBy,
    );
  }

  IconData _getIconForVote(int vote) {
    assert(vote >= 0 && vote <= 10);
    if (vote >= 8) {
      return Icons.star;
    }
    if (vote >= 4) {
      return Icons.star_half;
    }
    return Icons.star_border;
  }
}
