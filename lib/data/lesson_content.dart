class LessonContent {
  final String lessonId;
  final String title;
  final String introduction;
  final List<LessonWord> vocabulary;
  final List<LessonQuestion> questions;

  const LessonContent({
    required this.lessonId,
    required this.title,
    required this.introduction,
    required this.vocabulary,
    required this.questions,
  });
}

class LessonWord {
  final String word;
  final String translation;
  final String pronunciation;
  final String example;

  const LessonWord({
    required this.word,
    required this.translation,
    required this.pronunciation,
    required this.example,
  });
}

class LessonQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  const LessonQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

final Map<String, LessonContent> lessonContents = {
  // ============================================================
  // ENGLISH - BEGINNER
  // ============================================================

  'en_b1': LessonContent(
    lessonId: 'en_b1',
    title: 'English Basics',
    introduction:
        'Learn the most useful English greetings and basic introductions.',
    vocabulary: [
      LessonWord(
        word: 'Hello',
        translation: 'A greeting',
        pronunciation: 'heh-LOH',
        example: 'Hello, nice to meet you.',
      ),
      LessonWord(
        word: 'Good morning',
        translation: 'A morning greeting',
        pronunciation: 'good MOR-ning',
        example: 'Good morning, Anna.',
      ),
      LessonWord(
        word: 'How are you?',
        translation: 'Asking about someone',
        pronunciation: 'how are yoo',
        example: 'Hi! How are you?',
      ),
      LessonWord(
        word: 'My name is',
        translation: 'Used to introduce yourself',
        pronunciation: 'my name iz',
        example: 'My name is David.',
      ),
      LessonWord(
        word: 'Nice to meet you',
        translation: 'A polite introduction',
        pronunciation: 'nice to meet yoo',
        example: 'Nice to meet you.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase is a common greeting?',
        options: ['Hello', 'Table', 'House', 'Water'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'How do you introduce your name?',
        options: ['My name is John', 'I water John', 'Good night John', 'John table'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_b2': LessonContent(
    lessonId: 'en_b2',
    title: 'Numbers',
    introduction: 'Learn common English numbers from 1 to 100.',
    vocabulary: [
      LessonWord(
        word: 'One',
        translation: 'Number 1',
        pronunciation: 'wun',
        example: 'I have one book.',
      ),
      LessonWord(
        word: 'Two',
        translation: 'Number 2',
        pronunciation: 'too',
        example: 'I have two brothers.',
      ),
      LessonWord(
        word: 'Ten',
        translation: 'Number 10',
        pronunciation: 'ten',
        example: 'There are ten students.',
      ),
      LessonWord(
        word: 'Twenty',
        translation: 'Number 20',
        pronunciation: 'TWEN-tee',
        example: 'I am twenty years old.',
      ),
      LessonWord(
        word: 'One hundred',
        translation: 'Number 100',
        pronunciation: 'wun HUN-dred',
        example: 'There are one hundred people.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which word means 10?',
        options: ['Ten', 'Two', 'Twenty', 'One'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means 20?',
        options: ['Twenty', 'Twelve', 'Two', 'Thirty'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_b3': LessonContent(
    lessonId: 'en_b3',
    title: 'Family',
    introduction: 'Learn basic English words for talking about family.',
    vocabulary: [
      LessonWord(
        word: 'Mother',
        translation: 'Female parent',
        pronunciation: 'MUH-ther',
        example: 'My mother is kind.',
      ),
      LessonWord(
        word: 'Father',
        translation: 'Male parent',
        pronunciation: 'FAH-ther',
        example: 'My father works here.',
      ),
      LessonWord(
        word: 'Brother',
        translation: 'Male sibling',
        pronunciation: 'BRUH-ther',
        example: 'My brother is twenty.',
      ),
      LessonWord(
        word: 'Sister',
        translation: 'Female sibling',
        pronunciation: 'SIS-ter',
        example: 'My sister is a student.',
      ),
      LessonWord(
        word: 'Family',
        translation: 'Parents and relatives',
        pronunciation: 'FAM-uh-lee',
        example: 'I love my family.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Who is your female parent?',
        options: ['Mother', 'Brother', 'Father', 'Uncle'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means female sibling?',
        options: ['Sister', 'Father', 'Son', 'Brother'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_b4': LessonContent(
    lessonId: 'en_b4',
    title: 'Daily Life',
    introduction: 'Learn useful words for everyday activities.',
    vocabulary: [
      LessonWord(
        word: 'Wake up',
        translation: 'Stop sleeping',
        pronunciation: 'wake up',
        example: 'I wake up at seven.',
      ),
      LessonWord(
        word: 'Eat',
        translation: 'Have food',
        pronunciation: 'eet',
        example: 'I eat breakfast.',
      ),
      LessonWord(
        word: 'Work',
        translation: 'Do your job',
        pronunciation: 'wurk',
        example: 'I work every day.',
      ),
      LessonWord(
        word: 'Sleep',
        translation: 'Rest at night',
        pronunciation: 'sleep',
        example: 'I sleep at eleven.',
      ),
      LessonWord(
        word: 'Today',
        translation: 'This day',
        pronunciation: 'tuh-DAY',
        example: 'I work today.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What do you do after sleeping?',
        options: ['Wake up', 'Sleep again', 'Work yesterday', 'Eat tomorrow'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means rest at night?',
        options: ['Sleep', 'Work', 'Eat', 'Walk'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_b5': LessonContent(
    lessonId: 'en_b5',
    title: 'Food & Drinks',
    introduction: 'Learn common English vocabulary for food and drinks.',
    vocabulary: [
      LessonWord(
        word: 'Water',
        translation: 'A common drink',
        pronunciation: 'WAW-ter',
        example: 'I would like some water.',
      ),
      LessonWord(
        word: 'Bread',
        translation: 'A common food',
        pronunciation: 'bred',
        example: 'I eat bread for breakfast.',
      ),
      LessonWord(
        word: 'Coffee',
        translation: 'A hot drink',
        pronunciation: 'KAW-fee',
        example: 'I drink coffee in the morning.',
      ),
      LessonWord(
        word: 'Chicken',
        translation: 'A type of food',
        pronunciation: 'CHIK-en',
        example: 'I like chicken.',
      ),
      LessonWord(
        word: 'Restaurant',
        translation: 'A place to eat',
        pronunciation: 'RES-tuh-ront',
        example: 'We are at a restaurant.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which one is a drink?',
        options: ['Water', 'Bread', 'Chicken', 'Rice'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Where do people usually go to eat prepared food?',
        options: ['Restaurant', 'Bedroom', 'Airport', 'School'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ENGLISH - INTERMEDIATE
  // ============================================================

  'en_i1': LessonContent(
    lessonId: 'en_i1',
    title: 'Daily Conversation',
    introduction: 'Practice useful English expressions for everyday conversations.',
    vocabulary: [
      LessonWord(
        word: 'What are you doing?',
        translation: 'Ask about a current activity',
        pronunciation: 'what are yoo DOO-ing',
        example: 'What are you doing tonight?',
      ),
      LessonWord(
        word: 'I am working',
        translation: 'You are currently working',
        pronunciation: 'I am WUR-king',
        example: 'I am working today.',
      ),
      LessonWord(
        word: 'Sounds good',
        translation: 'That is a good idea',
        pronunciation: 'sounds good',
        example: 'Dinner at eight? Sounds good.',
      ),
      LessonWord(
        word: 'Maybe',
        translation: 'Possibly',
        pronunciation: 'MAY-bee',
        example: 'Maybe I will come later.',
      ),
      LessonWord(
        word: 'See you later',
        translation: 'A casual goodbye',
        pronunciation: 'see yoo LAY-ter',
        example: 'See you later!',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which expression means that an idea is good?',
        options: ['Sounds good', 'See you later', 'Maybe', 'What are you doing?'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase is a casual goodbye?',
        options: ['See you later', 'Good morning', 'What is this?', 'I am working'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_i2': LessonContent(
    lessonId: 'en_i2',
    title: 'Shopping',
    introduction: 'Learn useful English phrases for shops and buying things.',
    vocabulary: [
      LessonWord(
        word: 'How much is it?',
        translation: 'Ask about price',
        pronunciation: 'how much iz it',
        example: 'How much is this shirt?',
      ),
      LessonWord(
        word: 'Size',
        translation: 'Measurement of clothing',
        pronunciation: 'size',
        example: 'Do you have this in my size?',
      ),
      LessonWord(
        word: 'Cheap',
        translation: 'Low in price',
        pronunciation: 'cheep',
        example: 'This jacket is cheap.',
      ),
      LessonWord(
        word: 'Expensive',
        translation: 'High in price',
        pronunciation: 'ik-SPEN-siv',
        example: 'That watch is expensive.',
      ),
      LessonWord(
        word: 'Receipt',
        translation: 'Paper showing a purchase',
        pronunciation: 'ri-SEET',
        example: 'Can I have the receipt?',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase asks about price?',
        options: ['How much is it?', 'What size are you?', 'Where are you?', 'How old are you?'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What means high in price?',
        options: ['Expensive', 'Cheap', 'Small', 'Free'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_i3': LessonContent(
    lessonId: 'en_i3',
    title: 'Travel English',
    introduction: 'Learn practical English for airports, hotels and travel.',
    vocabulary: [
      LessonWord(
        word: 'Passport',
        translation: 'Travel identification document',
        pronunciation: 'PAS-port',
        example: 'Here is my passport.',
      ),
      LessonWord(
        word: 'Boarding pass',
        translation: 'Document used to board a flight',
        pronunciation: 'BOR-ding pass',
        example: 'Where is my boarding pass?',
      ),
      LessonWord(
        word: 'Gate',
        translation: 'Airport departure area',
        pronunciation: 'gate',
        example: 'The flight leaves from gate five.',
      ),
      LessonWord(
        word: 'Reservation',
        translation: 'A booking',
        pronunciation: 'rez-er-VAY-shun',
        example: 'I have a hotel reservation.',
      ),
      LessonWord(
        word: 'Luggage',
        translation: 'Bags used for travel',
        pronunciation: 'LUG-ij',
        example: 'My luggage is heavy.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What document do you need for international travel?',
        options: ['Passport', 'Receipt', 'Menu', 'Ticket machine'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Where do you wait to board a flight?',
        options: ['Gate', 'Kitchen', 'Office', 'Restaurant'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_i4': LessonContent(
    lessonId: 'en_i4',
    title: 'Work & Communication',
    introduction: 'Improve English communication in professional situations.',
    vocabulary: [
      LessonWord(
        word: 'Meeting',
        translation: 'A planned work discussion',
        pronunciation: 'MEE-ting',
        example: 'The meeting starts at nine.',
      ),
      LessonWord(
        word: 'Schedule',
        translation: 'A plan of times and activities',
        pronunciation: 'SKED-jool',
        example: 'Check the schedule.',
      ),
      LessonWord(
        word: 'Deadline',
        translation: 'Final time for completing something',
        pronunciation: 'DED-line',
        example: 'The deadline is Friday.',
      ),
      LessonWord(
        word: 'Project',
        translation: 'Planned piece of work',
        pronunciation: 'PROJ-ekt',
        example: 'I am working on a new project.',
      ),
      LessonWord(
        word: 'Colleague',
        translation: 'Person you work with',
        pronunciation: 'KOL-eeg',
        example: 'My colleague helped me.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What is the final time for completing work?',
        options: ['Deadline', 'Meeting', 'Schedule', 'Break'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Who is a person you work with?',
        options: ['Colleague', 'Customer', 'Passenger', 'Tourist'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_i5': LessonContent(
    lessonId: 'en_i5',
    title: 'Speaking Practice',
    introduction: 'Build confidence by using natural English speaking expressions.',
    vocabulary: [
      LessonWord(
        word: 'I think',
        translation: 'Give your opinion',
        pronunciation: 'I think',
        example: 'I think it is a good idea.',
      ),
      LessonWord(
        word: 'I agree',
        translation: 'Say you have the same opinion',
        pronunciation: 'I uh-GREE',
        example: 'I agree with you.',
      ),
      LessonWord(
        word: 'I disagree',
        translation: 'Say you have a different opinion',
        pronunciation: 'I dis-uh-GREE',
        example: 'I disagree with that idea.',
      ),
      LessonWord(
        word: 'In my opinion',
        translation: 'Introduce your opinion',
        pronunciation: 'in my uh-PIN-yun',
        example: 'In my opinion, this is better.',
      ),
      LessonWord(
        word: 'Exactly',
        translation: 'Completely correct',
        pronunciation: 'ig-ZAKT-lee',
        example: 'Exactly! That is what I mean.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase introduces an opinion?',
        options: ['In my opinion', 'Good night', 'See you', 'Excuse me'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase means you have the same opinion?',
        options: ['I agree', 'I disagree', 'Maybe not', 'I forgot'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ENGLISH - ADVANCED
  // ============================================================

  'en_a1': LessonContent(
    lessonId: 'en_a1',
    title: 'Advanced Conversation',
    introduction: 'Practice more natural and detailed English conversations.',
    vocabulary: [
      LessonWord(
        word: 'However',
        translation: 'Used to introduce a contrast',
        pronunciation: 'how-EV-er',
        example: 'It is difficult; however, it is possible.',
      ),
      LessonWord(
        word: 'Although',
        translation: 'Despite the fact that',
        pronunciation: 'awl-THOH',
        example: 'Although it was late, we continued.',
      ),
      LessonWord(
        word: 'Actually',
        translation: 'In fact',
        pronunciation: 'AK-choo-uh-lee',
        example: 'Actually, I already knew that.',
      ),
      LessonWord(
        word: 'Probably',
        translation: 'Very likely',
        pronunciation: 'PROB-uh-blee',
        example: 'I will probably arrive early.',
      ),
      LessonWord(
        word: 'Nevertheless',
        translation: 'Despite that',
        pronunciation: 'nev-er-thuh-LESS',
        example: 'It was difficult; nevertheless, we succeeded.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which word introduces a contrast?',
        options: ['However', 'Probably', 'Actually', 'Tomorrow'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means very likely?',
        options: ['Probably', 'Never', 'Rarely', 'Exactly'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_a2': LessonContent(
    lessonId: 'en_a2',
    title: 'Business English',
    introduction: 'Learn professional vocabulary used in business situations.',
    vocabulary: [
      LessonWord(
        word: 'Negotiation',
        translation: 'Discussion to reach an agreement',
        pronunciation: 'nih-goh-see-AY-shun',
        example: 'The negotiation was successful.',
      ),
      LessonWord(
        word: 'Proposal',
        translation: 'A formal suggestion or plan',
        pronunciation: 'pruh-POH-zul',
        example: 'I sent the proposal yesterday.',
      ),
      LessonWord(
        word: 'Revenue',
        translation: 'Money earned by a business',
        pronunciation: 'REV-uh-noo',
        example: 'The company increased its revenue.',
      ),
      LessonWord(
        word: 'Strategy',
        translation: 'A plan to achieve a goal',
        pronunciation: 'STRAT-uh-jee',
        example: 'We need a new strategy.',
      ),
      LessonWord(
        word: 'Contract',
        translation: 'Formal legal agreement',
        pronunciation: 'KON-trakt',
        example: 'Please read the contract carefully.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What is a formal suggestion or plan?',
        options: ['Proposal', 'Revenue', 'Contractor', 'Meeting room'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What is a plan for achieving a goal?',
        options: ['Strategy', 'Receipt', 'Passport', 'Salary'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_a3': LessonContent(
    lessonId: 'en_a3',
    title: 'Advanced Vocabulary',
    introduction: 'Expand your English vocabulary with precise and useful words.',
    vocabulary: [
      LessonWord(
        word: 'Essential',
        translation: 'Absolutely necessary',
        pronunciation: 'uh-SEN-shul',
        example: 'Sleep is essential for health.',
      ),
      LessonWord(
        word: 'Reliable',
        translation: 'Can be trusted',
        pronunciation: 'ri-LY-uh-bul',
        example: 'She is a reliable colleague.',
      ),
      LessonWord(
        word: 'Efficient',
        translation: 'Working well without waste',
        pronunciation: 'ih-FISH-unt',
        example: 'This system is efficient.',
      ),
      LessonWord(
        word: 'Significant',
        translation: 'Important or noticeable',
        pronunciation: 'sig-NIF-uh-kunt',
        example: 'There was a significant improvement.',
      ),
      LessonWord(
        word: 'Accurate',
        translation: 'Correct and exact',
        pronunciation: 'AK-yur-it',
        example: 'The information is accurate.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which word means absolutely necessary?',
        options: ['Essential', 'Optional', 'Temporary', 'Simple'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means correct and exact?',
        options: ['Accurate', 'Difficult', 'Flexible', 'Modern'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_a4': LessonContent(
    lessonId: 'en_a4',
    title: 'Fluent Speaking',
    introduction: 'Practice expressions that make spoken English more natural.',
    vocabulary: [
      LessonWord(
        word: 'To be honest',
        translation: 'Used to express your honest opinion',
        pronunciation: 'to be ON-ist',
        example: 'To be honest, I prefer the first option.',
      ),
      LessonWord(
        word: 'As far as I know',
        translation: 'Based on what you know',
        pronunciation: 'az far az I noh',
        example: 'As far as I know, he lives here.',
      ),
      LessonWord(
        word: 'It depends',
        translation: 'The answer changes according to circumstances',
        pronunciation: 'it dih-PENDZ',
        example: 'It depends on the weather.',
      ),
      LessonWord(
        word: 'That makes sense',
        translation: 'That is logical',
        pronunciation: 'that makes sens',
        example: 'Yes, that makes sense.',
      ),
      LessonWord(
        word: 'Fair enough',
        translation: 'Acknowledge a reasonable point',
        pronunciation: 'fair uh-NUF',
        example: 'Fair enough, I understand.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which expression introduces an honest opinion?',
        options: ['To be honest', 'Fair enough', 'It depends', 'See you'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which expression means something is logical?',
        options: ['That makes sense', 'I am hungry', 'Never mind', 'Good luck'],
        correctIndex: 0,
      ),
    ],
  ),

  'en_a5': LessonContent(
    lessonId: 'en_a5',
    title: 'Master English',
    introduction: 'Challenge yourself with advanced English communication.',
    vocabulary: [
      LessonWord(
        word: 'Nevertheless',
        translation: 'Despite what was just said',
        pronunciation: 'nev-er-thuh-LESS',
        example: 'The task was difficult; nevertheless, we finished it.',
      ),
      LessonWord(
        word: 'Furthermore',
        translation: 'In addition',
        pronunciation: 'FUR-ther-mor',
        example: 'Furthermore, the plan saves money.',
      ),
      LessonWord(
        word: 'Consequently',
        translation: 'As a result',
        pronunciation: 'KON-si-kwent-lee',
        example: 'He missed the train; consequently, he was late.',
      ),
      LessonWord(
        word: 'Considerable',
        translation: 'Large or important in amount',
        pronunciation: 'kun-SID-er-uh-bul',
        example: 'The project requires considerable effort.',
      ),
      LessonWord(
        word: 'Nevertheless',
        translation: 'In spite of that',
        pronunciation: 'nev-er-thuh-LESS',
        example: 'It was risky; nevertheless, they continued.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which word means “in addition”?',
        options: ['Furthermore', 'Consequently', 'Nevertheless', 'Although'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means “as a result”?',
        options: ['Consequently', 'Furthermore', 'However', 'Although'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ITALIAN - BEGINNER
  // ============================================================

  'it_b1': LessonContent(
    lessonId: 'it_b1',
    title: 'Italian Basics',
    introduction: 'Impara i saluti e le presentazioni di base in italiano.',
    vocabulary: [
      LessonWord(
        word: 'Ciao',
        translation: 'Hello / Bye',
        pronunciation: 'chow',
        example: 'Ciao, come stai?',
      ),
      LessonWord(
        word: 'Buongiorno',
        translation: 'Good morning / Good day',
        pronunciation: 'bwon-JOR-no',
        example: 'Buongiorno, signora.',
      ),
      LessonWord(
        word: 'Come stai?',
        translation: 'How are you?',
        pronunciation: 'KOH-meh stai',
        example: 'Ciao! Come stai?',
      ),
      LessonWord(
        word: 'Mi chiamo',
        translation: 'My name is',
        pronunciation: 'mee KYAH-mo',
        example: 'Mi chiamo Marco.',
      ),
      LessonWord(
        word: 'Piacere',
        translation: 'Nice to meet you',
        pronunciation: 'pya-CHEH-reh',
        example: 'Piacere di conoscerti.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which Italian word means Hello?',
        options: ['Ciao', 'Grazie', 'Scusa', 'Prego'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'How do you say “My name is” in Italian?',
        options: ['Mi chiamo', 'Come stai', 'Buonanotte', 'A presto'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_b2': LessonContent(
    lessonId: 'it_b2',
    title: 'Numbers',
    introduction: 'Impara i numeri italiani da uno a cento.',
    vocabulary: [
      LessonWord(
        word: 'Uno',
        translation: 'One',
        pronunciation: 'OO-no',
        example: 'Ho uno fratello.',
      ),
      LessonWord(
        word: 'Due',
        translation: 'Two',
        pronunciation: 'DOO-eh',
        example: 'Ho due sorelle.',
      ),
      LessonWord(
        word: 'Dieci',
        translation: 'Ten',
        pronunciation: 'DYEH-chee',
        example: 'Ci sono dieci persone.',
      ),
      LessonWord(
        word: 'Venti',
        translation: 'Twenty',
        pronunciation: 'VEN-tee',
        example: 'Ho venti anni.',
      ),
      LessonWord(
        word: 'Cento',
        translation: 'One hundred',
        pronunciation: 'CHEN-toh',
        example: 'Cento euro.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “dieci” mean?',
        options: ['Ten', 'Two', 'Twenty', 'One'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “venti” mean?',
        options: ['Twenty', 'Thirty', 'Two', 'Ten'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_b3': LessonContent(
    lessonId: 'it_b3',
    title: 'Family',
    introduction: 'Impara il vocabolario italiano della famiglia.',
    vocabulary: [
      LessonWord(
        word: 'Madre',
        translation: 'Mother',
        pronunciation: 'MAH-dreh',
        example: 'Mia madre è gentile.',
      ),
      LessonWord(
        word: 'Padre',
        translation: 'Father',
        pronunciation: 'PAH-dreh',
        example: 'Mio padre lavora.',
      ),
      LessonWord(
        word: 'Fratello',
        translation: 'Brother',
        pronunciation: 'fra-TEL-loh',
        example: 'Mio fratello è giovane.',
      ),
      LessonWord(
        word: 'Sorella',
        translation: 'Sister',
        pronunciation: 'soh-REL-lah',
        example: 'Mia sorella studia.',
      ),
      LessonWord(
        word: 'Famiglia',
        translation: 'Family',
        pronunciation: 'fa-MEE-lyah',
        example: 'Amo la mia famiglia.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “madre” mean?',
        options: ['Mother', 'Sister', 'Father', 'Brother'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “sorella” mean?',
        options: ['Sister', 'Mother', 'Daughter', 'Aunt'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_b4': LessonContent(
    lessonId: 'it_b4',
    title: 'Food',
    introduction: 'Impara le parole italiane più comuni per il cibo.',
    vocabulary: [
      LessonWord(
        word: 'Pane',
        translation: 'Bread',
        pronunciation: 'PAH-neh',
        example: 'Vorrei del pane.',
      ),
      LessonWord(
        word: 'Acqua',
        translation: 'Water',
        pronunciation: 'AH-kwah',
        example: 'Vorrei un po’ d’acqua.',
      ),
      LessonWord(
        word: 'Pizza',
        translation: 'Pizza',
        pronunciation: 'PEET-tsah',
        example: 'Mi piace la pizza.',
      ),
      LessonWord(
        word: 'Pasta',
        translation: 'Pasta',
        pronunciation: 'PAH-stah',
        example: 'La pasta è buona.',
      ),
      LessonWord(
        word: 'Caffè',
        translation: 'Coffee',
        pronunciation: 'kaf-FEH',
        example: 'Prendo un caffè.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “acqua” mean?',
        options: ['Water', 'Bread', 'Coffee', 'Milk'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “pane” mean?',
        options: ['Bread', 'Pasta', 'Pizza', 'Rice'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_b5': LessonContent(
    lessonId: 'it_b5',
    title: 'Daily Life',
    introduction: 'Impara a parlare della tua vita quotidiana in italiano.',
    vocabulary: [
      LessonWord(
        word: 'Svegliarsi',
        translation: 'To wake up',
        pronunciation: 'zveh-LYAR-see',
        example: 'Mi sveglio alle sette.',
      ),
      LessonWord(
        word: 'Mangiare',
        translation: 'To eat',
        pronunciation: 'man-JAH-reh',
        example: 'Mangio la colazione.',
      ),
      LessonWord(
        word: 'Lavorare',
        translation: 'To work',
        pronunciation: 'la-voh-RAH-reh',
        example: 'Lavoro ogni giorno.',
      ),
      LessonWord(
        word: 'Dormire',
        translation: 'To sleep',
        pronunciation: 'dor-MEE-reh',
        example: 'Vado a dormire alle undici.',
      ),
      LessonWord(
        word: 'Oggi',
        translation: 'Today',
        pronunciation: 'OJ-jee',
        example: 'Oggi lavoro.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “oggi” mean?',
        options: ['Today', 'Tomorrow', 'Yesterday', 'Morning'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “dormire” mean?',
        options: ['To sleep', 'To work', 'To eat', 'To walk'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ITALIAN - INTERMEDIATE
  // ============================================================

  'it_i1': LessonContent(
    lessonId: 'it_i1',
    title: 'Daily Conversation',
    introduction: 'Pratica conversazioni italiane comuni della vita quotidiana.',
    vocabulary: [
      LessonWord(
        word: 'Che cosa fai?',
        translation: 'What are you doing?',
        pronunciation: 'keh KOH-zah fai',
        example: 'Che cosa fai stasera?',
      ),
      LessonWord(
        word: 'Sto lavorando',
        translation: 'I am working',
        pronunciation: 'stoh la-voh-RAN-doh',
        example: 'Sto lavorando oggi.',
      ),
      LessonWord(
        word: 'Va bene',
        translation: 'Okay / Sounds good',
        pronunciation: 'vah BEH-neh',
        example: 'Alle otto? Va bene.',
      ),
      LessonWord(
        word: 'Forse',
        translation: 'Maybe',
        pronunciation: 'FOR-seh',
        example: 'Forse arrivo più tardi.',
      ),
      LessonWord(
        word: 'A dopo',
        translation: 'See you later',
        pronunciation: 'ah DOH-poh',
        example: 'A dopo!',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “va bene” mean?',
        options: ['Okay / Sounds good', 'Good night', 'Maybe', 'Good morning'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase means “maybe”?',
        options: ['Forse', 'Certo', 'Sempre', 'Mai'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_i2': LessonContent(
    lessonId: 'it_i2',
    title: 'Shopping',
    introduction: 'Impara frasi utili per fare acquisti in italiano.',
    vocabulary: [
      LessonWord(
        word: 'Quanto costa?',
        translation: 'How much does it cost?',
        pronunciation: 'KWAN-toh KOH-stah',
        example: 'Quanto costa questa maglietta?',
      ),
      LessonWord(
        word: 'Taglia',
        translation: 'Size',
        pronunciation: 'TAHL-yah',
        example: 'Avete questa taglia?',
      ),
      LessonWord(
        word: 'Economico',
        translation: 'Cheap / inexpensive',
        pronunciation: 'eh-koh-NOH-mee-koh',
        example: 'Questo prodotto è economico.',
      ),
      LessonWord(
        word: 'Costoso',
        translation: 'Expensive',
        pronunciation: 'koh-STOH-zoh',
        example: 'Quel telefono è costoso.',
      ),
      LessonWord(
        word: 'Scontrino',
        translation: 'Receipt',
        pronunciation: 'skon-TREE-noh',
        example: 'Posso avere lo scontrino?',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase asks about the price?',
        options: ['Quanto costa?', 'Come stai?', 'Dove abiti?', 'Che ore sono?'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “scontrino” mean?',
        options: ['Receipt', 'Size', 'Price', 'Shop'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_i3': LessonContent(
    lessonId: 'it_i3',
    title: 'Travel Italian',
    introduction: 'Impara frasi italiane utili per viaggiare.',
    vocabulary: [
      LessonWord(
        word: 'Passaporto',
        translation: 'Passport',
        pronunciation: 'pas-sa-POR-toh',
        example: 'Ecco il mio passaporto.',
      ),
      LessonWord(
        word: 'Biglietto',
        translation: 'Ticket',
        pronunciation: 'bee-LYET-toh',
        example: 'Ho il mio biglietto.',
      ),
      LessonWord(
        word: 'Aeroporto',
        translation: 'Airport',
        pronunciation: 'ah-eh-roh-POR-toh',
        example: 'Sono all’aeroporto.',
      ),
      LessonWord(
        word: 'Albergo',
        translation: 'Hotel',
        pronunciation: 'al-BER-goh',
        example: 'Il mio albergo è vicino.',
      ),
      LessonWord(
        word: 'Bagaglio',
        translation: 'Luggage',
        pronunciation: 'bah-GAHL-lyoh',
        example: 'Dov’è il mio bagaglio?',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “aeroporto” mean?',
        options: ['Airport', 'Hotel', 'Ticket', 'Station'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “bagaglio” mean?',
        options: ['Luggage', 'Passport', 'Room', 'Train'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_i4': LessonContent(
    lessonId: 'it_i4',
    title: 'Restaurant',
    introduction: 'Impara come ordinare cibo e comunicare al ristorante.',
    vocabulary: [
      LessonWord(
        word: 'Menu',
        translation: 'Menu',
        pronunciation: 'meh-NOO',
        example: 'Posso vedere il menu?',
      ),
      LessonWord(
        word: 'Vorrei',
        translation: 'I would like',
        pronunciation: 'vor-RAY',
        example: 'Vorrei una pizza.',
      ),
      LessonWord(
        word: 'Il conto',
        translation: 'The bill',
        pronunciation: 'eel KON-toh',
        example: 'Il conto, per favore.',
      ),
      LessonWord(
        word: 'Acqua naturale',
        translation: 'Still water',
        pronunciation: 'AH-kwah nah-too-RAH-leh',
        example: 'Vorrei un’acqua naturale.',
      ),
      LessonWord(
        word: 'Delizioso',
        translation: 'Delicious',
        pronunciation: 'deh-lee-TSYOH-zoh',
        example: 'Il cibo è delizioso.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase means “I would like”?',
        options: ['Vorrei', 'Vado', 'Voglio bene', 'Sono'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'How do you ask for the bill?',
        options: ['Il conto, per favore', 'Buongiorno', 'Dov’è il bagno?', 'Quanto tempo?'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_i5': LessonContent(
    lessonId: 'it_i5',
    title: 'Speaking Practice',
    introduction: 'Migliora la tua capacità di parlare italiano in modo naturale.',
    vocabulary: [
      LessonWord(
        word: 'Secondo me',
        translation: 'In my opinion',
        pronunciation: 'seh-KON-doh meh',
        example: 'Secondo me è una buona idea.',
      ),
      LessonWord(
        word: 'Sono d’accordo',
        translation: 'I agree',
        pronunciation: 'SOH-noh dah-KOR-doh',
        example: 'Sono d’accordo con te.',
      ),
      LessonWord(
        word: 'Non sono d’accordo',
        translation: 'I disagree',
        pronunciation: 'non SOH-noh dah-KOR-doh',
        example: 'Non sono d’accordo.',
      ),
      LessonWord(
        word: 'Esattamente',
        translation: 'Exactly',
        pronunciation: 'es-sat-ta-MEN-teh',
        example: 'Esattamente!',
      ),
      LessonWord(
        word: 'Hai ragione',
        translation: 'You are right',
        pronunciation: 'eye rah-JOH-neh',
        example: 'Sì, hai ragione.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase means “In my opinion”?',
        options: ['Secondo me', 'Hai ragione', 'A dopo', 'Per favore'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase means “I agree”?',
        options: ['Sono d’accordo', 'Non lo so', 'Non sono d’accordo', 'Forse'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ITALIAN - ADVANCED
  // ============================================================

  'it_a1': LessonContent(
    lessonId: 'it_a1',
    title: 'Advanced Conversation',
    introduction: 'Pratica espressioni italiane più naturali e avanzate.',
    vocabulary: [
      LessonWord(
        word: 'Tuttavia',
        translation: 'However',
        pronunciation: 'toot-tah-VEE-ah',
        example: 'È difficile, tuttavia è possibile.',
      ),
      LessonWord(
        word: 'Sebbene',
        translation: 'Although',
        pronunciation: 'SEB-beh-neh',
        example: 'Sebbene fosse tardi, abbiamo continuato.',
      ),
      LessonWord(
        word: 'In realtà',
        translation: 'Actually / In fact',
        pronunciation: 'een reh-al-TAH',
        example: 'In realtà, lo sapevo già.',
      ),
      LessonWord(
        word: 'Probabilmente',
        translation: 'Probably',
        pronunciation: 'pro-bah-beel-MEN-teh',
        example: 'Probabilmente arriverò presto.',
      ),
      LessonWord(
        word: 'Nonostante',
        translation: 'Despite / Although',
        pronunciation: 'no-nah-STAN-teh',
        example: 'Nonostante la difficoltà, abbiamo continuato.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “tuttavia” mean?',
        options: ['However', 'Probably', 'Actually', 'Always'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “probabilmente” mean?',
        options: ['Probably', 'Never', 'Exactly', 'Suddenly'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_a2': LessonContent(
    lessonId: 'it_a2',
    title: 'Business Italian',
    introduction: 'Impara il vocabolario professionale italiano.',
    vocabulary: [
      LessonWord(
        word: 'Negoziazione',
        translation: 'Negotiation',
        pronunciation: 'neh-goh-tsyah-TSYOH-neh',
        example: 'La negoziazione è stata positiva.',
      ),
      LessonWord(
        word: 'Proposta',
        translation: 'Proposal',
        pronunciation: 'proh-POHS-tah',
        example: 'Ho inviato la proposta.',
      ),
      LessonWord(
        word: 'Contratto',
        translation: 'Contract',
        pronunciation: 'kon-TRAT-toh',
        example: 'Dobbiamo firmare il contratto.',
      ),
      LessonWord(
        word: 'Strategia',
        translation: 'Strategy',
        pronunciation: 'stra-teh-JEE-ah',
        example: 'Abbiamo bisogno di una nuova strategia.',
      ),
      LessonWord(
        word: 'Riunione',
        translation: 'Meeting',
        pronunciation: 'ryoo-NYOH-neh',
        example: 'La riunione inizia alle nove.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “contratto” mean?',
        options: ['Contract', 'Meeting', 'Strategy', 'Proposal'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “riunione” mean?',
        options: ['Meeting', 'Contract', 'Office', 'Salary'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_a3': LessonContent(
    lessonId: 'it_a3',
    title: 'Advanced Vocabulary',
    introduction: 'Espandi il tuo vocabolario italiano con parole precise e utili.',
    vocabulary: [
      LessonWord(
        word: 'Essenziale',
        translation: 'Essential',
        pronunciation: 'es-sen-TSYAH-leh',
        example: 'Il sonno è essenziale.',
      ),
      LessonWord(
        word: 'Affidabile',
        translation: 'Reliable',
        pronunciation: 'af-fee-DAH-bee-leh',
        example: 'È una persona affidabile.',
      ),
      LessonWord(
        word: 'Efficiente',
        translation: 'Efficient',
        pronunciation: 'ef-fee-CHEN-teh',
        example: 'Il sistema è efficiente.',
      ),
      LessonWord(
        word: 'Significativo',
        translation: 'Significant',
        pronunciation: 'seen-yee-fee-kah-TEE-voh',
        example: 'Abbiamo fatto un progresso significativo.',
      ),
      LessonWord(
        word: 'Accurato',
        translation: 'Accurate',
        pronunciation: 'ak-koo-RAH-toh',
        example: 'Il rapporto è accurato.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “essenziale” mean?',
        options: ['Essential', 'Optional', 'Temporary', 'Simple'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “affidabile” mean?',
        options: ['Reliable', 'Expensive', 'Difficult', 'Fast'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_a4': LessonContent(
    lessonId: 'it_a4',
    title: 'Fluent Speaking',
    introduction: 'Impara espressioni che rendono il tuo italiano più naturale.',
    vocabulary: [
      LessonWord(
        word: 'A dire il vero',
        translation: 'To be honest',
        pronunciation: 'ah DEE-reh eel VEH-roh',
        example: 'A dire il vero, preferisco la prima opzione.',
      ),
      LessonWord(
        word: 'Per quanto ne so',
        translation: 'As far as I know',
        pronunciation: 'per KWAN-toh neh soh',
        example: 'Per quanto ne so, vive qui.',
      ),
      LessonWord(
        word: 'Dipende',
        translation: 'It depends',
        pronunciation: 'dee-PEN-deh',
        example: 'Dipende dalla situazione.',
      ),
      LessonWord(
        word: 'Ha senso',
        translation: 'It makes sense',
        pronunciation: 'ah SEN-soh',
        example: 'Sì, ha senso.',
      ),
      LessonWord(
        word: 'Va bene',
        translation: 'Fair enough / Okay',
        pronunciation: 'vah BEH-neh',
        example: 'Va bene, capisco.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “dipende” mean?',
        options: ['It depends', 'Exactly', 'Never', 'I agree'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase means “It makes sense”?',
        options: ['Ha senso', 'A dopo', 'Non importa', 'Buona fortuna'],
        correctIndex: 0,
      ),
    ],
  ),

  'it_a5': LessonContent(
    lessonId: 'it_a5',
    title: 'Master Italian',
    introduction: 'Sfida te stesso con un italiano più avanzato e preciso.',
    vocabulary: [
      LessonWord(
        word: 'Inoltre',
        translation: 'Furthermore / In addition',
        pronunciation: 'in-OL-treh',
        example: 'Inoltre, il piano fa risparmiare denaro.',
      ),
      LessonWord(
        word: 'Di conseguenza',
        translation: 'Consequently',
        pronunciation: 'dee kon-seh-GWEN-tsah',
        example: 'Era tardi; di conseguenza, siamo partiti.',
      ),
      LessonWord(
        word: 'Tuttavia',
        translation: 'Nevertheless / However',
        pronunciation: 'toot-tah-VEE-ah',
        example: 'Era difficile; tuttavia, abbiamo continuato.',
      ),
      LessonWord(
        word: 'Notevole',
        translation: 'Considerable / Remarkable',
        pronunciation: 'noh-TEH-voh-leh',
        example: 'Abbiamo fatto un progresso notevole.',
      ),
      LessonWord(
        word: 'Pertanto',
        translation: 'Therefore',
        pronunciation: 'per-TAN-toh',
        example: 'È importante; pertanto, dobbiamo agire.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does “inoltre” mean?',
        options: ['Furthermore', 'Therefore', 'However', 'Never'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does “di conseguenza” mean?',
        options: ['Consequently', 'Actually', 'Although', 'Maybe'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ARABIC - BEGINNER
  // ============================================================

  'ar_b1': LessonContent(
    lessonId: 'ar_b1',
    title: 'Arabic Alphabet',
    introduction: 'Learn the first Arabic letters and their basic sounds.',
    vocabulary: [
      LessonWord(
        word: 'ا',
        translation: 'Alif',
        pronunciation: 'aa-lif',
        example: 'ا — Alif',
      ),
      LessonWord(
        word: 'ب',
        translation: 'Baa',
        pronunciation: 'baa',
        example: 'ب — Baa',
      ),
      LessonWord(
        word: 'ت',
        translation: 'Taa',
        pronunciation: 'taa',
        example: 'ت — Taa',
      ),
      LessonWord(
        word: 'م',
        translation: 'Meem',
        pronunciation: 'meem',
        example: 'م — Meem',
      ),
      LessonWord(
        word: 'ن',
        translation: 'Noon',
        pronunciation: 'noon',
        example: 'ن — Noon',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which Arabic letter is Alif?',
        options: ['ا', 'ب', 'ت', 'م'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which letter is Baa?',
        options: ['ب', 'ت', 'ن', 'م'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_b2': LessonContent(
    lessonId: 'ar_b2',
    title: 'Arabic Greetings',
    introduction: 'Learn basic Arabic greetings and polite expressions.',
    vocabulary: [
      LessonWord(
        word: 'مرحباً',
        translation: 'Hello',
        pronunciation: 'mar-ha-ban',
        example: 'مرحباً! كيف حالك؟',
      ),
      LessonWord(
        word: 'السلام عليكم',
        translation: 'Peace be upon you',
        pronunciation: 'as-sa-laa-mu a-lay-kum',
        example: 'السلام عليكم ورحمة الله.',
      ),
      LessonWord(
        word: 'وعليكم السلام',
        translation: 'And peace be upon you',
        pronunciation: 'wa a-lay-kum as-sa-laam',
        example: 'وعليكم السلام ورحمة الله.',
      ),
      LessonWord(
        word: 'أهلاً وسهلاً',
        translation: 'Welcome',
        pronunciation: 'ah-lan wa sah-lan',
        example: 'أهلاً وسهلاً بك.',
      ),
      LessonWord(
        word: 'كيف حالك؟',
        translation: 'How are you?',
        pronunciation: 'kay-fa haa-luk',
        example: 'مرحباً، كيف حالك؟',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which Arabic phrase means Hello?',
        options: ['مرحباً', 'شكراً', 'مع السلامة', 'من فضلك'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does كيف حالك؟ mean?',
        options: ['How are you?', 'What is your name?', 'Where are you?', 'Goodbye'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_b3': LessonContent(
    lessonId: 'ar_b3',
    title: 'Numbers',
    introduction: 'Learn common Arabic numbers from one to ten.',
    vocabulary: [
      LessonWord(
        word: 'واحد',
        translation: 'One',
        pronunciation: 'waa-hid',
        example: 'واحد',
      ),
      LessonWord(
        word: 'اثنان',
        translation: 'Two',
        pronunciation: 'ith-naan',
        example: 'اثنان',
      ),
      LessonWord(
        word: 'ثلاثة',
        translation: 'Three',
        pronunciation: 'tha-laa-tha',
        example: 'ثلاثة',
      ),
      LessonWord(
        word: 'خمسة',
        translation: 'Five',
        pronunciation: 'kham-sa',
        example: 'خمسة',
      ),
      LessonWord(
        word: 'عشرة',
        translation: 'Ten',
        pronunciation: 'a-sha-ra',
        example: 'عشرة',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does واحد mean?',
        options: ['One', 'Two', 'Three', 'Ten'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does عشرة mean?',
        options: ['Ten', 'Five', 'Three', 'Two'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_b4': LessonContent(
    lessonId: 'ar_b4',
    title: 'Family',
    introduction: 'Learn basic Arabic vocabulary for family members.',
    vocabulary: [
      LessonWord(
        word: 'أم',
        translation: 'Mother',
        pronunciation: 'umm',
        example: 'هذه أمي.',
      ),
      LessonWord(
        word: 'أب',
        translation: 'Father',
        pronunciation: 'ab',
        example: 'هذا أبي.',
      ),
      LessonWord(
        word: 'أخ',
        translation: 'Brother',
        pronunciation: 'akh',
        example: 'هذا أخي.',
      ),
      LessonWord(
        word: 'أخت',
        translation: 'Sister',
        pronunciation: 'ukht',
        example: 'هذه أختي.',
      ),
      LessonWord(
        word: 'عائلة',
        translation: 'Family',
        pronunciation: 'aa-i-la',
        example: 'أحب عائلتي.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does أم mean?',
        options: ['Mother', 'Father', 'Brother', 'Sister'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does أخ mean?',
        options: ['Brother', 'Father', 'Son', 'Uncle'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_b5': LessonContent(
    lessonId: 'ar_b5',
    title: 'Food',
    introduction: 'Learn useful Arabic vocabulary for common food and drinks.',
    vocabulary: [
      LessonWord(
        word: 'ماء',
        translation: 'Water',
        pronunciation: 'maa',
        example: 'أريد ماءً.',
      ),
      LessonWord(
        word: 'خبز',
        translation: 'Bread',
        pronunciation: 'khubz',
        example: 'أحب الخبز.',
      ),
      LessonWord(
        word: 'أرز',
        translation: 'Rice',
        pronunciation: 'ar-ruz',
        example: 'أريد الأرز.',
      ),
      LessonWord(
        word: 'دجاج',
        translation: 'Chicken',
        pronunciation: 'da-jaaj',
        example: 'أحب الدجاج.',
      ),
      LessonWord(
        word: 'قهوة',
        translation: 'Coffee',
        pronunciation: 'qah-wa',
        example: 'أريد قهوة.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does ماء mean?',
        options: ['Water', 'Bread', 'Coffee', 'Rice'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does قهوة mean?',
        options: ['Coffee', 'Tea', 'Water', 'Milk'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ARABIC - INTERMEDIATE
  // ============================================================

  'ar_i1': LessonContent(
    lessonId: 'ar_i1',
    title: 'Daily Conversation',
    introduction: 'Practice common Arabic expressions used in everyday conversations.',
    vocabulary: [
      LessonWord(
        word: 'ماذا تفعل؟',
        translation: 'What are you doing?',
        pronunciation: 'maa-thaa taf-al',
        example: 'ماذا تفعل الآن؟',
      ),
      LessonWord(
        word: 'أنا أعمل',
        translation: 'I am working',
        pronunciation: 'a-naa a-mal',
        example: 'أنا أعمل اليوم.',
      ),
      LessonWord(
        word: 'حسناً',
        translation: 'Okay',
        pronunciation: 'has-an',
        example: 'حسناً، لا مشكلة.',
      ),
      LessonWord(
        word: 'ربما',
        translation: 'Maybe',
        pronunciation: 'rub-ba-maa',
        example: 'ربما أذهب غداً.',
      ),
      LessonWord(
        word: 'أراك لاحقاً',
        translation: 'See you later',
        pronunciation: 'a-raaka laa-hi-qan',
        example: 'أراك لاحقاً.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does ماذا تفعل؟ mean?',
        options: ['What are you doing?', 'Where are you?', 'How old are you?', 'Goodbye'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does ربما mean?',
        options: ['Maybe', 'Always', 'Never', 'Exactly'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_i2': LessonContent(
    lessonId: 'ar_i2',
    title: 'Shopping',
    introduction: 'Learn useful Arabic phrases for shopping and prices.',
    vocabulary: [
      LessonWord(
        word: 'كم السعر؟',
        translation: 'How much is the price?',
        pronunciation: 'kam as-si-r',
        example: 'كم السعر؟',
      ),
      LessonWord(
        word: 'مقاس',
        translation: 'Size',
        pronunciation: 'mi-qaas',
        example: 'ما هو المقاس؟',
      ),
      LessonWord(
        word: 'رخيص',
        translation: 'Cheap',
        pronunciation: 'ra-khees',
        example: 'هذا رخيص.',
      ),
      LessonWord(
        word: 'غالي',
        translation: 'Expensive',
        pronunciation: 'ghaa-lee',
        example: 'هذا غالي جداً.',
      ),
      LessonWord(
        word: 'فاتورة',
        translation: 'Receipt / bill',
        pronunciation: 'faa-too-ra',
        example: 'أريد الفاتورة.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'Which phrase asks about price?',
        options: ['كم السعر؟', 'كيف حالك؟', 'أين أنت؟', 'ما اسمك؟'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does غالي mean?',
        options: ['Expensive', 'Cheap', 'Small', 'Free'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_i3': LessonContent(
    lessonId: 'ar_i3',
    title: 'Travel Arabic',
    introduction: 'Learn practical Arabic vocabulary for travelling.',
    vocabulary: [
      LessonWord(
        word: 'جواز السفر',
        translation: 'Passport',
        pronunciation: 'ja-waaz as-sa-far',
        example: 'هذا جواز السفر.',
      ),
      LessonWord(
        word: 'تذكرة',
        translation: 'Ticket',
        pronunciation: 'tadh-ki-ra',
        example: 'أين تذكرتي؟',
      ),
      LessonWord(
        word: 'مطار',
        translation: 'Airport',
        pronunciation: 'ma-taar',
        example: 'أين المطار؟',
      ),
      LessonWord(
        word: 'فندق',
        translation: 'Hotel',
        pronunciation: 'fun-duq',
        example: 'الفندق قريب.',
      ),
      LessonWord(
        word: 'أمتعة',
        translation: 'Luggage',
        pronunciation: 'am-ti-a',
        example: 'أين أمتعتي؟',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does مطار mean?',
        options: ['Airport', 'Hotel', 'Ticket', 'Station'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does فندق mean?',
        options: ['Hotel', 'Airport', 'Passport', 'Train'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_i4': LessonContent(
    lessonId: 'ar_i4',
    title: 'Restaurant',
    introduction: 'Learn Arabic phrases for ordering food in a restaurant.',
    vocabulary: [
      LessonWord(
        word: 'قائمة الطعام',
        translation: 'Menu',
        pronunciation: 'qaa-i-mat at-ta-aam',
        example: 'أريد قائمة الطعام.',
      ),
      LessonWord(
        word: 'أريد',
        translation: 'I want / I would like',
        pronunciation: 'u-reed',
        example: 'أريد قهوة.',
      ),
      LessonWord(
        word: 'الحساب',
        translation: 'The bill',
        pronunciation: 'al-hi-saab',
        example: 'من فضلك، الحساب.',
      ),
      LessonWord(
        word: 'ماء',
        translation: 'Water',
        pronunciation: 'maa',
        example: 'أريد ماءً من فضلك.',
      ),
      LessonWord(
        word: 'لذيذ',
        translation: 'Delicious',
        pronunciation: 'la-theeth',
        example: 'الطعام لذيذ.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does أريد mean?',
        options: ['I want / I would like', 'I know', 'I sleep', 'I go'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which word means delicious?',
        options: ['لذيذ', 'غالي', 'صغير', 'قديم'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_i5': LessonContent(
    lessonId: 'ar_i5',
    title: 'Speaking Practice',
    introduction: 'Improve your Arabic speaking with useful opinion expressions.',
    vocabulary: [
      LessonWord(
        word: 'في رأيي',
        translation: 'In my opinion',
        pronunciation: 'fee ra-yee',
        example: 'في رأيي، هذا أفضل.',
      ),
      LessonWord(
        word: 'أوافق',
        translation: 'I agree',
        pronunciation: 'u-waa-fiq',
        example: 'أنا أوافقك.',
      ),
      LessonWord(
        word: 'لا أوافق',
        translation: 'I disagree',
        pronunciation: 'laa u-waa-fiq',
        example: 'لا أوافق على ذلك.',
      ),
      LessonWord(
        word: 'بالضبط',
        translation: 'Exactly',
        pronunciation: 'bid-dabt',
        example: 'بالضبط، هذا صحيح.',
      ),
      LessonWord(
        word: 'أنت محق',
        translation: 'You are right',
        pronunciation: 'an-ta mu-haqq',
        example: 'نعم، أنت محق.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does في رأيي mean?',
        options: ['In my opinion', 'Goodbye', 'Maybe', 'Good morning'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does أوافق mean?',
        options: ['I agree', 'I disagree', 'I forget', 'I sleep'],
        correctIndex: 0,
      ),
    ],
  ),

  // ============================================================
  // ARABIC - ADVANCED
  // ============================================================

  'ar_a1': LessonContent(
    lessonId: 'ar_a1',
    title: 'Advanced Conversation',
    introduction: 'Practice more advanced Arabic expressions for conversation.',
    vocabulary: [
      LessonWord(
        word: 'ومع ذلك',
        translation: 'However / Nevertheless',
        pronunciation: 'wa ma-a dha-lik',
        example: 'كان الأمر صعباً، ومع ذلك نجحنا.',
      ),
      LessonWord(
        word: 'على الرغم من',
        translation: 'Although / Despite',
        pronunciation: 'a-la r-rugh-mi min',
        example: 'على الرغم من التعب، استمر.',
      ),
      LessonWord(
        word: 'في الواقع',
        translation: 'Actually / In fact',
        pronunciation: 'fee al-waa-qi',
        example: 'في الواقع، كنت أعرف ذلك.',
      ),
      LessonWord(
        word: 'ربما',
        translation: 'Probably / Maybe',
        pronunciation: 'rub-ba-maa',
        example: 'ربما نصل مبكراً.',
      ),
      LessonWord(
        word: 'بالتأكيد',
        translation: 'Certainly',
        pronunciation: 'bit-ta-keed',
        example: 'بالتأكيد سأساعدك.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does في الواقع mean?',
        options: ['Actually / In fact', 'Goodbye', 'Maybe', 'Tomorrow'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'Which phrase expresses contrast?',
        options: ['ومع ذلك', 'بالتأكيد', 'ربما', 'صباح الخير'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_a2': LessonContent(
    lessonId: 'ar_a2',
    title: 'Advanced Vocabulary',
    introduction: 'Expand your Arabic vocabulary with useful advanced words.',
    vocabulary: [
      LessonWord(
        word: 'ضروري',
        translation: 'Essential / Necessary',
        pronunciation: 'da-roo-ree',
        example: 'النوم ضروري.',
      ),
      LessonWord(
        word: 'موثوق',
        translation: 'Reliable',
        pronunciation: 'maw-thooq',
        example: 'هذا مصدر موثوق.',
      ),
      LessonWord(
        word: 'فعال',
        translation: 'Effective',
        pronunciation: 'fa-aal',
        example: 'هذا حل فعال.',
      ),
      LessonWord(
        word: 'مهم',
        translation: 'Important',
        pronunciation: 'mu-himm',
        example: 'هذا أمر مهم.',
      ),
      LessonWord(
        word: 'دقيق',
        translation: 'Accurate',
        pronunciation: 'da-qeeq',
        example: 'المعلومات دقيقة.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does ضروري mean?',
        options: ['Essential', 'Optional', 'Cheap', 'Old'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does دقيق mean in this context?',
        options: ['Accurate', 'Expensive', 'Fast', 'Large'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_a3': LessonContent(
    lessonId: 'ar_a3',
    title: 'Business Arabic',
    introduction: 'Learn professional Arabic vocabulary for business situations.',
    vocabulary: [
      LessonWord(
        word: 'اجتماع',
        translation: 'Meeting',
        pronunciation: 'ij-ti-maa',
        example: 'لدينا اجتماع غداً.',
      ),
      LessonWord(
        word: 'اقتراح',
        translation: 'Proposal / Suggestion',
        pronunciation: 'iq-ti-raah',
        example: 'لدي اقتراح جديد.',
      ),
      LessonWord(
        word: 'عقد',
        translation: 'Contract',
        pronunciation: 'aqd',
        example: 'وقعنا العقد.',
      ),
      LessonWord(
        word: 'استراتيجية',
        translation: 'Strategy',
        pronunciation: 'is-ti-raa-tee-jee-ya',
        example: 'نحتاج إلى استراتيجية جديدة.',
      ),
      LessonWord(
        word: 'مشروع',
        translation: 'Project',
        pronunciation: 'mash-roo',
        example: 'هذا مشروع مهم.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does اجتماع mean?',
        options: ['Meeting', 'Contract', 'Project', 'Salary'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does مشروع mean?',
        options: ['Project', 'Meeting', 'Contract', 'Office'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_a4': LessonContent(
    lessonId: 'ar_a4',
    title: 'Fluent Speaking',
    introduction: 'Learn expressions that make spoken Arabic more natural.',
    vocabulary: [
      LessonWord(
        word: 'بصراحة',
        translation: 'Honestly',
        pronunciation: 'bi-sa-ra-ha',
        example: 'بصراحة، أفضل الخيار الأول.',
      ),
      LessonWord(
        word: 'حسب علمي',
        translation: 'As far as I know',
        pronunciation: 'ha-sab il-mee',
        example: 'حسب علمي، هو يعيش هنا.',
      ),
      LessonWord(
        word: 'هذا يعتمد',
        translation: 'It depends',
        pronunciation: 'ha-tha ya-ta-mid',
        example: 'هذا يعتمد على الوقت.',
      ),
      LessonWord(
        word: 'هذا منطقي',
        translation: 'That makes sense',
        pronunciation: 'ha-tha man-ti-qee',
        example: 'نعم، هذا منطقي.',
      ),
      LessonWord(
        word: 'مقبول',
        translation: 'Fair enough / Acceptable',
        pronunciation: 'maq-bool',
        example: 'هذا مقبول.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does بصراحة mean?',
        options: ['Honestly', 'Maybe', 'Exactly', 'Tomorrow'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does هذا يعتمد mean?',
        options: ['It depends', 'It is expensive', 'It is finished', 'I agree'],
        correctIndex: 0,
      ),
    ],
  ),

  'ar_a5': LessonContent(
    lessonId: 'ar_a5',
    title: 'Master Arabic',
    introduction: 'Challenge yourself with advanced Arabic communication and vocabulary.',
    vocabulary: [
      LessonWord(
        word: 'بالإضافة إلى ذلك',
        translation: 'Furthermore / In addition',
        pronunciation: 'bil-i-daa-fa ila dha-lik',
        example: 'بالإضافة إلى ذلك، الخطة توفر المال.',
      ),
      LessonWord(
        word: 'وبالتالي',
        translation: 'Consequently / Therefore',
        pronunciation: 'wa bit-taa-lee',
        example: 'تأخر القطار، وبالتالي وصل متأخراً.',
      ),
      LessonWord(
        word: 'ومع ذلك',
        translation: 'Nevertheless',
        pronunciation: 'wa ma-a dha-lik',
        example: 'كان صعباً، ومع ذلك استمروا.',
      ),
      LessonWord(
        word: 'ملحوظ',
        translation: 'Significant / Noticeable',
        pronunciation: 'mal-hooz',
        example: 'هناك تحسن ملحوظ.',
      ),
      LessonWord(
        word: 'لذلك',
        translation: 'Therefore / So',
        pronunciation: 'li-dha-lik',
        example: 'كان مريضاً، لذلك بقي في المنزل.',
      ),
    ],
    questions: [
      LessonQuestion(
        question: 'What does بالإضافة إلى ذلك mean?',
        options: ['Furthermore', 'However', 'Maybe', 'Never'],
        correctIndex: 0,
      ),
      LessonQuestion(
        question: 'What does وبالتالي mean?',
        options: ['Consequently', 'Honestly', 'Although', 'Exactly'],
        correctIndex: 0,
      ),
    ],
  ),
};

LessonContent? getLessonContent(String lessonId) {
  return lessonContents[lessonId];
}

