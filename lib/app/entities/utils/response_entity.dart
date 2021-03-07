class ResponseEntity<T> {
  bool status;
  T body;

  ResponseEntity._internal(this.body, this.status);

  factory ResponseEntity.done(T body) => ResponseEntity._internal(body, true);
  factory ResponseEntity.fail(T body) => ResponseEntity._internal(body, false);
}
