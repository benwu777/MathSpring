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

  String get heroBadge => _text(
        zhHant: '為 iPhone 與 iPad 打造',
        zhHans: '为 iPhone 与 iPad 打造',
        en: 'Built for iPhone and iPad',
        ja: 'iPhone と iPad のために設計',
      );
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
  String get pillAdaptive => _text(
      zhHant: '自適應版面', zhHans: '自适应版面', en: 'Adaptive layout', ja: '適応レイアウト');
  String get pillProfiles => _text(
      zhHant: '多學習者切換', zhHans: '多学习者切换', en: 'Multi-profile', ja: '複数プロフィール');
  String get pillBilingual => _text(
      zhHant: '雙語題庫', zhHans: '双语题库', en: 'Bilingual content', ja: '多言語問題集');
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
  String get gradeRangeHint => _text(
        zhHant: '拖曳左右兩端，設定這個角色可抽到的題目年級範圍。',
        zhHans: '拖动左右两端，设置这个角色可抽到的题目年级范围。',
        en: 'Drag both ends to choose the grades this learner can receive.',
        ja: '左右のつまみを動かして、この学習者に出題する学年範囲を設定します。',
      );
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
      _text(zhHant: '今日進度', zhHans: '今日进度', en: 'Today', ja: '今日の進捗');
  String get progressSubtitle => _text(
        zhHant: '保留簡單、清楚、可以持續練習的節奏。',
        zhHans: '保持简单、清楚、可以持续练习的节奏。',
        en: 'Keep practice focused, calm, and easy to continue.',
        ja: '落ち着いて継続できる練習リズムを保つ。',
      );
  String get dashboardFocusTitle =>
      _text(zhHant: '今日重點', zhHans: '今日重点', en: 'Daily Focus', ja: '今日の重点');
  String get dashboardFocusBody => _text(
        zhHant: '2 題幾何推理\n1 題數列規律\n1 次作答回顧',
        zhHans: '2 题几何推理\n1 题数列规律\n1 次作答回顾',
        en: '2 geometry proofs\n1 number pattern\n1 review session',
        ja: '幾何 2 題\n数列 1 題\n復習 1 セッション',
      );
  String get dashboardPathTitle =>
      _text(zhHant: '目前路徑', zhHans: '当前路径', en: 'Level Path', ja: '現在のルート');
  String get dashboardPathValue => _text(
        zhHant: '年級範圍',
        zhHans: '年级范围',
        en: 'Grade range',
        ja: '学年範囲',
      );
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
  String get practiceEntrySubtitle => _text(
        zhHant: '直接開始目前年級範圍的練習，或指定主題。',
        zhHans: '直接开始当前年级范围的练习，或指定主题。',
        en: 'Start a session for the current grade range or choose a topic.',
        ja: '現在の学年範囲で練習を始めるか、分野を指定します。',
      );
  String get quizEntryTitle =>
      _text(zhHant: '開始測驗', zhHans: '开始测验', en: 'Quiz', ja: 'テスト開始');
  String get quizEntrySubtitle => _text(
        zhHant: '用目前年級範圍出一組測驗，完成後再看詳解。',
        zhHans: '按当前年级范围生成一组测验，完成后再看详解。',
        en: 'Generate a quiz for the current grade range and review solutions after submission.',
        ja: '現在の学年範囲に合わせて出題し、提出後に解説を確認します。',
      );
  String get reviewTitle =>
      _text(zhHant: '學習回顧', zhHans: '学习回顾', en: 'Review', ja: '学習ふり返り');
  String get reviewSubtitle => _text(
        zhHant: '回顧最近練習與測驗，重新檢查解題過程。',
        zhHans: '回顾最近练习与测验，重新检查解题过程。',
        en: 'Revisit recent practice and quiz sessions and inspect each solution again.',
        ja: '最近の練習とテストを見返し、解き方を再確認します。',
      );
  String get achievementsTitle => _text(
        zhHant: '學習成就',
        zhHans: '学习成就',
        en: 'Achievements',
        ja: '学習の達成',
      );
  String get achievementsSubtitle => _text(
        zhHant: '依累積練習、錯題重做與持續學習解鎖。',
        zhHans: '依累计练习、错题重做与持续学习解锁。',
        en: 'Unlocked through steady practice, review, and persistence.',
        ja: '練習の積み重ね、解き直し、継続によって達成します。',
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
  String get calendarSubtitle => _text(
        zhHant: '選擇日期查看答題數與正確率。',
        zhHans: '选择日期查看答题数与正确率。',
        en: 'Choose a date to see question count and accuracy.',
        ja: '日付を選んで回答数と正答率を確認します。',
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
  String get settingsSubtitle => _text(
        zhHant: '在這裡管理角色、出題年級範圍與目前使用者。',
        zhHans: '在这里管理角色、出题年级范围与当前使用者。',
        en: 'Manage learners, grade ranges, and the active profile here.',
        ja: 'ここで学習者、出題学年範囲、現在の利用者を管理します。',
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
  String get questionOverviewLegend => _text(
        zhHant: '藍色代表已作答，白色代表尚未作答。',
        zhHans: '蓝色代表已作答，白色代表尚未作答。',
        en: 'Blue means answered; white means not answered yet.',
        ja: '青は解答済み、白はまだ解答していない問題です。',
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
  String get mistakePracticeSubtitle => _text(
        zhHant: '上次答錯、還沒訂正的題目。答對一次就會從這裡移除。',
        zhHans: '上次答错、还没订正的题目。答对一次就会从这里移除。',
        en: 'Questions you got wrong last time. Answer one correctly and it leaves this list.',
        ja: '前回まちがえて、まだ直していない問題です。一度正解するとここから消えます。',
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
  String get weakConceptsSubtitle => _text(
        zhHant: '依作答紀錄找出答對率偏低的概念，練習時會多出這些題目。',
        zhHans: '依作答记录找出答对率偏低的概念，练习时会多出这些题目。',
        en: 'Concepts with low accuracy in your answers. Practice will show more of them.',
        ja: '正答率が低めの単元です。練習ではこれらの問題が多めに出ます。',
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
  String get learnersOverviewSubtitle => _text(
        zhHant: '每位學習者近 7 天的練習量、答對率，以及最需要加強的概念。',
        zhHans: '每位学习者近 7 天的练习量、答对率，以及最需要加强的概念。',
        en: 'Practice and accuracy over the last 7 days, plus the concept each learner most needs to work on.',
        ja: '直近7日間の練習量と正答率、いちばん強化したい単元です。',
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
  String get dailyMissionTaskSubtitle => _text(
        zhHant: '一般練習作答五題即可完成，不限答對或答錯。',
        zhHans: '一般练习作答五题即可完成，不限答对或答错。',
        en: 'Answer five practice questions to finish. Right or wrong both count.',
        ja: '練習で5問答えれば達成です。正解でも不正解でも数えます。',
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
  String get quizStartHint => _text(
        zhHant: '測驗會依目前年級範圍自動抽題，完成整份後再統一看分數與詳解。',
        zhHans: '测验会按当前年级范围自动抽题，完成整份后再统一看分数与详解。',
        en: 'Quiz questions are selected automatically for the current grade range. Review score and solutions after submission.',
        ja: 'テスト問題は現在の学年範囲に合わせて自動選定され、提出後に得点と解説をまとめて確認します。',
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
  String get languageSettingsSubtitle => _text(
        zhHant: '介面語系在這裡切換，題目內容也會同步切換到可用版本。',
        zhHans: '界面语言在这里切换，题目内容也会同步切换到可用版本。',
        en: 'Switch the interface language here. Question content follows the selected locale when translations are available.',
        ja: 'ここで表示言語を切り替えます。問題文も利用可能な翻訳に合わせて切り替わります。',
      );
  String get helpAndPrivacyTitle => _text(
        zhHant: '支援與隱私',
        zhHans: '支持与隐私',
        en: 'Help & Privacy',
        ja: 'サポートとプライバシー',
      );
  String get helpAndPrivacySubtitle => _text(
        zhHant: '查看使用說明與資料處理方式。',
        zhHans: '查看使用说明与数据处理方式。',
        en: 'Read support information and how data is handled.',
        ja: '使い方とデータの取り扱いを確認します。',
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
