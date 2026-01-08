abstract class ServiceEvent {}

class SelectService extends ServiceEvent {
  final String service;
  SelectService(this.service);
}

class SelectDate extends ServiceEvent {
  final String date;
  SelectDate(this.date);
}
