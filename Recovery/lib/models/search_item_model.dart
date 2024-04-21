class SearchResultItem {
  final String item;
  final List<Map<String, String>> rows;

  SearchResultItem({
    required this.item,
    required this.rows,
  });

  void mergeRowsFrom(SearchResultItem other) {
    rows.addAll(other.rows);
  }

  static List<SearchResultItem> mergeDuplicateItems(
      List<SearchResultItem> items) {
    final Map<String, SearchResultItem> itemMap = {};

    for (final item in items) {
      if (itemMap.containsKey(item.item)) {
        itemMap[item.item]!.mergeRowsFrom(item);
      } else {
        itemMap[item.item] = SearchResultItem(
          item: item.item,
          rows: List<Map<String, String>>.from(item.rows),
        );
      }
    }

    return itemMap.values.toList();
  }
}
