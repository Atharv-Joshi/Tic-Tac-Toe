class MatrixHelper {

  // Creates an String matrix from a dynamic map.
  static List<List<String>> matrixFromMap(dynamic internalHashmap) {
    List rowLevelMapEntries = internalHashmap.entries.toList();
    List<List<String>> matrix = [];
    int totalRows = rowLevelMapEntries.length;
    for(int i = 0 ; i < totalRows; i++){
      MapEntry row = rowLevelMapEntries[i];
      List columnLevelMapEntries = row.value.entries.toList();
      int totalColumns = columnLevelMapEntries.length;
      List<String> matrixRow = [];
      for(int j = 0; j < totalColumns; j++ ){
        matrixRow.add(columnLevelMapEntries[j].value);
      }
      matrix.add(matrixRow);
    }
    return matrix;
  }

}