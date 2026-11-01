part of '../main.dart';

class AppStrings {
  AppStrings(this.locale);

  final Locale locale;

  static const List<Locale> supportedLocales = [
    Locale('zh', 'TW'),
    Locale('zh', 'CN'),
    Locale('en'),
    Locale('ja'),
  ];

  static Locale resolveLocale(
      Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale?.languageCode == 'zh') {
      if (locale?.countryCode == 'CN' || locale?.countryCode == 'SG') {
        return const Locale('zh', 'CN');
      }
      return const Locale('zh', 'TW');
    }
    if (locale?.languageCode == 'ja') {
      return const Locale('ja');
    }

    return const Locale('en');
  }

  static AppStrings of(BuildContext context) {
    return AppStrings(Localizations.localeOf(context));
  }

  bool get isTraditionalChinese =>
      locale.languageCode == 'zh' && locale.countryCode != 'CN';
  bool get isSimplifiedChinese =>
      locale.languageCode == 'zh' && locale.countryCode == 'CN';
  bool get isJapanese => locale.languageCode == 'ja';

  String _text({
    required String zhHant,
    String? zhHans,
    required String en,
    String? ja,
  }) {
    if (isTraditionalChinese) {
      return zhHant;
    }
    if (isSimplifiedChinese) {
      return zhHans ?? zhHant;
    }
    if (isJapanese) {
      return ja ?? en;
    }
    return en;
  }

  List<String> _textList({
    required List<String> zhHant,
    required List<String> zhHans,
    required List<String> en,
    required List<String> ja,
  }) {
    if (isTraditionalChinese) {
      return zhHant;
    }
    if (isSimplifiedChinese) {
      return zhHans;
    }
    if (isJapanese) {
      return ja;
    }
    return en;
  }

  String get appSubtitle => _text(
        zhHant: '數學思維與進階練習',
        zhHans: '数学思维与进阶练习',
        en: 'Mathematical Thinking Practice',
        ja: '数学的思考と発展練習',
      );
  String get languageTraditionalChinese => '繁中';
  String get languageSimplifiedChinese => '简中';
  String get languageEnglish => 'EN';
  String get languageJapanese => '日本語';
  String get fullUnlockTitle => _text(
        zhHant: 'MathSpring 完整版',
        zhHans: 'MathSpring 完整版',
        en: 'MathSpring Full Unlock',
        ja: 'MathSpring フル版',
      );
  String get fullUnlockUnlockedTitle => _text(
        zhHant: '完整版已解鎖',
        zhHans: '完整版已解锁',
        en: 'Full Unlock Active',
        ja: 'フル版を解除済み',
      );
  String get fullUnlockSubtitle => _text(
        zhHant: '全部詳解、全套紙娃娃與最多五位角色。',
        zhHans: '全部详解、全套纸娃娃与最多五位角色。',
        en: 'Every solution, all avatar styles, and up to five learners.',
        ja: 'すべての解説、全アバタースタイル、学習者は最大5人。',
      );
  String get fullUnlockUnlockedSubtitle => _text(
        zhHant: '全部詳解、全套紙娃娃與最多五位角色已可使用。',
        zhHans: '全部详解、全套纸娃娃与最多五位角色已可使用。',
        en: 'Every solution, all avatar styles, and up to five learners are active.',
        ja: 'すべての解説、全アバタースタイル、最大5人の学習者を利用できます。',
      );
  String get fullUnlockDescription => _text(
        zhHant: '免費版每天可看 3 題詳解；一次解鎖全部詳解、全套紙娃娃樣式與最多五位學習者角色。',
        zhHans: '免费版每天可看 3 题详解；一次解锁全部详解、全套纸娃娃样式与最多五位学习者角色。',
        en: 'The free version shows 3 solutions a day. One purchase unlocks every solution, all avatar styles, and up to five learners.',
        ja: '無料版では1日3問の解説を見られます。1回の購入で、すべての解説、全アバタースタイル、最大5人の学習者を解除します。',
      );
  String useFreeSolution(int remaining) => _text(
        zhHant: '免費看這題詳解（今天還剩 $remaining 題）',
        zhHans: '免费看这题详解（今天还剩 $remaining 题）',
        en: 'View this solution free ($remaining left today)',
        ja: 'この解説を無料で見る（今日はあと $remaining 問）',
      );
  String freeSolutionsUsedUp(int limit) => _text(
        zhHant: '今天的 $limit 題免費詳解已用完，明天再來，或解鎖完整版看全部詳解。',
        zhHans: '今天的 $limit 题免费详解已用完，明天再来，或解锁完整版看全部详解。',
        en: "Today's $limit free solutions are used. Come back tomorrow, or unlock every solution.",
        ja: '今日の無料解説 $limit 問を使い切りました。明日また見るか、フル版ですべての解説を見られます。',
      );
  String get unlockSolutionSteps => _text(
        zhHant: '解鎖完整詳解',
        zhHans: '解锁完整详解',
        en: 'Unlock Full Solutions',
        ja: '詳しい解説を解除',
      );
  String get purchaseUnavailable => _text(
        zhHant: '暫時無法購買',
        zhHans: '暂时无法购买',
        en: 'Unavailable',
        ja: '現在は購入できません',
      );
  String get fullUnlockAlreadyPurchased => _text(
        zhHant: '此 Apple 帳號已解鎖完整版。',
        zhHans: '此 Apple 账户已解锁完整版。',
        en: 'This Apple Account has already unlocked the full version.',
        ja: 'この Apple Account はすでにフル版を解除しています。',
      );
  String get fullUnlockProductUnavailable => _text(
        zhHant: '目前無法載入購買商品，請稍後再試。',
        zhHans: '目前无法加载购买商品，请稍后再试。',
        en: 'The purchase product cannot be loaded right now. Please try again later.',
        ja: '購入商品を読み込めません。しばらくしてからもう一度お試しください。',
      );
  String purchaseFullUnlock(String price) => _text(
        zhHant: '以 $price 解鎖',
        zhHans: '以 $price 解锁',
        en: 'Unlock for $price',
        ja: '$price で解除',
      );
  String get purchaseFailed => _text(
        zhHant: '購買沒有完成，請稍後再試。',
        zhHans: '购买没有完成，请稍后再试。',
        en: 'The purchase could not be completed. Please try again later.',
        ja: '購入を完了できませんでした。しばらくしてからもう一度お試しください。',
      );
  String get nothingToRestore => _text(
        zhHant: '此 Apple 帳號沒有可回復的購買紀錄。',
        zhHans: '此 Apple 账户没有可恢复的购买记录。',
        en: 'No previous purchase was found for this Apple Account.',
        ja: 'この Apple Account に復元できる購入はありません。',
      );
  String get questionSourcePrefix => _text(
        zhHant: '出處：',
        zhHans: '出处：',
        en: 'Source: ',
        ja: '出典：',
      );
  String get gotIt => _text(
        zhHant: '知道了',
        zhHans: '知道了',
        en: 'Got it',
        ja: 'わかりました',
      );
  String get infoTooltip => _text(
        zhHant: '說明',
        zhHans: '说明',
        en: 'About this',
        ja: '説明',
      );
  String get practiceEntryInfo => _text(
        zhHant:
            '練習會從目前學習者設定的年級範圍抽題，一次一題，答完馬上知道對錯並可以看詳解。也可以先選一個主題，只練那個主題。答對率偏低的概念會比較常出現，幫你把弱點補起來。',
        zhHans:
            '练习会从当前学习者设定的年级范围抽题，一次一题，答完马上知道对错并可以看详解。也可以先选一个主题，只练那个主题。正确率偏低的概念会比较常出现，帮你把弱点补起来。',
        en: 'Practice draws questions from the current learner’s grade range, one at a time. You see right away whether each answer is correct and can open the worked solution. You can also pick a single topic to focus on. Concepts with a low accuracy rate come up more often, so weak spots get extra practice.',
        ja: '練習は、いまの学習者に設定した学年の範囲から 1 問ずつ出題されます。答えるとすぐに正解かどうかがわかり、解説も見られます。テーマを 1 つ選んで、そのテーマだけを練習することもできます。正答率の低い概念はよく出るようになり、苦手を重点的に補えます。',
      );
  String get dailyMissionTaskInfo => _text(
        zhHant:
            '每天在一般練習作答 5 題，就算完成今天的任務，答對或答錯都算。完成之後可以繼續練習。每天固定練一點，比久久練一大堆更容易記得。',
        zhHans:
            '每天在一般练习作答 5 题，就算完成今天的任务，答对或答错都算。完成之后可以继续练习。每天固定练一点，比隔很久才练一大堆更容易记住。',
        en: 'Answer 5 questions in regular practice each day to complete the daily mission — right or wrong, every answer counts. You can keep practicing after it is done. A little practice every day sticks better than a lot all at once.',
        ja: '通常の練習で 1 日 5 問に答えると、今日のミッション達成です。正解でも不正解でも数えます。達成後も続けて練習できます。毎日少しずつのほうが、まとめてたくさん解くより身につきます。',
      );
  String get quizEntryInfo => _text(
        zhHant:
            '測驗會依目前的年級範圍自動抽題，組成一份考卷。作答過程不顯示對錯，整份交卷後才統一看分數與詳解。正式測驗可以選題數與時間，總分 100 分；考試中可以自由跳題，時間到會自動交卷。',
        zhHans:
            '测验会依当前的年级范围自动抽题，组成一份试卷。作答过程中不显示对错，整份交卷后才统一看分数与详解。正式测验可以选题数与时间，总分 100 分；考试中可以自由跳题，时间到会自动交卷。',
        en: 'A quiz builds a paper from the current grade range. Answers are not marked while you work; you see the score and solutions after submitting the whole paper. For a formal exam you choose the number of questions and the time limit, the total is 100 points, you can move freely between questions, and the paper is submitted automatically when time runs out.',
        ja: 'テストは、いまの学年の範囲から自動で問題を選んで 1 回分を作ります。解いている間は正誤を表示せず、全部提出したあとで点数と解説をまとめて確認します。本番形式では問題数と時間を選べ、満点は 100 点です。問題は自由に行き来でき、時間になると自動で提出されます。',
      );
  String get reviewInfo => _text(
        zhHant:
            '這裡整理目前學習者的學習狀況：成就、每天的作答月曆、還沒訂正的錯題，以及答對率偏低的概念。也可以打開作答紀錄，重看每一次練習與測驗的題目和詳解。',
        zhHans:
            '这里整理当前学习者的学习情况：成就、每天的作答日历、还没订正的错题，以及正确率偏低的概念。也可以打开作答记录，重看每一次练习与测验的题目和详解。',
        en: 'This page sums up the current learner’s progress: achievements, a calendar of daily answers, mistakes that still need fixing, and concepts with low accuracy. You can also open the answer history to revisit the questions and solutions from every practice and quiz.',
        ja: 'いまの学習者の学習状況をまとめています。実績、毎日の解答カレンダー、まだ直していない間違い、正答率の低い概念を確認できます。解答履歴を開けば、これまでの練習とテストの問題や解説を見直せます。',
      );
  String get achievementsInfo => _text(
        zhHant: '成就會依累積的練習量、錯題訂正，以及連續學習的天數自動解鎖。每位學習者的成就分開計算。',
        zhHans: '成就会依累积的练习量、错题订正，以及连续学习的天数自动解锁。每位学习者的成就分开计算。',
        en: 'Achievements unlock automatically from the total amount of practice, fixed mistakes, and consecutive days of learning. Each learner has their own achievements.',
        ja: '実績は、練習の累計、間違いの直し、連続で学習した日数に応じて自動で解除されます。実績は学習者ごとに別々です。',
      );
  String get calendarInfo => _text(
        zhHant: '月曆會標出這個月有作答的日子。點選某一天，可以看到那天作答的題數與正確率。',
        zhHans: '日历会标出这个月有作答的日子。点选某一天，可以看到那天作答的题数与正确率。',
        en: 'The calendar marks the days this month on which questions were answered. Tap a day to see how many questions were answered and the accuracy rate.',
        ja: 'カレンダーには、今月問題に答えた日が表示されます。日付をタップすると、その日に解いた問題数と正答率がわかります。',
      );
  String get mistakePracticeInfo => _text(
        zhHant:
            '答錯、還沒訂正的題目會集中在這裡。重新作答只要答對一次，那題就會從清單移除；再答錯就繼續留著。專門練錯題，是最有效率的複習方式。',
        zhHans:
            '答错、还没订正的题目会集中在这里。重新作答只要答对一次，那题就会从列表移除；再答错就继续留着。专门练错题，是最有效率的复习方式。',
        en: 'Questions you got wrong and have not fixed yet are collected here. Answer one correctly once and it leaves the list; answer it wrong again and it stays. Practicing your mistakes is the most efficient way to review.',
        ja: '間違えてまだ直していない問題がここに集まります。もう一度解いて 1 回正解すればリストから消え、また間違えると残ります。間違えた問題を集中して解くのが、いちばん効率のよい復習です。',
      );
  String get weakConceptsInfo => _text(
        zhHant:
            '系統依作答紀錄計算每個概念的答對率。一個概念至少作答 3 題、而且答對率低於一半，就會列在這裡。之後練習時，這些概念的題目會比較常出現。',
        zhHans:
            '系统依作答记录计算每个概念的正确率。一个概念至少作答 3 题，而且正确率低于一半，就会列在这里。之后练习时，这些概念的题目会比较常出现。',
        en: 'Accuracy is tracked for every concept from the answer history. A concept is listed here once it has at least 3 answers and its accuracy is below one half. Questions on these concepts then come up more often in practice.',
        ja: '解答履歴から、概念ごとの正答率を計算しています。3 問以上解いていて正答率が半分未満の概念がここに表示されます。その後の練習では、これらの概念の問題がよく出るようになります。',
      );
  String get settingsInfo => _text(
        zhHant: '設定頁可以管理學習者角色與各自的出題年級範圍、切換目前使用的學習者、查看學習進度、選擇介面語言，以及購買或回復完整版。',
        zhHans: '设置页可以管理学习者角色与各自的出题年级范围、切换当前使用的学习者、查看学习进度、选择界面语言，以及购买或恢复完整版。',
        en: 'Here you manage learner profiles and each one’s grade range, switch the active learner, check progress, choose the interface language, and buy or restore the full version.',
        ja: 'ここでは学習者と、それぞれの出題学年の範囲を管理し、使う学習者の切り替え、進み具合の確認、表示言語の選択、フル版の購入や復元ができます。',
      );
  String get learnerProfilesInfo => _text(
        zhHant:
            '可以在同一台裝置為不同的孩子建立學習者角色，每個角色有自己的名字、頭像、出題年級範圍與學習紀錄。免費版可以建立 1 位，完整版最多 5 位。點選角色可以切換目前的學習者或編輯設定。',
        zhHans:
            '可以在同一台设备为不同的孩子创建学习者角色，每个角色有自己的名字、头像、出题年级范围与学习记录。免费版可以创建 1 位，完整版最多 5 位。点选角色可以切换当前的学习者或编辑设置。',
        en: 'Create a learner profile for each child on the same device. Every profile has its own name, avatar, grade range, and learning history. The free version allows 1 learner and the full version up to 5. Tap a profile to switch to it or edit its settings.',
        ja: '同じ端末で、子どもごとに学習者を作れます。学習者ごとに名前、アバター、出題学年の範囲、学習記録が別々です。無料版は 1 人、フル版は最大 5 人まで作れます。学習者をタップすると切り替えや設定の編集ができます。',
      );
  String get progressInfo => _text(
        zhHant: '顯示目前學習者累計作答過的題目數，以及這些題目目前答對的比例。同一題重複作答只算一題，以最近一次的結果為準。',
        zhHans: '显示当前学习者累计作答过的题目数，以及这些题目目前答对的比例。同一题重复作答只算一题，以最近一次的结果为准。',
        en: 'Shows how many different questions the current learner has answered so far and what share of them are currently correct. A question answered several times counts once, using the most recent result.',
        ja: 'いまの学習者がこれまでに解いた問題の数と、そのうち現在正解になっている割合です。同じ問題を何度解いても 1 問として数え、いちばん新しい結果を使います。',
      );
  String get learnersOverviewInfo => _text(
        zhHant: '列出每位學習者最近 7 天練習了幾天、作答幾題、答對率多少，以及最需要加強的概念，方便一次掌握所有孩子的學習狀況。',
        zhHans: '列出每位学习者最近 7 天练习了几天、作答几题、正确率多少，以及最需要加强的概念，方便一次掌握所有孩子的学习情况。',
        en: 'For each learner, shows how many of the last 7 days they practiced, how many questions they answered, their accuracy, and the concept that most needs work — so you can see every child at a glance.',
        ja: '学習者ごとに、直近 7 日間で練習した日数、解いた問題数、正答率、いちばん補強が必要な概念を表示します。すべての子どもの様子を一度に確認できます。',
      );
  String get languageSettingsInfo => _text(
        zhHant: '切換介面使用的語言：繁體中文、簡體中文、English、日本語。題目、選項與詳解也會一起切換成該語言的版本。',
        zhHans: '切换界面使用的语言：繁体中文、简体中文、English、日本語。题目、选项与详解也会一起切换成该语言的版本。',
        en: 'Switch the interface language between Traditional Chinese, Simplified Chinese, English, and Japanese. Questions, choices, and solutions switch to the same language.',
        ja: '表示言語を繁体字中国語、簡体字中国語、英語、日本語から切り替えます。問題・選択肢・解説も同じ言語に切り替わります。',
      );
  String get helpAndPrivacyInfo => _text(
        zhHant:
            '支援頁有使用說明與聯絡方式；隱私權政策說明 App 如何處理資料。MathSpring 的學習紀錄只儲存在這台裝置上，不會上傳到伺服器。',
        zhHans:
            '支持页有使用说明与联系方式；隐私政策说明 App 如何处理数据。MathSpring 的学习记录只保存在这台设备上，不会上传到服务器。',
        en: 'The support page has help and contact details; the privacy policy explains how the app handles data. MathSpring keeps learning records only on this device and never uploads them to a server.',
        ja: 'サポートページには使い方と連絡先、プライバシーポリシーにはデータの扱いが書かれています。MathSpring の学習記録はこの端末だけに保存され、サーバーには送信されません。',
      );
  String get gradeRangeInfo => _text(
        zhHant: '拖曳左右兩端，設定這位學習者會抽到的題目年級範圍。範圍越寬，難度變化越大；建議從孩子目前的年級開始，再慢慢往上加。',
        zhHans: '拖动左右两端，设定这位学习者会抽到的题目年级范围。范围越宽，难度变化越大；建议从孩子当前的年级开始，再慢慢往上加。',
        en: 'Drag the two ends to set which grades this learner’s questions come from. A wider range means a wider spread of difficulty; starting at the child’s current grade and widening gradually works well.',
        ja: '左右の端をドラッグして、この学習者に出題する学年の範囲を決めます。範囲が広いほど難しさの幅も広がります。いまの学年から始めて、少しずつ広げるのがおすすめです。',
      );
  String get questionOverviewInfo => _text(
        zhHant: '題號格子顯示每一題的作答狀態：藍色代表已作答，白色代表尚未作答。點選題號可以直接跳到那一題。',
        zhHans: '题号格子显示每一题的作答状态：蓝色代表已作答，白色代表尚未作答。点选题号可以直接跳到那一题。',
        en: 'Each number shows a question’s status: blue means answered, white means not answered yet. Tap a number to jump straight to that question.',
        ja: '番号のマスは各問題の状態を示します。青は解答済み、白は未解答です。番号をタップするとその問題へ移動します。',
      );
  String get defaultLearnerName => _text(
        zhHant: '小學生',
        zhHans: '小学生',
        en: 'Student',
        ja: '学習者',
      );
  String get welcomeFirstTime => _text(
        zhHant: '歡迎來到 MathSpring！',
        zhHans: '欢迎来到 MathSpring！',
        en: 'Welcome to MathSpring!',
        ja: 'MathSpring へようこそ！',
      );
  String welcomeBack(String name) => _text(
        zhHant: '歡迎回來，$name！',
        zhHans: '欢迎回来，$name！',
        en: 'Welcome back, $name!',
        ja: 'おかえりなさい、$name さん！',
      );
  String get startNewPractice => _text(
        zhHant: '開始新的練習',
        zhHans: '开始新的练习',
        en: 'Start something new',
        ja: '新しく練習をはじめる',
      );
  String resumePractice(int current, int total) => _text(
        zhHant: '繼續上次的練習（第 $current／$total 題）',
        zhHans: '继续上次的练习（第 $current／$total 题）',
        en: 'Continue practice (question $current of $total)',
        ja: '前回の練習のつづき（$current／$total 問目）',
      );
  String resumeQuiz(int current, int total) => _text(
        zhHant: '繼續上次的測驗（第 $current／$total 題）',
        zhHans: '继续上次的测验（第 $current／$total 题）',
        en: 'Continue quiz (question $current of $total)',
        ja: '前回のテストのつづき（$current／$total 問目）',
      );
  String get switchLearner => _text(
        zhHant: '切換學習者',
        zhHans: '切换学习者',
        en: 'Switch learner',
        ja: '学習者を切り替える',
      );
  String get restorePurchases => _text(
        zhHant: '回復購買',
        zhHans: '恢复购买',
        en: 'Restore Purchases',
        ja: '購入を復元',
      );
  String get heroTitle => 'MathSpring';
  String get heroSubtitle => _text(
        zhHant: '用更清楚的方式練習數學思維',
        zhHans: '用更清楚的方式练习数学思维',
        en: 'Build mathematical thinking with clarity.',
        ja: '数学的思考を、より明快に鍛える。',
      );
  String get profilesTitle =>
      _text(zhHant: '學習者', zhHans: '学习者', en: 'Profiles', ja: '学習者');
  String get profilesSubtitle => _text(
        zhHant: '在同一台裝置上切換不同程度的孩子。',
        zhHans: '在同一台设备上切换不同程度的孩子。',
        en: 'Switch between learners with different levels on one device.',
        ja: '1 台の端末で、異なるレベルの学習者を切り替えられます。',
      );
  String get addLearner =>
      _text(zhHant: '新增學習者', zhHans: '新增学习者', en: 'Add learner', ja: '学習者を追加');
  String get deleteLearner => _text(
      zhHant: '刪除學習者', zhHans: '删除学习者', en: 'Delete learner', ja: '学習者を削除');
  String deleteLearnerConfirmation(String name) => _text(
      zhHant: '確定要刪除「$name」嗎？這會永久刪除歷史答題紀錄、錯題紀錄與成就，無法復原。',
      zhHans: '确定要删除“$name”吗？这会永久删除答题记录、错题记录和成就，无法恢复。',
      en: 'Delete $name? Answer history, incorrect-answer records, and achievements will be permanently removed and cannot be restored.',
      ja: '$name を削除しますか？解答履歴、間違い記録、実績も完全に削除され、元に戻せません。');
  String get deleteConfirmLabel =>
      _text(zhHant: '刪除', zhHans: '删除', en: 'Delete', ja: '削除');
  String get currentLearner =>
      _text(zhHant: '目前使用', zhHans: '当前使用', en: 'Current', ja: '現在');
  String get currentLearnerLabel => _text(
        zhHant: '目前角色',
        zhHans: '当前角色',
        en: 'Current learner',
        ja: '現在の学習者',
      );
  String get gradeRangeLabel => _text(
        zhHant: '年級範圍',
        zhHans: '年级范围',
        en: 'Grade range',
        ja: '学年範囲',
      );
  String get editLearner =>
      _text(zhHant: '編輯角色', zhHans: '编辑角色', en: 'Edit learner', ja: '学習者を編集');
  String get learnerName =>
      _text(zhHant: '名稱', zhHans: '名称', en: 'Name', ja: '名前');
  String get levelStage =>
      _text(zhHant: '程度', zhHans: '程度', en: 'Level stage', ja: '学年目安');
  String get challengeTier =>
      _text(zhHant: '挑戰層級', zhHans: '挑战层级', en: 'Challenge tier', ja: '難度層');
  String get cancel =>
      _text(zhHant: '取消', zhHans: '取消', en: 'Cancel', ja: 'キャンセル');
  String get saveLearner =>
      _text(zhHant: '儲存', zhHans: '保存', en: 'Save', ja: '保存');
  String get progressTitle =>
      _text(
          zhHant: '學習進度', zhHans: '学习进度', en: 'Progress', ja: '学習の進み具合');
  String get navPractice =>
      _text(zhHant: '練習', zhHans: '练习', en: 'Practice', ja: '練習');
  String get navQuiz =>
      _text(zhHant: '測驗', zhHans: '测验', en: 'Quiz', ja: 'テスト');
  String get navReview => _text(
        zhHant: '學習回顧',
        zhHans: '学习回顾',
        en: 'Review',
        ja: 'ふり返り',
      );
  String get navSettings =>
      _text(zhHant: '設定', zhHans: '设置', en: 'Settings', ja: '設定');
  String get practiceEntryTitle =>
      _text(zhHant: '開始練習', zhHans: '开始练习', en: 'Practice', ja: '練習開始');
  String get quizEntryTitle =>
      _text(zhHant: '開始測驗', zhHans: '开始测验', en: 'Quiz', ja: 'テスト開始');
  String get reviewTitle =>
      _text(zhHant: '學習回顧', zhHans: '学习回顾', en: 'Review', ja: '学習ふり返り');
  String get achievementsTitle => _text(
        zhHant: '學習成就',
        zhHans: '学习成就',
        en: 'Achievements',
        ja: '学習の達成',
      );
  String get achievementsEmpty => _text(
        zhHant: '完成第一輪練習後，這裡會出現你的成就。',
        zhHans: '完成第一轮练习后，这里会出现你的成就。',
        en: 'Your achievements will appear after your first practice session.',
        ja: '最初の練習を終えると、ここに達成が表示されます。',
      );
  String get calendarTitle => _text(
        zhHant: '答題行事曆',
        zhHans: '答题日历',
        en: 'Answer calendar',
        ja: '回答カレンダー',
      );
  String get calendarNoPractice => _text(
        zhHant: '這一天沒有答題紀錄。',
        zhHans: '这一天没有答题记录。',
        en: 'No answers recorded on this day.',
        ja: 'この日の回答記録はありません。',
      );
  String dayActivityLabel(DateTime day) => _text(
        zhHant: '${day.month} 月 ${day.day} 日',
        zhHans: '${day.month} 月 ${day.day} 日',
        en: '${_englishMonthName(day.month)} ${day.day}',
        ja: '${day.month}月${day.day}日',
      );
  String dayActivitySummary(int count, double accuracyRate) => _text(
        zhHant: '$count 題 · 正確率 ${(accuracyRate * 100).round()}%',
        zhHans: '$count 题 · 正确率 ${(accuracyRate * 100).round()}%',
        en: '$count questions · ${(accuracyRate * 100).round()}% correct',
        ja: '$count 問 · 正答率 ${(accuracyRate * 100).round()}%',
      );

  /// 月曆的星期標題，從**週日**起算——排版用 `firstDay.weekday % 7`
  /// 算前置空格（週日 = 7 → 0），順序不可更動，否則日期會對錯欄。
  List<String> get weekdayHeaders => <String>[
        for (int i = 0; i < 7; i++) _weekdayLabel(i),
      ];

  String _weekdayLabel(int index) {
    const List<String> zh = <String>['日', '一', '二', '三', '四', '五', '六'];
    const List<String> en = <String>[
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];
    return _text(
      zhHant: zh[index],
      zhHans: zh[index],
      en: en[index],
      ja: zh[index],
    );
  }

  String monthLabel(DateTime month) => _text(
        zhHant: '${month.year} 年 ${month.month} 月',
        zhHans: '${month.year} 年 ${month.month} 月',
        en: '${_englishMonthName(month.month)} ${month.year}',
        ja: '${month.year}年${month.month}月',
      );
  String streakAchievement(int current, int longest) => _text(
        zhHant: '目前連續 $current 天 · 最高 $longest 天',
        zhHans: '当前连续 $current 天 · 最高 $longest 天',
        en: 'Current streak: $current day${current == 1 ? '' : 's'}',
        ja: '現在 $current 日連続 · 最高 $longest 日',
      );
  String recoveryAchievement(int count) {
    final String label = count >= 100
        ? _text(zhHant: '百折不撓', zhHans: '百折不挠', en: 'Unbreakable', ja: '不屈')
        : count >= 50
            ? _text(
                zhHant: '重新上手', zhHans: '重新上手', en: 'Back on Track', ja: '再挑戦')
            : count >= 10
                ? _text(
                    zhHant: '重整旗鼓', zhHans: '重整旗鼓', en: 'Regroup', ja: '立て直し')
                : _text(
                    zhHant: '錯題重做 $count / 10',
                    zhHans: '错题重做 $count / 10',
                    en: 'Review recovery $count / 10',
                    ja: '解き直し $count / 10');
    return label;
  }

  String topicAchievement(String topic, int milestone) {
    final String level = switch (milestone) {
      100 => _text(zhHant: '達人', zhHans: '达人', en: 'Master', ja: '達人'),
      50 => _text(zhHant: '熟手', zhHans: '熟手', en: 'Familiar', ja: '経験者'),
      _ => _text(zhHant: '新手', zhHans: '新手', en: 'Beginner', ja: '入門者'),
    };
    return '$topic $level';
  }

  String get settingsTitle => _text(
        zhHant: '角色與設定',
        zhHans: '角色与设置',
        en: 'Profiles & Settings',
        ja: 'プロフィールと設定',
      );
  String get topicPracticeTitle => _text(
        zhHant: '指定主題練習',
        zhHans: '指定主题练习',
        en: 'Practice by Topic',
        ja: '分野別練習',
      );
  String get topicPracticeSubtitle => _text(
        zhHant: '依目前年級範圍，選擇想加強的主題。',
        zhHans: '按当前年级范围，选择想加强的主题。',
        en: 'Choose a topic to practice within the current grade range.',
        ja: '現在の学年範囲に合わせて、強化したい分野を選びます。',
      );
  String get chooseTopic =>
      _text(zhHant: '指定主題', zhHans: '指定主题', en: 'Choose topic', ja: '分野を選ぶ');
  String get selectedTopicLabel => _text(
        zhHant: '已選主題',
        zhHans: '已选主题',
        en: 'Selected topic',
        ja: '選択中の分野',
      );
  String get noLearnerSelected => _text(
        zhHant: '尚未選擇角色',
        zhHans: '尚未选择角色',
        en: 'No learner selected',
        ja: '学習者が未選択です',
      );
  String get historyTitle =>
      _text(zhHant: '作答紀錄', zhHans: '作答记录', en: 'History', ja: '履歴');
  String get favoritesTitle => _text(
        zhHant: '我的收藏',
        zhHans: '我的收藏',
        en: 'My Favorites',
        ja: 'お気に入り',
      );
  String get allFavorites => _text(
        zhHant: '全部收藏',
        zhHans: '全部收藏',
        en: 'All favorites',
        ja: 'すべてのお気に入り',
      );
  String get favoritesEmpty => _text(
        zhHant: '從答題畫面收藏題目，它們會出現在這裡。',
        zhHans: '从答题页面收藏题目，它们会出现在这里。',
        en: 'Bookmark questions while answering and they will appear here.',
        ja: '解答画面で保存した問題がここに表示されます。',
      );
  String get addCollection => _text(
      zhHant: '新增分類', zhHans: '新增分类', en: 'Add collection', ja: 'コレクションを追加');
  String get organizeFavorite => _text(
        zhHant: '調整所屬分類',
        zhHans: '调整所属分类',
        en: 'Choose collections',
        ja: 'コレクションを選ぶ',
      );
  String get collectionName => _text(
      zhHant: '分類名稱', zhHans: '分类名称', en: 'Collection name', ja: 'コレクション名');
  String get manageCollections => _text(
      zhHant: '管理分類',
      zhHans: '管理分类',
      en: 'Manage collections',
      ja: 'コレクションを管理');
  String get editCollection => _text(
      zhHant: '編輯分類', zhHans: '编辑分类', en: 'Edit collection', ja: 'コレクションを編集');
  String get deleteCollection => _text(
      zhHant: '刪除分類', zhHans: '删除分类', en: 'Delete collection', ja: 'コレクションを削除');
  String deleteCollectionConfirm(String name) => _text(
        zhHant: '要刪除「$name」嗎？題目仍會保留在全部收藏。',
        zhHans: '要删除「$name」吗？题目仍会保留在全部收藏。',
        en: 'Delete "$name"? Its questions stay in All favorites.',
        ja: '「$name」を削除しますか？問題はすべてのお気に入りに残ります。',
      );
  String get deleteLabel =>
      _text(zhHant: '刪除', zhHans: '删除', en: 'Delete', ja: '削除');
  String get fixedCollection =>
      _text(zhHant: '固定', zhHans: '固定', en: 'Fixed', ja: '固定');
  String favoriteQuestionCount(int count) => _text(
        zhHant: '$count 題',
        zhHans: '$count 题',
        en: count == 1 ? '1 question' : '$count questions',
        ja: '$count 問',
      );
  String collectionLimitReached(int max) => _text(
        zhHant: '最多 $max 個自訂分類',
        zhHans: '最多 $max 个自定义分类',
        en: 'Up to $max custom collections',
        ja: 'カスタムコレクションは最大 $max 個',
      );
  String get collectionColor =>
      _text(zhHant: '顏色', zhHans: '颜色', en: 'Color', ja: '色');
  String collectionNameError(FavoriteCollectionNameProblem problem) =>
      switch (problem) {
        FavoriteCollectionNameProblem.empty => _text(
            zhHant: '請輸入分類名稱',
            zhHans: '请输入分类名称',
            en: 'Enter a collection name',
            ja: 'コレクション名を入力してください'),
        FavoriteCollectionNameProblem.tooLong => _text(
            zhHant: '名稱最多 $maxFavoriteCollectionNameLength 字',
            zhHans: '名称最多 $maxFavoriteCollectionNameLength 字',
            en: 'Use at most $maxFavoriteCollectionNameLength characters',
            ja: '名前は $maxFavoriteCollectionNameLength 文字以内です'),
        FavoriteCollectionNameProblem.duplicate => _text(
            zhHant: '已經有同名的分類',
            zhHans: '已经有同名的分类',
            en: 'A collection with this name already exists',
            ja: '同じ名前のコレクションがあります'),
      };
  String collectionColorName(String key) => switch (key) {
        'sage' => _text(zhHant: '灰綠', zhHans: '灰绿', en: 'Sage', ja: 'セージ'),
        'teal' => _text(zhHant: '青綠', zhHans: '青绿', en: 'Teal', ja: 'ティール'),
        'sky' => _text(zhHant: '天藍', zhHans: '天蓝', en: 'Sky', ja: 'スカイ'),
        'lavender' =>
          _text(zhHant: '薰衣草紫', zhHans: '薰衣草紫', en: 'Lavender', ja: 'ラベンダー'),
        'rose' => _text(zhHant: '玫瑰', zhHans: '玫瑰', en: 'Rose', ja: 'ローズ'),
        'apricot' =>
          _text(zhHant: '杏橘', zhHans: '杏橘', en: 'Apricot', ja: 'アプリコット'),
        'sand' => _text(zhHant: '沙黃', zhHans: '沙黄', en: 'Sand', ja: 'サンド'),
        _ => _text(zhHant: '石板灰', zhHans: '石板灰', en: 'Slate', ja: 'スレート'),
      };
  String get editTagsAndNote => _text(
        zhHant: '編輯標籤與筆記',
        zhHans: '编辑标签与笔记',
        en: 'Edit tags and note',
        ja: 'タグとメモを編集',
      );
  String get removeFavorite => _text(
      zhHant: '取消收藏',
      zhHans: '取消收藏',
      en: 'Remove from favorites',
      ja: 'お気に入りから外す');
  String get favoriteNote =>
      _text(zhHant: '筆記', zhHans: '笔记', en: 'Note', ja: 'メモ');
  String get favoriteTags =>
      _text(zhHant: '標籤', zhHans: '标签', en: 'Tags', ja: 'タグ');
  String get addFavoriteTagHint => _text(
        zhHant: '輸入標籤後按 Enter',
        zhHans: '输入标签后按 Enter',
        en: 'Type a tag and press Enter',
        ja: 'タグを入力して Enter',
      );
  String get addFavoriteTag =>
      _text(zhHant: '新增', zhHans: '新增', en: 'Add', ja: '追加');
  String get usedFavoriteTags =>
      _text(zhHant: '用過的標籤', zhHans: '用过的标签', en: 'Used tags', ja: '使ったタグ');
  String favoriteTagLimit(int max) => _text(
        zhHant: '每題最多 $max 個標籤',
        zhHans: '每题最多 $max 个标签',
        en: 'Up to $max tags per question',
        ja: '1問につきタグは最大 $max 個',
      );
  String get saveLabel =>
      _text(zhHant: '儲存', zhHans: '保存', en: 'Save', ja: '保存');
  String get cancelLabel =>
      _text(zhHant: '取消', zhHans: '取消', en: 'Cancel', ja: 'キャンセル');
  String get historySubtitle => _text(
        zhHant: '查看目前學習者最近的練習與測驗紀錄。',
        zhHans: '查看当前学习者最近的练习与测验记录。',
        en: 'Review the current learner\'s recent practice and quiz sessions.',
        ja: '現在の学習者の最近の練習とテスト履歴を確認します。',
      );
  String get historyPreviewTitle => _text(
        zhHant: '最近作答',
        zhHans: '最近作答',
        en: 'Recent sessions',
        ja: '最近のセッション',
      );
  String get historyPreviewBody => _text(
        zhHant: '保留每次練習與測驗的結果，之後可延伸成錯題本與主題分析。',
        zhHans: '保留每次练习与测验的结果，之后可扩展为错题本与主题分析。',
        en: 'Keep each practice and quiz result ready for future review and analysis.',
        ja: '各セッション結果を残し、今後は弱点集や分野分析へ発展できます。',
      );
  String get viewHistory =>
      _text(zhHant: '查看紀錄', zhHans: '查看记录', en: 'View history', ja: '履歴を見る');
  String get historyEmpty => _text(
        zhHant: '目前還沒有作答紀錄。',
        zhHans: '目前还没有作答记录。',
        en: 'No session history yet.',
        ja: 'まだ履歴がありません。',
      );
  String get sessionDetailTitle => _text(
        zhHant: '作答明細',
        zhHans: '作答明细',
        en: 'Session Detail',
        ja: 'セッション詳細',
      );
  String yourAnswerLabel(String answer) {
    return _text(
      zhHant: '你的答案：$answer',
      zhHans: '你的答案：$answer',
      en: 'Your answer: $answer',
      ja: 'あなたの答え: $answer',
    );
  }

  String get libraryTitle =>
      _text(zhHant: '題庫', zhHans: '题库', en: 'Question Library', ja: '問題集');
  String get librarySubtitle => _text(
        zhHant: '以固定格式持續擴充題目、答案與解題步驟。',
        zhHans: '以固定格式持续扩充题目、答案与解题步骤。',
        en: 'Grow the bank with one stable format for prompts and solutions.',
        ja: '問題文、解答、解説を同じ形式で継続的に追加します。',
      );
  String get browseLibrary =>
      _text(zhHant: '瀏覽題庫', zhHans: '浏览题库', en: 'Browse library', ja: '問題集を見る');
  String get startPractice =>
      _text(zhHant: '開始練習', zhHans: '开始练习', en: 'Start practice', ja: '練習開始');
  String get startSelectedTopicPractice => _text(
        zhHant: '開始這個主題的練習',
        zhHans: '开始这个主题的练习',
        en: 'Start selected topic',
        ja: 'この分野を練習する',
      );
  String get startQuiz =>
      _text(zhHant: '開始測驗', zhHans: '开始测验', en: 'Start quiz', ja: 'テスト開始');
  String get favoriteAdded => _text(
        zhHant: '已加入收藏',
        zhHans: '已加入收藏',
        en: 'Saved to favorites',
        ja: 'お気に入りに追加しました',
      );
  String get favoriteRemoved => _text(
        zhHant: '已移除收藏',
        zhHans: '已移除收藏',
        en: 'Removed from favorites',
        ja: 'お気に入りから外しました',
      );
  String get bookmarkQuestion => _text(
        zhHant: '收藏題目',
        zhHans: '收藏题目',
        en: 'Save question',
        ja: '問題をお気に入りに追加',
      );
  String formalExamQuestionCounter(int current, int total, int points) => _text(
        zhHant: '第 $current / $total 題 ・ $points 分',
        zhHans: '第 $current / $total 题 ・ $points 分',
        en: 'Question $current / $total ・ $points pts',
        ja: '第 $current / $total 問 ・ $points 点',
      );
  String formalExamRemaining(String remaining) => _text(
        zhHant: '剩餘 $remaining ・ 總分 100',
        zhHans: '剩余 $remaining ・ 总分 100',
        en: '$remaining left ・ 100 pts total',
        ja: '残り $remaining ・ 満点 100',
      );
  String get questionOverview => _text(
        zhHant: '題目總覽',
        zhHans: '题目总览',
        en: 'Question overview',
        ja: '問題一覧',
      );
  String questionOverviewItem(int number, int points) => _text(
        zhHant: '$number・$points 分',
        zhHans: '$number・$points 分',
        en: '$number・$points pts',
        ja: '$number・$points 点',
      );
  String formalExamScore(int earned, int max) => _text(
        zhHant: '正式測驗成績：$earned / $max',
        zhHans: '正式测验成绩：$earned / $max',
        en: 'Formal exam score: $earned / $max',
        ja: '本番テストの得点：$earned / $max',
      );
  String get totalScore => _text(
        zhHant: '總分',
        zhHans: '总分',
        en: 'Score',
        ja: '得点',
      );
  String get chooseFormalExam => _text(
        zhHant: '選擇正式測驗',
        zhHans: '选择正式测验',
        en: 'Choose a formal exam',
        ja: '本番テストを選ぶ',
      );
  String get chooseFormalExamBody => _text(
        zhHant: '開始後題目與配分固定；可自由跳題，時間到會自動交卷。',
        zhHans: '开始后题目与配分固定；可自由跳题，时间到会自动交卷。',
        en: 'Questions and points are fixed once you start. You can jump between questions, and the exam submits itself when time runs out.',
        ja: '開始後は問題と配点が固定されます。問題は自由に移動でき、時間になると自動で提出されます。',
      );
  String formalExamPresetLabel(int questionCount, int minutes) => _text(
        zhHant: '$questionCount 題・$minutes 分鐘・總分 100',
        zhHans: '$questionCount 题・$minutes 分钟・总分 100',
        en: '$questionCount questions・$minutes min・100 pts',
        ja: '$questionCount 問・$minutes 分・満点 100',
      );
  String get mistakePracticeTitle => _text(
        zhHant: '錯題再練',
        zhHans: '错题再练',
        en: 'Fix your mistakes',
        ja: 'まちがえた問題に再挑戦',
      );
  String mistakesToFix(int count) => _text(
        zhHant: '$count 題待訂正',
        zhHans: '$count 题待订正',
        en: count == 1 ? '1 question to fix' : '$count questions to fix',
        ja: '直す問題 $count 問',
      );
  String get noMistakesToFix => _text(
        zhHant: '目前沒有待訂正的錯題，答錯的題目會出現在這裡。',
        zhHans: '目前没有待订正的错题，答错的题目会出现在这里。',
        en: 'No mistakes to fix. Wrong answers will show up here.',
        ja: '直す問題はありません。まちがえた問題はここに表示されます。',
      );
  String get startMistakePractice => _text(
        zhHant: '開始錯題再練',
        zhHans: '开始错题再练',
        en: 'Practice my mistakes',
        ja: 'まちがえた問題を練習する',
      );
  String get weakConceptsTitle => _text(
        zhHant: '需要加強的概念',
        zhHans: '需要加强的概念',
        en: 'Concepts to strengthen',
        ja: '強化したい単元',
      );
  String get noWeakConcepts => _text(
        zhHant: '目前沒有明顯偏弱的概念。多練幾題後，這裡會列出需要加強的地方。',
        zhHans: '目前没有明显偏弱的概念。多练几题后，这里会列出需要加强的地方。',
        en: 'No weak concepts yet. After more practice, the ones to work on will show up here.',
        ja: '今のところ苦手な単元はありません。練習を重ねると、ここに表示されます。',
      );
  String conceptAccuracy(String concept, int correct, int attempts) => _text(
        zhHant: '$concept · $attempts 題答對 $correct 題',
        zhHans: '$concept · $attempts 题答对 $correct 题',
        en: '$concept · $correct of $attempts correct',
        ja: '$concept · $attempts 問中 $correct 問正解',
      );
  String get learnersOverviewTitle => _text(
        zhHant: '孩子們的學習狀況',
        zhHans: '孩子们的学习情况',
        en: 'Learners at a glance',
        ja: '学習者ごとの様子',
      );
  String overviewRecentPractice(int days, int answered, int percent) => _text(
        zhHant: '近 7 天：練了 $days 天 · $answered 題 · 答對 $percent%',
        zhHans: '近 7 天：练了 $days 天 · $answered 题 · 答对 $percent%',
        en: 'Last 7 days: $days ${days == 1 ? 'day' : 'days'} · $answered ${answered == 1 ? 'question' : 'questions'} · $percent% correct',
        ja: '直近7日：$days 日 · $answered 問 · 正答率 $percent%',
      );
  String get overviewNoRecentPractice => _text(
        zhHant: '近 7 天沒有練習',
        zhHans: '近 7 天没有练习',
        en: 'No practice in the last 7 days',
        ja: '直近7日間は練習していません',
      );
  String overviewWeakestConcept(String concept) => _text(
        zhHant: '最需要加強：$concept',
        zhHans: '最需要加强：$concept',
        en: 'Needs the most work: $concept',
        ja: 'いちばん強化したい単元：$concept',
      );
  String get overviewNoWeakConcept => _text(
        zhHant: '還沒有明顯偏弱的概念',
        zhHans: '还没有明显偏弱的概念',
        en: 'No weak concept yet',
        ja: '目立って苦手な単元はまだありません',
      );
  String get dailyMissionTitle => _text(
        zhHant: '每日五題',
        zhHans: '每日五题',
        en: 'Daily 5',
        ja: '毎日5問',
      );
  List<String> get dailyMissionEncouragements => _textList(
        zhHant: const <String>[
          '今天的任務做了嗎？從一題開始吧。',
          '花一點時間，讓今天多一點進步。',
          '準備好了嗎？完成今天的五題挑戰！',
          '每一題都是新的思考練習，現在開始吧。',
        ],
        zhHans: const <String>[
          '今天的任务做了吗？从一题开始吧。',
          '花一点时间，让今天多一点进步。',
          '准备好了吗？完成今天的五题挑战！',
          '每一题都是新的思考练习，现在开始吧。',
        ],
        en: const <String>[
          "Done today's mission yet? Start with one question.",
          'Spend a little time and make today a bit better.',
          "Ready? Take on today's five-question challenge!",
          'Every question is a fresh thinking workout. Start now.',
        ],
        ja: const <String>[
          '今日のミッションはもう終わった？まずは1問から始めよう。',
          '少しの時間で、今日をもう一歩前へ。',
          '準備はいい？今日の5問チャレンジに挑戦しよう！',
          '1問1問が新しい思考の練習。さあ始めよう。',
        ],
      );
  String get dailyMissionTaskTitle => _text(
        zhHant: '今天的任務',
        zhHans: '今天的任务',
        en: "Today's mission",
        ja: '今日のミッション',
      );
  String get dailyMissionStart => _text(
        zhHant: '開始今日任務',
        zhHans: '开始今日任务',
        en: "Start today's mission",
        ja: '今日のミッションを始める',
      );
  String get dailyMissionOpenRegular => _text(
        zhHant: '仍要自由練習？從這裡開始',
        zhHans: '仍要自由练习？从这里开始',
        en: 'Want free practice instead? Start here',
        ja: '自由に練習したい場合はこちら',
      );
  String get noApprovedQuestionsInRange => _text(
        zhHant: '這個年級範圍目前還沒有通過審查的題目。',
        zhHans: '这个年级范围目前还没有通过审查的题目。',
        en: 'There are no approved questions in this grade range yet.',
        ja: 'この学年範囲には、まだ審査済みの問題がありません。',
      );
  String get languageSettingsTitle => _text(
        zhHant: '語言',
        zhHans: '语言',
        en: 'Language',
        ja: '言語',
      );
  String get helpAndPrivacyTitle => _text(
        zhHant: '支援與隱私',
        zhHans: '支持与隐私',
        en: 'Help & Privacy',
        ja: 'サポートとプライバシー',
      );
  String get supportLinkLabel =>
      _text(zhHant: '支援', zhHans: '支持', en: 'Support', ja: 'サポート');
  String get privacyLinkLabel => _text(
      zhHant: '隱私政策', zhHans: '隐私政策', en: 'Privacy Policy', ja: 'プライバシーポリシー');
  String get linkOpenFailed => _text(
        zhHant: '目前無法開啟連結。',
        zhHans: '目前无法打开链接。',
        en: 'Unable to open the link right now.',
        ja: '現在このリンクを開けません。',
      );
  String get topicArithmetic =>
      _text(zhHant: '計算', zhHans: '计算', en: 'Arithmetic', ja: '計算');
  String get topicGeometry =>
      _text(zhHant: '幾何', zhHans: '几何', en: 'Geometry', ja: '図形');
  String get topicLogic =>
      _text(zhHant: '邏輯', zhHans: '逻辑', en: 'Logic', ja: '論理');
  String get topicMixed =>
      _text(zhHant: '綜合', zhHans: '综合', en: 'Mixed', ja: '総合');
  String get topicAlgebra =>
      _text(zhHant: '代數', zhHans: '代数', en: 'Algebra', ja: '代数');
  String get topicCombinatorics =>
      _text(zhHant: '組合', zhHans: '组合', en: 'Combinatorics', ja: '場合の数');
  String get topicNumberTheory =>
      _text(zhHant: '數論', zhHans: '数论', en: 'Number Theory', ja: '整数論');
  String get previewLabel =>
      _text(zhHant: '示範題目', zhHans: '示范题目', en: 'Sample Prompt', ja: 'サンプル問題');
  String get previewQuestion => _text(
        zhHant: '兩個相同的正方形拼成長方形後，周長增加了多少？',
        zhHans: '两个相同的正方形拼成长方形后，周长增加了多少？',
        en: 'If two equal squares form one rectangle, how much does the perimeter change?',
        ja: '同じ正方形 2 つを長方形に並べると、周の長さはどれだけ増えますか。',
      );
  String get demoNote => _text(
        zhHant: '可延伸成互動題：點選角度、逐步顯示輔助線、切換語言標籤。',
        zhHans: '可扩展为互动题：点击角度、逐步显示辅助线、切换语言标签。',
        en: 'This can grow into an interactive problem with tappable angles, guided hints, and multilingual labels.',
        ja: '角度のタップ、補助線の段階表示、多言語ラベル切替などの対話型問題へ発展できます。',
      );
  String get vectorDrawingTitle =>
      _text(zhHant: '向量繪製', zhHans: '向量绘制', en: 'Vector Drawing', ja: 'ベクター描画');
  String get bitmapAssetsLabel => _text(
      zhHant: '點陣素材', zhHans: '位图素材', en: 'Bitmap assets', ja: 'ビットマップ素材');
  String get customPainterLabel => _text(
      zhHant: 'CustomPainter',
      zhHans: 'CustomPainter',
      en: 'CustomPainter',
      ja: 'CustomPainter');
  String get chooseOneAnswer => _text(
        zhHant: '請選擇一個答案',
        zhHans: '请选择一个答案',
        en: 'Choose one answer',
        ja: '答えを 1 つ選んでください',
      );
  String get enterIntegerAnswer => _text(
        zhHant: '請輸入整數答案',
        zhHans: '请输入整数答案',
        en: 'Enter an integer answer',
        ja: '整数で入力してください',
      );
  String get selfCheckLabel => _text(
        zhHant: '先自行作答，再查看解析',
        zhHans: '先自行作答，再查看解析',
        en: 'Solve first, then review the solution',
        ja: 'まず自分で解き、その後で解説を確認します',
      );
  String get answerLabel =>
      _text(zhHant: '作答方式', zhHans: '作答方式', en: 'Answer Mode', ja: '解答方式');
  String get integerHint => _text(
      zhHant: '輸入整數', zhHans: '输入整数', en: 'Enter an integer', ja: '整数を入力');
  String answerFieldLabel(int number) => _text(
        zhHant: '答案 $number',
        zhHans: '答案 $number',
        en: 'Answer $number',
        ja: '解答 $number',
      );
  String get submitAnswer =>
      _text(zhHant: '提交答案', zhHans: '提交答案', en: 'Submit Answer', ja: '解答を送信');
  String get viewFigure =>
      _text(zhHant: '查看圖形', zhHans: '查看图形', en: 'View figure', ja: '図を表示');
  String get questionLabel =>
      _text(zhHant: '第', zhHans: '第', en: 'Question', ja: '問題');
  String get solvedLabel =>
      _text(zhHant: '完成題數', zhHans: '完成题数', en: 'Solved', ja: '完了数');
  String get accuracyLabel =>
      _text(zhHant: '正確率', zhHans: '正确率', en: 'Accuracy', ja: '正答率');
  String get practiceMode =>
      _text(zhHant: '練習模式', zhHans: '练习模式', en: 'Practice Mode', ja: '練習モード');
  String get practiceSummary => _text(
      zhHant: '練習摘要', zhHans: '练习摘要', en: 'Practice Summary', ja: '練習サマリー');
  String get quizMode =>
      _text(zhHant: '測驗模式', zhHans: '测验模式', en: 'Quiz Mode', ja: 'テストモード');
  String get submitQuiz =>
      _text(zhHant: '交卷', zhHans: '交卷', en: 'Submit quiz', ja: '提出');
  String get nextQuestion =>
      _text(zhHant: '下一題', zhHans: '下一题', en: 'Next question', ja: '次の問題');
  String get quizResult =>
      _text(zhHant: '測驗結果', zhHans: '测验结果', en: 'Quiz Result', ja: 'テスト結果');
  String get correctLabel =>
      _text(zhHant: '答對', zhHans: '答对', en: 'Correct', ja: '正解');
  String get incorrectLabel =>
      _text(zhHant: '答錯', zhHans: '答错', en: 'Incorrect', ja: '不正解');
  String get elapsedLabel =>
      _text(zhHant: '耗時', zhHans: '耗时', en: 'Elapsed', ja: '所要時間');
  String get correctSuffix =>
      _text(zhHant: '題答對', zhHans: '题答对', en: 'correct', ja: '問正解');

  String questionCountLabel(int count) {
    if (isTraditionalChinese || isSimplifiedChinese) {
      return '題';
    }
    if (isJapanese) {
      return '問';
    }
    return 'questions';
  }

  String questionCounter(int current, int total) {
    if (isTraditionalChinese) {
      return '第 $current 題 / 共 $total 題';
    }
    if (isSimplifiedChinese) {
      return '第 $current 题 / 共 $total 题';
    }
    if (isJapanese) {
      return '第 $current 問 / 全 $total 問';
    }
    return 'Question $current / $total';
  }

  String questionLabelWithNumber(int number) {
    if (isTraditionalChinese) {
      return '第 $number 題';
    }
    if (isSimplifiedChinese) {
      return '第 $number 题';
    }
    if (isJapanese) {
      return '第 $number 問';
    }
    return 'Question $number';
  }

  String levelStageDisplay(String levelStage) {
    return singleGradeDisplay(int.parse(levelStage.replaceFirst('grade', '')));
  }

  String singleGradeDisplay(int grade) {
    if (isTraditionalChinese) {
      if (grade <= 6) {
        return '小${_chineseGradeNumeral(grade)}';
      }
      if (grade <= 9) {
        return '國${_chineseGradeNumeral(grade - 6)}';
      }
      return '高${_chineseGradeNumeral(grade - 9)}';
    }
    if (isSimplifiedChinese) {
      if (grade <= 6) {
        return '小学${_chineseGradeNumeral(grade)}年级';
      }
      if (grade <= 9) {
        return '初${_chineseGradeNumeral(grade - 6)}';
      }
      return '高${_chineseGradeNumeral(grade - 9)}';
    }
    if (isJapanese) {
      if (grade <= 6) {
        return '小学 $grade 年';
      }
      if (grade <= 9) {
        return '中学 ${grade - 6} 年';
      }
      return '高校 ${grade - 9} 年';
    }
    return 'Grade $grade';
  }

  String gradeRangeDisplay(int startGrade, int endGrade) {
    if (startGrade == endGrade) {
      return singleGradeDisplay(startGrade);
    }
    if (isTraditionalChinese) {
      return '${singleGradeDisplay(startGrade)}到${singleGradeDisplay(endGrade)}';
    }
    if (isSimplifiedChinese) {
      return '${singleGradeDisplay(startGrade)}到${singleGradeDisplay(endGrade)}';
    }
    if (isJapanese) {
      return '${singleGradeDisplay(startGrade)}から${singleGradeDisplay(endGrade)}';
    }
    return 'Grades $startGrade-$endGrade';
  }

  String _chineseGradeNumeral(int grade) {
    const List<String> numerals = <String>[
      '零',
      '一',
      '二',
      '三',
      '四',
      '五',
      '六',
      '七',
      '八',
      '九',
      '十',
      '十一',
      '十二',
    ];
    return numerals[grade];
  }

  String tierDisplay(String tier) {
    switch (tier) {
      case 'foundation':
        return isTraditionalChinese ? '基礎' : 'Foundation';
      case 'advanced':
        return isTraditionalChinese ? '進階' : 'Advanced';
      case 'competition':
        return isTraditionalChinese ? '競賽' : 'Competition';
      default:
        return tier;
    }
  }
}
