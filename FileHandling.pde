class FileHandling {
  final String filename = "data/scores.dat";
  
  //FileHandling() {}

  // 7 integers -> 5 best, 1 avg, 1 count
  // 14 bytes
  int[] loadScore() {
    int nums[] = {0, 0, 0, 0, 0, 0, 0};
    byte b[] = loadBytes(filename);
    if (b == null) {
      saveScore(nums);
    } else {
      for (int i=0; i<b.length/2; i++) {
        nums[i] = int(b[i*2])*128 + int(b[i*2+1]);
      }
    }
    return nums;
  }
  
  // Save int as 2 bytes
  void saveScore(int nums[]) {
    byte b[] = new byte[nums.length*2];
    for (int i=0; i<nums.length; i++) {
      b[i*2] = byte(nums[i]/128);
      b[i*2+1] = byte(nums[i] % 128);
    }
    saveBytes(filename, b);
  }
}
