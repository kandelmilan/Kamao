/// Ticket status filters matching the web Support dashboard.
abstract class SupportTicketStatusFilter {
  SupportTicketStatusFilter._();

  static const all = 'All';
  static const open = 'Open';
  static const inProgress = 'InProgress';
  static const waitingCustomer = 'WaitingCustomer';
  static const resolved = 'Resolved';
  static const closed = 'Closed';

  static const values = [
    all,
    open,
    inProgress,
    waitingCustomer,
    resolved,
    closed,
  ];

  static String label(String status) {
    switch (status) {
      case inProgress:
        return 'In Progress';
      case waitingCustomer:
        return 'Waiting Customer';
      default:
        return status;
    }
  }
}
