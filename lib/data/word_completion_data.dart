class WordCompletionData {
  static final List<WordCompletionItem> items = [
    WordCompletionItem(
      word: 'SUCRE',
      hint: 'Capital constitucional de Bolivia',
      letters: ['S', 'U', 'C', 'R', 'E'],
      funFact: 'Sucre es la capital constitucional y sede del Poder Judicial de Bolivia.',
    ),
    WordCompletionItem(
      word: 'TITICACA',
      hint: 'Lago navegable más alto del mundo',
      letters: ['T', 'I', 'T', 'I', 'C', 'A', 'C', 'A'],
      funFact: 'El Lago Titicaca está a 3,812 metros sobre el nivel del mar.',
    ),
    WordCompletionItem(
      word: 'SAJAMA',
      hint: 'Nevado más alto de Bolivia',
      letters: ['S', 'A', 'J', 'A', 'M', 'A'],
      funFact: 'El Nevado Sajama tiene 6,542 metros de altitud.',
    ),
    WordCompletionItem(
      word: 'KANTUTA',
      hint: 'Flor nacional de Bolivia',
      letters: ['K', 'A', 'N', 'T', 'U', 'T', 'A'],
      funFact: 'La Kantuta es la flor de los Incas, una de las flores nacionales de Bolivia.',
    ),
    WordCompletionItem(
      word: 'PATUJÚ',
      hint: 'Otra flor nacional de Bolivia',
      letters: ['P', 'A', 'T', 'U', 'J', 'Ú'],
      funFact: 'El Patujú es la flor de la zona tropical, también flor nacional de Bolivia.',
    ),
    WordCompletionItem(
      word: 'CHARANGO',
      hint: 'Instrumento musical típico boliviano',
      letters: ['C', 'H', 'A', 'R', 'A', 'N', 'G', 'O'],
      funFact: 'El charango es un instrumento de cuerdas hecho tradicionalmente con el caparazón de armadillo.',
    ),
    WordCompletionItem(
      word: 'SALAR',
      hint: 'Desierto de sal más grande del mundo',
      letters: ['S', 'A', 'L', 'A', 'R'],
      funFact: 'El Salar de Uyuni contiene el 70% de las reservas mundiales de litio.',
    ),
    WordCompletionItem(
      word: 'LLAMA',
      hint: 'Animal nacional de Bolivia',
      letters: ['L', 'L', 'A', 'M', 'A'],
      funFact: 'La llama es el animal nacional de Bolivia y aparece en el escudo del país.',
    ),
    WordCompletionItem(
      word: 'COCHABAMBA',
      hint: 'Ciudad conocida como el Granero de Bolivia',
      letters: ['C', 'O', 'C', 'H', 'A', 'B', 'A', 'M', 'B', 'A'],
      funFact: 'Cochabamba es llamada el Granero de Bolivia por su fértil valle productivo.',
    ),
    WordCompletionItem(
      word: 'SANTA CRUZ',
      hint: 'Departamento más grande de Bolivia',
      letters: ['S', 'A', 'N', 'T', 'A', ' ', 'C', 'R', 'U', 'Z'],
      funFact: 'Santa Cruz es el departamento más extenso y poblado de Bolivia.',
    ),
    WordCompletionItem(
      word: 'WIPHALA',
      hint: 'Símbolo de los pueblos indígenas',
      letters: ['W', 'I', 'P', 'H', 'A', 'L', 'A'],
      funFact: 'La Wiphala es el símbolo de los pueblos indígenas, compuesta por cuadrados de colores.',
    ),
    WordCompletionItem(
      word: 'POTOSÍ',
      hint: 'Ciudad más rica del mundo en el siglo XVII',
      letters: ['P', 'O', 'T', 'O', 'S', 'Í'],
      funFact: 'El Cerro Rico de Potosí alimentó la economía mundial con su plata durante siglos.',
    ),
    WordCompletionItem(
      word: 'DIABLADA',
      hint: 'Danza emblemática del Carnaval de Oruro',
      letters: ['D', 'I', 'A', 'B', 'L', 'A', 'D', 'A'],
      funFact: 'La Diablada escenifica la lucha entre el Arcángel San Miguel y Lucifer.',
    ),
    WordCompletionItem(
      word: 'CHUQUISACA',
      hint: 'Nombre antiguo de Sucre',
      letters: ['C', 'H', 'U', 'Q', 'U', 'I', 'S', 'A', 'C', 'A'],
      funFact: 'Chuquisaca fue uno de los nombres históricos de Sucre durante la colonia.',
    ),
    WordCompletionItem(
      word: 'QUINUA',
      hint: 'Grano andino originario de Bolivia',
      letters: ['Q', 'U', 'I', 'N', 'U', 'A'],
      funFact: 'La quinua es un superalimento originario de los Andes bolivianos.',
    ),
  ];
}

class WordCompletionItem {
  final String word;
  final String hint;
  final List<String> letters;
  final String funFact;

  WordCompletionItem({
    required this.word,
    required this.hint,
    required this.letters,
    required this.funFact,
  });
}
