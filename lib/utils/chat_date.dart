bool isDifferentDay(DateTime d1, DateTime d2) =>
    DateTime(d1.year, d1.month, d1.day)
        .difference(DateTime(d2.year, d2.month, d2.day))
        .inDays !=
    0;

String getDirectConversationId(List<String> uids) {
  final aux = uids..sort((a, b) => a.compareTo(b));
  return "direct_${aux.first.substring(0, 14)}${aux.last.substring(0, 14)}";
}

bool isDirectConversation(String? conversationId) {
  return conversationId?.startsWith("direct_") == true;
}
