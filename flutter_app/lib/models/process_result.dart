class ProcessResult {
  const ProcessResult({this.chunksCreated = 0});

  final int chunksCreated;

  factory ProcessResult.fromJson(Map<String, dynamic> json) {
    return ProcessResult(chunksCreated: (json['chunksCreated'] as int?) ?? 0);
  }
}
