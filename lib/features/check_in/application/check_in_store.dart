abstract class CheckInStore {
  Future<String?> read();
  Future<void> write(String value);
}
