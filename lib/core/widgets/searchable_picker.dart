import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Modal bottom sheet with a search field on top and a filtered list.
///
/// `T` is the item type; [labelBuilder] renders the displayed string used
/// for both filtering and the row text. Pass [allowFreetext] to let the
/// user submit an arbitrary typed value that isn't in the list (used for
/// village names we don't ship a curated dataset for).
class SearchablePicker<T> extends StatefulWidget {
  const SearchablePicker({
    super.key,
    required this.title,
    required this.items,
    required this.labelBuilder,
    this.searchHint = 'Search',
    this.emptyText = 'No matches',
    this.allowFreetext = false,
    this.freetextBuilder,
  });

  final String title;
  final List<T> items;
  final String Function(T) labelBuilder;
  final String searchHint;
  final String emptyText;
  final bool allowFreetext;

  /// Called to build a `T` from a freetext value. Only used when
  /// [allowFreetext] is true and the search yields no match.
  final T Function(String query)? freetextBuilder;

  /// Convenience — opens the picker as a modal bottom sheet and returns
  /// the picked value (or `null` if dismissed).
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required List<T> items,
    required String Function(T) labelBuilder,
    String searchHint = 'Search',
    String emptyText = 'No matches',
    bool allowFreetext = false,
    T Function(String query)? freetextBuilder,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppPalette.onPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) => SearchablePicker<T>(
        title: title,
        items: items,
        labelBuilder: labelBuilder,
        searchHint: searchHint,
        emptyText: emptyText,
        allowFreetext: allowFreetext,
        freetextBuilder: freetextBuilder,
      ),
    );
  }

  @override
  State<SearchablePicker<T>> createState() => _SearchablePickerState<T>();
}

class _SearchablePickerState<T> extends State<SearchablePicker<T>> {
  final _search = TextEditingController();
  String _q = '';

  @override
  void initState() {
    super.initState();
    _search.addListener(() => setState(() => _q = _search.text.trim()));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<T> get _filtered {
    if (_q.isEmpty) return widget.items;
    final needle = _q.toLowerCase();
    return widget.items
        .where((e) => widget.labelBuilder(e).toLowerCase().contains(needle))
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 150),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(color: AppPalette.line, borderRadius: BorderRadius.circular(2)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
              child: Row(
                children: [
                  Text(widget.title,
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AppPalette.ink)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _search,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: widget.searchHint,
                  prefixIcon: const Icon(Icons.search_rounded, size: 20),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppPalette.line),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppPalette.line),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    final items = _filtered;
    if (items.isEmpty) {
      if (widget.allowFreetext && _q.isNotEmpty && widget.freetextBuilder != null) {
        return ListView(children: [_freetextRow()]);
      }
      return Center(
        child: Text(widget.emptyText, style: const TextStyle(color: AppPalette.muted)),
      );
    }
    return ListView.separated(
      itemCount: items.length + (widget.allowFreetext && _q.isNotEmpty && widget.freetextBuilder != null ? 1 : 0),
      separatorBuilder: (_, _) => const Divider(height: 1, color: AppPalette.line),
      itemBuilder: (context, i) {
        if (i < items.length) {
          final item = items[i];
          return ListTile(
            title: Text(widget.labelBuilder(item)),
            onTap: () => Navigator.of(context).pop(item),
          );
        }
        return _freetextRow();
      },
    );
  }

  Widget _freetextRow() {
    return ListTile(
      leading: const Icon(Icons.add_rounded, color: AppPalette.forest),
      title: Text('Use "$_q"', style: const TextStyle(color: AppPalette.forest, fontWeight: FontWeight.w600)),
      onTap: () => Navigator.of(context).pop(widget.freetextBuilder!(_q)),
    );
  }
}
