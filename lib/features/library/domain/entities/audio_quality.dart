enum AudioQuality {
  flac('FLAC', 'Lossless'),
  aac('AAC', 'Balanced'),
  wav('WAV', 'Studio');

  const AudioQuality(this.label, this.description);

  final String label;
  final String description;
}
