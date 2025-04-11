enum ReportCategory {
  misconduct(value: 'misconduct'),
  bookingRelated(value: 'booking_related');

  const ReportCategory({required this.value});
  final String value;
}

class ReportReason {
  final ReportCategory category;
  final String title;

  ReportReason({
    required this.category,
    required this.title,
  });
}

final reasons = [
// Misconduct
  ReportReason(
    category: ReportCategory.misconduct,
    title: "Sexual images/messages",
  ),
  ReportReason(
    category: ReportCategory.misconduct,
    title: "Offensive images/messages",
  ),

  // BookingRelated
  ReportReason(
    category: ReportCategory.bookingRelated,
    title: "Did not show up",
  ),
  ReportReason(
    category: ReportCategory.bookingRelated,
    title: "Late arrival",
  ),
  ReportReason(
    category: ReportCategory.bookingRelated,
    title: "Poor quality service",
  ),
];
