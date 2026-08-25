import '../models/exercise_question.dart';

class ExerciseData {
  ExerciseData._();

  static const List<ExerciseQuestion> allExercises = [
    // ==================== BEGINNER ====================

    ExerciseQuestion(
      language: 'English',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "Good morning" mean?',
      options: [
        'Good morning',
        'Good night',
        'Goodbye',
        'Thank you',
      ],
      correctAnswer: 'Good morning',
      explanation: 'Good morning is used to greet someone in the morning.',
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Beginner',
      type: ExerciseType.fillBlank,
      question: 'Complete: My name ___ John.',
      correctAnswer: 'is',
      explanation: 'With My name, we use the verb is: My name is John.',
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'Choose the correct word: I ___ a student.',
      options: ['am', 'is', 'are', 'be'],
      correctAnswer: 'am',
      explanation: 'With I, the correct form of the verb to be is am.',
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'Which word means "libër"?',
      options: ['Book', 'Table', 'Chair', 'House'],
      correctAnswer: 'Book',
      explanation: 'Book is the English word for a written or printed work.',
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Beginner',
      type: ExerciseType.fillBlank,
      question: 'Complete: Thank ___ very much.',
      correctAnswer: 'you',
      explanation: 'The fixed expression is Thank you, which is used to express gratitude.',
    ),

    // ==================== INTERMEDIATE ====================

    ExerciseQuestion(
      language: 'English',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'Choose the correct sentence.',
      options: [
        'I have lived here for five years.',
        'I live here since five years.',
        'I am live here for five years.',
        'I lived here since five years.',
      ],
      correctAnswer: 'I have lived here for five years.',
      explanation: 'We use the present perfect with for when an action started in the past and continues until now.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'If I ___ more money, I would travel more.',
      correctAnswer: 'had',
      explanation: 'This is the second conditional: If + past simple, would + base verb.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'She has worked here ___ 2022.',
      options: ['since', 'for', 'during', 'from'],
      correctAnswer: 'since',
      explanation: 'Since is used with a specific starting point in time, such as 2022.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'Choose the correct passive sentence.',
      options: [
        'The book was written by her.',
        'The book wrote by her.',
        'The book is wrote by her.',
        'The book writing by her.',
      ],
      correctAnswer: 'The book was written by her.',
      explanation: 'The passive voice uses be plus the past participle. Here we use was written.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'By the time we arrived, the movie had ___.',
      correctAnswer: 'started',
      explanation: 'Had started is past perfect and shows that the movie started before we arrived.',
      points: 2,
    ),

    // ==================== ADVANCED ====================

    ExerciseQuestion(
      language: 'English',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'Choose the sentence with the correct mixed conditional.',
      options: [
        'If I had studied medicine, I would be working at the hospital now.',
        'If I studied medicine, I would have worked at the hospital now.',
        'If I had study medicine, I would work at the hospital now.',
        'If I would have studied medicine, I worked at the hospital now.',
      ],
      correctAnswer: 'If I had studied medicine, I would be working at the hospital now.',
      explanation: 'This is a mixed conditional: a past condition affects the present situation.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'Rarely ___ such a complicated problem before.',
      correctAnswer: 'have I encountered',
      explanation: 'After Rarely, English uses subject-auxiliary inversion: Rarely have I encountered.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'Which sentence correctly uses the subjunctive?',
      options: [
        'The committee recommended that he be promoted.',
        'The committee recommended that he is promoted.',
        'The committee recommended that he was promoted.',
        'The committee recommended him to be promoted.',
      ],
      correctAnswer: 'The committee recommended that he be promoted.',
      explanation: 'After recommend, formal English can use the subjunctive: recommend that he be promoted.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'What is the closest meaning of "notwithstanding"?',
      options: [
        'Despite',
        'Because of',
        'As a result of',
        'In addition to',
      ],
      correctAnswer: 'Despite',
      explanation: 'Notwithstanding means despite or in spite of and introduces a contrast.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'English',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'Had it not been for your advice, I ___ the wrong decision.',
      correctAnswer: 'would have made',
      explanation: 'Had it not been for describes an unreal past condition. The result uses would have plus the past participle.',
      points: 3,
    ),
    // ==================== ITALIAN ====================

    ExerciseQuestion(
      language: 'Italian',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "Ciao" mean?',
      options: ['Hello', 'Thank you', 'Please', 'Good night'],
      correctAnswer: 'Hello',
      explanation: 'Ciao is a common Italian greeting meaning Hello.',
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Beginner',
      type: ExerciseType.fillBlank,
      question: 'Complete: Mi ___ Marco.',
      correctAnswer: 'chiamo',
      explanation: 'Mi chiamo is the Italian expression used to say My name is.',
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "Grazie" mean?',
      options: ['Thank you', 'Goodbye', 'Hello', 'Please'],
      correctAnswer: 'Thank you',
      explanation: 'Grazie means Thank you in Italian.',
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'How do you say "Good morning" in Italian?',
      options: ['Buongiorno', 'Buonanotte', 'Arrivederci', 'Grazie'],
      correctAnswer: 'Buongiorno',
      explanation: 'Buongiorno means Good morning or Good day in Italian.',
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Beginner',
      type: ExerciseType.fillBlank,
      question: 'Complete: Come ___?',
      correctAnswer: 'stai',
      explanation: 'Come stai? means How are you? in Italian.',
    ),

    ExerciseQuestion(
      language: 'Italian',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'Scegli la frase corretta.',
      options: [
        'Vado al lavoro ogni giorno.',
        'Vado a lavoro ogni giorni.',
        'Io andare al lavoro ogni giorno.',
        'Vado il lavoro ogni giorno.',
      ],
      correctAnswer: 'Vado al lavoro ogni giorno.',
      explanation: 'Vado al lavoro ogni giorno is the grammatically correct sentence.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'Se avessi tempo, ___ di più.',
      correctAnswer: 'viaggerei',
      explanation: 'Viaggerei is the conditional form meaning I would travel.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'Vivo ___ Italia.',
      options: ['in', 'a', 'da', 'su'],
      correctAnswer: 'in',
      explanation: 'In is used with countries in Italian: Vivo in Italia.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'Quale frase è corretta?',
      options: [
        'Ho mangiato.',
        'Ho mangiare.',
        'Sono mangiato.',
        'Avevo mangiare.',
      ],
      correctAnswer: 'Ho mangiato.',
      explanation: 'Ho mangiato uses avere plus the past participle to form the passato prossimo.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'Quando sono arrivato, loro avevano già ___.',
      correctAnswer: 'mangiato',
      explanation: 'Avevano già mangiato uses the past perfect to show an earlier action.',
      points: 2,
    ),

    ExerciseQuestion(
      language: 'Italian',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'Quale frase utilizza correttamente il periodo ipotetico dell''irrealtà?',
      options: [
        'Se avessi più tempo, viaggerei molto di più.',
        'Se avrei più tempo, viaggerei molto di più.',
        'Se avessi avuto più tempo, viaggerei molto di più.',
        'Se avevo più tempo, avrei viaggiato molto di più.',
      ],
      correctAnswer: 'Se avessi più tempo, viaggerei molto di più.',
      explanation: 'This sentence uses the Italian conditional viaggerei to express what I would do if I had more time.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'Benché ___ molto stanco, continuò a lavorare.',
      correctAnswer: 'fosse',
      explanation: 'Benché introduces a concessive clause and is followed by the imperfect subjunctive fosse.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'Quale frase contiene un uso corretto del congiuntivo?',
      options: [
        'Dubito che lui abbia capito la situazione.',
        'Dubito che lui ha capito la situazione.',
        'Dubito che lui aveva capire la situazione.',
        'Dubito lui abbia capito la situazione.',
      ],
      correctAnswer: 'Dubito che lui abbia capito la situazione.',
      explanation: 'After Dubito che, Italian uses the subjunctive. Abbia capito is the correct congiuntivo passato form.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'Cosa significa "ciononostante"?',
      options: [
        'Nonostante ciò',
        'Per questo motivo',
        'Prima di tutto',
        'In altre parole',
      ],
      correctAnswer: 'Nonostante ciò',
      explanation: 'Nonostante ciò means Nevertheless or Despite this and introduces a contrast.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Italian',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'Se me lo avessi detto prima, ti ___ aiutato.',
      correctAnswer: 'avrei',
      explanation: 'Avrei is the conditional form of avere and is used to express I would have.',
      points: 3,
    ),
    // ==================== ARABIC ====================

    ExerciseQuestion(
      language: 'Arabic',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "مرحبا" mean?',
      options: ['Hello', 'Goodbye', 'Thank you', 'Please'],
      correctAnswer: 'Hello',
      explanation: 'Ciao is a common Italian greeting meaning Hello.',
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "شكرا" mean?',
      options: ['Thank you', 'Hello', 'Goodbye', 'Yes'],
      correctAnswer: 'Thank you',
      explanation: 'Grazie means Thank you in Italian.',
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "نعم" mean?',
      options: ['No', 'Yes', 'Please', 'Hello'],
      correctAnswer: 'Yes',
      explanation: 'نعم means Yes in Arabic and is used to give a positive answer.',
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Beginner',
      type: ExerciseType.multipleChoice,
      question: 'What does "لا" mean?',
      options: ['Yes', 'No', 'Thanks', 'Goodbye'],
      correctAnswer: 'No',
      explanation: 'لا means No in Arabic and is used to give a negative answer.',
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Beginner',
      type: ExerciseType.fillBlank,
      question: 'Complete: أنا ___ محمد.',
      correctAnswer: 'محمد',
      explanation: 'أنا محمد means I am Mohammed. The name محمد is used after أنا in this sentence.',
    ),

    ExerciseQuestion(
      language: 'Arabic',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'اختر الجملة الصحيحة.',
      options: [
        'ذهبت إلى العمل صباحاً.',
        'ذهب أنا إلى العمل صباحاً.',
        'أنا ذهب إلى العمل صباحاً.',
        'ذهبت العمل إلى صباحاً.',
      ],
      correctAnswer: 'ذهبت إلى العمل صباحاً.',
      explanation: 'ذهبت إلى العمل صباحاً is the grammatically correct sentence meaning I went to work in the morning.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'لو كان لدي وقت، ___ أكثر.',
      correctAnswer: 'لسافرت',
      explanation: 'لسافرت expresses a hypothetical result: If I had time, I would travel more.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'أنا أعيش ___ الجزائر.',
      options: ['في', 'إلى', 'من', 'على'],
      correctAnswer: 'في',
      explanation: 'في is the correct preposition used with a place or country. أنا أعيش في الجزائر means I live in Algeria.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Intermediate',
      type: ExerciseType.multipleChoice,
      question: 'اختر الجملة الصحيحة في الماضي.',
      options: [
        'ذهبت إلى السوق.',
        'أذهب إلى السوق أمس.',
        'سأذهب إلى السوق أمس.',
        'ذهبتُ السوق إلى.',
      ],
      correctAnswer: 'ذهبت إلى السوق.',
      explanation: 'ذهبت إلى السوق is the correct past-tense sentence meaning I went to the market.',
      points: 2,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Intermediate',
      type: ExerciseType.fillBlank,
      question: 'عندما وصلت، كانوا قد ___.',
      correctAnswer: 'غادروا',
      explanation: 'غادروا is the past-tense plural form meaning they left. كانوا قد غادروا describes an action completed before another past action.',
      points: 2,
    ),

    ExerciseQuestion(
      language: 'Arabic',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'اختر الجملة التي تعبّر عن شرط غير حقيقي في الماضي.',
      options: [
        'لو درستَ أكثر لنجحتَ في الامتحان.',
        'إذا درستَ أكثر تنجحُ في الامتحان.',
        'لو تدرسُ أكثر ستنجحُ في الامتحان.',
        'إذا كنتَ درستَ أكثر تنجحُ في الامتحان.',
      ],
      correctAnswer: 'لو درستَ أكثر لنجحتَ في الامتحان.',
      explanation: 'This structure expresses an unreal condition in the past: لو followed by the past tense, with لِ expressing the result.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'من الضروري أن ___ الطالبُ واجباته قبل الامتحان.',
      correctAnswer: 'ينجز',
      explanation: 'ينجز means completes or accomplishes. After من الضروري أن, the verb appears in the appropriate subjunctive form.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'ما المعنى الأدق لكلمة "على الرغم من ذلك"؟',
      options: [
        'ومع ذلك',
        'بسبب ذلك',
        'قبل ذلك',
        'نتيجة لذلك',
      ],
      correctAnswer: 'ومع ذلك',
      explanation: 'ومع ذلك means however or nevertheless and is used to introduce a contrast with the previous idea.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Advanced',
      type: ExerciseType.multipleChoice,
      question: 'اختر الجملة الأكثر فصاحة وصحة نحويًا.',
      options: [
        'لم يكن من السهل أن يحقق هدفه.',
        'لم يكن من السهل أن هو يحقق هدفه.',
        'لم يكن سهلًا أن يحقق هو هدفه.',
        'لم يكن من السهل يحقق هدفه.',
      ],
      correctAnswer: 'لم يكن من السهل أن يحقق هدفه.',
      explanation: 'This is the grammatically correct structure: من السهل أن followed by the verb يحقق.',
      points: 3,
    ),
    ExerciseQuestion(
      language: 'Arabic',
      level: 'Advanced',
      type: ExerciseType.fillBlank,
      question: 'لو كنتُ أعلمُ الحقيقة، لما ___ هذا القرار.',
      correctAnswer: 'اتخذت',
      explanation: 'اتخذت means I made or took. In the conditional sentence, لما اتخذت expresses the unreal past result.',
      points: 3,
    ),
  ];

  static List<ExerciseQuestion> forLanguage(String language) {
    final normalized = language.toLowerCase();

    return allExercises.where((question) {
      final questionLanguage = question.language.toLowerCase();

      if (normalized == 'italian' || normalized == 'italiano') {
        return questionLanguage == 'italian';
      }

      if (normalized == 'arabic' || normalized == 'العربية') {
        return questionLanguage == 'arabic';
      }

      return questionLanguage == 'english';
    }).toList();
  }

  static List<ExerciseQuestion> forLanguageAndLevel(
    String language,
    String level,
  ) {
    return forLanguage(language)
        .where(
          (question) =>
              question.level.toLowerCase() == level.toLowerCase(),
        )
        .toList();
  }
}







