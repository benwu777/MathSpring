#!/usr/bin/env ruby
# frozen_string_literal: true

# grade2 第二輪擴充之二：logic 7 / arithmetic 7
require 'json'
require 'set'

ROOT = File.expand_path('..', __dir__)
GRADE = 'grade2'
PATHS = %w[logic arithmetic].to_h { |t| [t, File.join(ROOT, "assets/questions/#{t}/#{GRADE}_foundation.#{t}.v1.json")] }.freeze
MANIFEST_PATH = File.join(ROOT, 'assets/questions/manifest.json')

def load_json(path) = JSON.parse(File.read(path))
def save_json(path, data) = File.write(path, JSON.pretty_generate(data) + "\n")

def base(topic:, subtopic:, prompt:, answer:, steps:, notes:)
  { 'reviewStatus' => 'ok', 'topic' => topic, 'subtopic' => subtopic,
    'difficulty' => 'foundation', 'levelStage' => GRADE, 'challengeTier' => 'foundation',
    'prompt' => prompt, 'answer' => answer, 'solutionSteps' => steps,
    'figure' => { 'type' => 'custom', 'kind' => 'none', 'params' => {} },
    'source' => { 'type' => 'rewritten_olympiad_style', 'name' => 'MathSpring Editorial',
                  'reference' => "#{topic}-#{GRADE}-foundation", 'notes' => notes } }
end

def int_q(value:, max_digits:, **rest)
  base(**rest).merge('answerMode' => 'integer_input',
                     'correctAnswer' => { 'type' => 'integer', 'value' => value },
                     'inputConstraints' => { 'allowNegative' => false, 'maxDigits' => max_digits })
end

def mc_q(options:, correct:, **rest)
  base(**rest).merge('answerMode' => 'multiple_choice', 'options' => options,
                     'correctAnswer' => { 'type' => 'choice', 'value' => correct })
end

QUESTIONS = {
  'logic' => [
    mc_q(
      topic: 'logic', subtopic: 'parity_reasoning',
      prompt: {
        'zh-Hant' => '一場聚會有 7 個人。有人說：「我們每個人都恰好和其他 3 個人握過手。」（同兩個人之間最多握一次手。）這種情況有可能發生嗎？',
        'zh-Hans' => '一场聚会有 7 个人。有人说：「我们每个人都恰好和其他 3 个人握过手。」（同两个人之间最多握一次手。）这种情况有可能发生吗？',
        'en' => 'Seven people are at a party. Someone claims: "Each of us has shaken hands with exactly 3 of the others." (No two people shake hands more than once.) Can this happen?',
        'ja' => 'パーティーに 7 人います。ある人が「私たちは全員、ほかのちょうど 3 人と握手した」と言いました。（同じ 2 人が 2 回以上握手することはありません。）このようなことは起こりえますか。',
      },
      answer: { 'zh-Hant' => '不可能，因為那樣算出來的握手次數不是整數。',
                'zh-Hans' => '不可能，因为那样算出来的握手次数不是整数。',
                'en' => 'It is impossible, because the number of handshakes would not come out whole.',
                'ja' => 'できません。そうすると握手の回数が整数になりません。' },
      steps: {
        'zh-Hant' => [
          '每一次握手都是兩個人一起完成的，所以把每個人的握手次數全部加起來，會剛好是握手次數的 2 倍。',
          '如果 7 個人每人都握 3 次，把大家的次數加起來是 7 × 3 = 21。',
          '那麼握手的實際次數就會是 21 ÷ 2，這不是整數。',
          '握手次數必須是整數，不可能是半次，所以這種情況不可能發生。',
        ],
        'zh-Hans' => [
          '每一次握手都是两个人一起完成的，所以把每个人的握手次数全部加起来，会刚好是握手次数的 2 倍。',
          '如果 7 个人每人都握 3 次，把大家的次数加起来是 7 × 3 = 21。',
          '那么握手的实际次数就会是 21 ÷ 2，这不是整数。',
          '握手次数必须是整数，不可能是半次，所以这种情况不可能发生。',
        ],
        'en' => [
          'Every handshake involves two people, so adding up each person\'s number of handshakes gives exactly twice the number of handshakes.',
          'If all 7 people shook hands 3 times, that total would be 7 × 3 = 21.',
          'The actual number of handshakes would then be 21 ÷ 2, which is not a whole number.',
          'The number of handshakes must be a whole number, since half a handshake is impossible, so the situation cannot happen.',
        ],
        'ja' => [
          '握手は必ず 2 人でするので、全員の握手回数をたすとちょうど握手の回数の 2 倍になります。',
          '7 人が全員 3 回ずつ握手したとすると、その合計は 7 × 3 = 21 です。',
          'すると実際の握手の回数は 21 ÷ 2 となり、整数になりません。',
          '握手の回数は整数でなければならず、半回はありえないので、このようなことは起こりません。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '不可能，因為算出來的握手次數不是整數', 'zh-Hans' => '不可能，因为算出来的握手次数不是整数',
                 'en' => 'Impossible, because the number of handshakes would not be whole',
                 'ja' => 'できない。握手の回数が整数にならないから' },
        'B' => { 'zh-Hant' => '可能，只要安排得好就行', 'zh-Hans' => '可能，只要安排得好就行',
                 'en' => 'Possible, with the right arrangement', 'ja' => 'できる。うまく組み合わせればよい' },
        'C' => { 'zh-Hant' => '可能，一共會握 21 次手', 'zh-Hans' => '可能，一共会握 21 次手',
                 'en' => 'Possible, and there would be 21 handshakes', 'ja' => 'できる。握手は全部で 21 回になる' },
        'D' => { 'zh-Hant' => '不可能，因為人數是單數', 'zh-Hans' => '不可能，因为人数是单数',
                 'en' => 'Impossible, because the number of people is odd', 'ja' => 'できない。人数が奇数だから' },
      },
      correct: 'A',
      notes: 'Original composition in the Math Kangaroo grade 1-2 handshake-parity style; option D gives the right verdict with the wrong reason, since an odd number of people is fine when each shakes an even number of hands. Not a reproduction of any past paper.',
    ),
    mc_q(
      topic: 'logic', subtopic: 'counterexample_reasoning',
      prompt: {
        'zh-Hant' => '小安說：「所有的長方形都有 4 條對稱線。」老師說這句話是錯的。下面哪一個例子可以用來說明小安說錯了？',
        'zh-Hans' => '小安说：「所有的长方形都有 4 条对称线。」老师说这句话是错的。下面哪一个例子可以用来说明小安说错了？',
        'en' => 'An says: "Every rectangle has 4 lines of symmetry." The teacher says this is wrong. Which example shows that An is mistaken?',
        'ja' => 'アンさんは「長方形にはどれも対称の軸が 4 本ある」と言いました。先生はそれはまちがいだと言います。アンさんがまちがっていることを示す例はどれですか。',
      },
      answer: { 'zh-Hant' => '舉一個長和寬不一樣長的長方形，它只有 2 條對稱線。',
                'zh-Hans' => '举一个长和宽不一样长的长方形，它只有 2 条对称线。',
                'en' => 'A rectangle whose length and width differ, which has only 2 lines of symmetry.',
                'ja' => '縦と横の長さがちがう長方形。対称の軸は 2 本しかありません。' },
      steps: {
        'zh-Hant' => [
          '要說明「所有的⋯⋯都⋯⋯」這種說法是錯的，只要找到一個不符合的例子就夠了。',
          '正方形也是一種長方形，它確實有 4 條對稱線，所以舉正方形沒有用，那反而支持小安。',
          '三角形和圓形都不是長方形，舉它們也沒有用，因為小安只說長方形。',
          '長和寬不一樣長的長方形，只有通過兩組對邊中點的 2 條對稱線，沒有沿對角線的對稱線。',
          '這正是一個是長方形卻沒有 4 條對稱線的例子，所以能說明小安說錯了。',
        ],
        'zh-Hans' => [
          '要说明「所有的⋯⋯都⋯⋯」这种说法是错的，只要找到一个不符合的例子就够了。',
          '正方形也是一种长方形，它确实有 4 条对称线，所以举正方形没有用，那反而支持小安。',
          '三角形和圆形都不是长方形，举它们也没有用，因为小安只说长方形。',
          '长和宽不一样长的长方形，只有通过两组对边中点的 2 条对称线，没有沿对角线的对称线。',
          '这正是一个是长方形却没有 4 条对称线的例子，所以能说明小安说错了。',
        ],
        'en' => [
          'To show that a claim of the form "every … has …" is wrong, it is enough to find a single example that fails.',
          'A square is a rectangle and does have 4 lines of symmetry, so a square is no use here; it supports An instead.',
          'A triangle and a circle are not rectangles at all, so they are no use either, since An only spoke about rectangles.',
          'A rectangle whose length and width differ has only the 2 lines through the midpoints of opposite sides, and none along its diagonals.',
          'That is exactly a rectangle without 4 lines of symmetry, so it shows An is mistaken.',
        ],
        'ja' => [
          '「すべての……は……だ」という主張がまちがいだと示すには、あてはまらない例を 1 つ見つければ十分です。',
          '正方形も長方形の一種で、対称の軸は確かに 4 本あるので、正方形を挙げても役に立たず、かえってアンさんを支持してしまいます。',
          '三角形や円は長方形ではないので、これらを挙げても意味がありません。アンさんは長方形についてだけ言っているからです。',
          '縦と横の長さがちがう長方形には、向かい合う辺の中点を通る 2 本の軸しかなく、対角線にそった対称の軸はありません。',
          'これはまさに対称の軸が 4 本ない長方形の例なので、アンさんのまちがいを示せます。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '一個長和寬不一樣長的長方形', 'zh-Hans' => '一个长和宽不一样长的长方形',
                 'en' => 'A rectangle whose length and width differ', 'ja' => '縦と横の長さがちがう長方形' },
        'B' => { 'zh-Hant' => '一個正方形', 'zh-Hans' => '一个正方形', 'en' => 'A square', 'ja' => '正方形' },
        'C' => { 'zh-Hant' => '一個正三角形', 'zh-Hans' => '一个正三角形', 'en' => 'An equilateral triangle', 'ja' => '正三角形' },
        'D' => { 'zh-Hant' => '一個圓形', 'zh-Hans' => '一个圆形', 'en' => 'A circle', 'ja' => '円' },
      },
      correct: 'A',
      notes: 'Original composition in the Math Kangaroo grade 1-2 counterexample style; the distractors fail for two different reasons, one being a rectangle that satisfies the claim and two not being rectangles at all. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'queue_order',
      prompt: {
        'zh-Hant' => '小安在排隊買票，他前面有 5 個人。後來又有 3 個人排到隊伍的最後面，接著小安前面有 2 個人離開了隊伍。這時整條隊伍一共有幾個人？',
        'zh-Hans' => '小安在排队买票，他前面有 5 个人。后来又有 3 个人排到队伍的最后面，接着小安前面有 2 个人离开了队伍。这时整条队伍一共有几个人？',
        'en' => 'An is queuing for tickets with 5 people ahead. Later 3 more people join the back of the queue, and then 2 of the people ahead of An leave. How many people are in the whole queue now?',
        'ja' => 'アンさんはチケットの列に並んでいて、前には 5 人います。そのあと 3 人が列の最後尾に加わり、続いてアンさんの前にいた 2 人が列をはなれました。いま列には全部で何人いますか。',
      },
      answer: { 'zh-Hant' => '答案是 7 個人。', 'zh-Hans' => '答案是 7 个人。',
                'en' => 'The answer is 7 people.', 'ja' => '答えは 7 人です。' },
      steps: {
        'zh-Hant' => [
          '一開始隊伍裡有小安前面的 5 個人，再加上小安自己，一共 5 + 1 = 6 個人。',
          '注意小安自己也要算進去，這是最容易漏掉的地方。',
          '後來又來了 3 個人，隊伍變成 6 + 3 = 9 個人。',
          '接著有 2 個人離開，隊伍變成 9 − 2 = 7 個人。',
          '所以現在隊伍一共有 7 個人。',
        ],
        'zh-Hans' => [
          '一开始队伍里有小安前面的 5 个人，再加上小安自己，一共 5 + 1 = 6 个人。',
          '注意小安自己也要算进去，这是最容易漏掉的地方。',
          '后来又来了 3 个人，队伍变成 6 + 3 = 9 个人。',
          '接着有 2 个人离开，队伍变成 9 − 2 = 7 个人。',
          '所以现在队伍一共有 7 个人。',
        ],
        'en' => [
          'At the start the queue holds the 5 people ahead of An plus An, which is 5 + 1 = 6 people.',
          'Counting An is the step most easily missed.',
          'Then 3 more people arrive, making 6 + 3 = 9 people.',
          'Then 2 people leave, making 9 − 2 = 7 people.',
          'So the queue now has 7 people.',
        ],
        'ja' => [
          'はじめ列には、アンさんの前の 5 人とアンさん自身を合わせて 5 + 1 = 6 人います。',
          'アンさん自身を数え忘れやすいので注意します。',
          'そのあと 3 人加わって 6 + 3 = 9 人になります。',
          '続いて 2 人がはなれて 9 − 2 = 7 人になります。',
          'したがっていま列には 7 人います。',
        ],
      },
      value: '7', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 1-2 queue style; the trap is forgetting to count the person themselves before tracking the arrivals and departures. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'scheduling',
      prompt: {
        'zh-Hant' => '媽媽要做一頓飯：切菜要 10 分鐘，煮湯要 20 分鐘，洗碗要 5 分鐘。切菜一定要在煮湯開始之前做完；洗碗可以在煮湯的時候同時做，因為湯在爐子上不需要一直顧著。全部做完最少要幾分鐘？',
        'zh-Hans' => '妈妈要做一顿饭：切菜要 10 分钟，煮汤要 20 分钟，洗碗要 5 分钟。切菜一定要在煮汤开始之前做完；洗碗可以在煮汤的时候同时做，因为汤在炉子上不需要一直顾着。全部做完最少要几分钟？',
        'en' => 'A meal needs three jobs: chopping takes 10 minutes, making soup takes 20 minutes, and washing up takes 5 minutes. The chopping must be finished before the soup starts, but the washing up can be done while the soup cooks, since the soup does not need watching. What is the least total time needed?',
        'ja' => '食事のしたくに 3 つの作業があります。野菜を切るのに 10 分、スープを煮るのに 20 分、皿を洗うのに 5 分かかります。野菜を切るのはスープを煮はじめる前に終えなければなりませんが、皿洗いはスープを煮ている間にできます（スープはずっと見ていなくてよいからです）。全部終えるのに最も少なくて何分かかりますか。',
      },
      answer: { 'zh-Hant' => '答案是 30 分鐘。', 'zh-Hans' => '答案是 30 分钟。',
                'en' => 'The answer is 30 minutes.', 'ja' => '答えは 30 分です。' },
      steps: {
        'zh-Hant' => [
          '切菜必須排在煮湯前面，所以這兩件事只能一件做完再做另一件，時間要相加。',
          '切菜 10 分鐘加上煮湯 20 分鐘，這條路線是 10 + 20 = 30 分鐘。',
          '洗碗可以在煮湯的 20 分鐘裡同時進行，只需要 5 分鐘，煮湯的時間足夠。',
          '所以洗碗不會讓總時間變長，總時間由切菜和煮湯決定。',
          '因此最少要 30 分鐘。',
        ],
        'zh-Hans' => [
          '切菜必须排在煮汤前面，所以这两件事只能一件做完再做另一件，时间要相加。',
          '切菜 10 分钟加上煮汤 20 分钟，这条路线是 10 + 20 = 30 分钟。',
          '洗碗可以在煮汤的 20 分钟里同时进行，只需要 5 分钟，煮汤的时间足够。',
          '所以洗碗不会让总时间变长，总时间由切菜和煮汤决定。',
          '因此最少要 30 分钟。',
        ],
        'en' => [
          'The chopping must come before the soup, so those two jobs must run one after the other and their times add.',
          'Chopping for 10 minutes plus soup for 20 minutes gives 10 + 20 = 30 minutes along that chain.',
          'The washing up can run during the 20 minutes of cooking and needs only 5 minutes, which fits comfortably.',
          'So the washing up does not lengthen the total, which is set by the chopping and the soup.',
          'The least total time is therefore 30 minutes.',
        ],
        'ja' => [
          '野菜を切るのはスープより前でなければならないので、この 2 つは順に行うことになり、時間はたし算になります。',
          '切る 10 分とスープ 20 分で、この流れは 10 + 20 = 30 分です。',
          '皿洗いはスープを煮ている 20 分の間にでき、必要なのは 5 分なので十分におさまります。',
          'したがって皿洗いは全体の時間を長くせず、全体は切る作業とスープで決まります。',
          'よって最も少なくて 30 分です。',
        ],
      },
      value: '30', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 1-2 scheduling style; one job runs in parallel and one is forced to be sequential, so simply adding all three times gives the wrong answer. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'minimal_case',
      prompt: {
        'zh-Hant' => '把 7 顆糖分給三個小朋友，每個人至少要拿到 1 顆，而且三個人拿到的顆數兩兩都不一樣。在符合這些條件的分法中，拿最多的那個人最少可能拿到幾顆？',
        'zh-Hans' => '把 7 颗糖分给三个小朋友，每个人至少要拿到 1 颗，而且三个人拿到的颗数两两都不一样。在符合这些条件的分法中，拿最多的那个人最少可能拿到几颗？',
        'en' => 'Seven sweets are shared among three children so that each child gets at least 1 and no two children get the same number. Among all such sharings, what is the smallest possible number that the child with the most sweets receives?',
        'ja' => 'あめ 7 個を 3 人の子どもに分けます。どの子も 1 個以上もらい、3 人のもらう個数はどの 2 人も異なります。この条件に合う分け方のうち、いちばん多くもらう子の個数は最も少なくて何個ですか。',
      },
      answer: { 'zh-Hant' => '答案是 4 顆。', 'zh-Hans' => '答案是 4 颗。',
                'en' => 'The answer is 4 sweets.', 'ja' => '答えは 4 個です。' },
      steps: {
        'zh-Hant' => [
          '三個人拿的顆數都不一樣，而且每人至少 1 顆，所以三個數是三個不同的正整數。',
          '要讓最多的那個人盡量少，其他兩個人就要盡量少，也就是取最小的兩個不同正整數 1 和 2。',
          '這時最多的人拿 7 − 1 − 2 = 4 顆，分法是 1、2、4，三個數確實兩兩不同。',
          '如果最多的人只拿 3 顆，另外兩人合計要 4 顆且都小於 3、彼此不同，只能是 1 和 2，但 1 + 2 = 3 不是 4，湊不出來。',
          '所以拿最多的人最少要拿 4 顆。',
        ],
        'zh-Hans' => [
          '三个人拿的颗数都不一样，而且每人至少 1 颗，所以三个数是三个不同的正整数。',
          '要让最多的那个人尽量少，其他两个人就要尽量少，也就是取最小的两个不同正整数 1 和 2。',
          '这时最多的人拿 7 − 1 − 2 = 4 颗，分法是 1、2、4，三个数确实两两不同。',
          '如果最多的人只拿 3 颗，另外两人合计要 4 颗且都小于 3、彼此不同，只能是 1 和 2，但 1 + 2 = 3 不是 4，凑不出来。',
          '所以拿最多的人最少要拿 4 颗。',
        ],
        'en' => [
          'The three amounts are different and each is at least 1, so they are three different positive whole numbers.',
          'To make the largest amount as small as possible, the other two should be as small as possible, namely the two smallest different positive numbers 1 and 2.',
          'The largest is then 7 − 1 − 2 = 4, giving the sharing 1, 2, 4, whose three numbers really are all different.',
          'If the largest were only 3, the other two would have to total 4 while both being smaller than 3 and different, so they could only be 1 and 2, but 1 + 2 = 3 rather than 4, which fails.',
          'So the child with the most receives at least 4 sweets.',
        ],
        'ja' => [
          '3 人の個数はすべて異なり、どれも 1 以上なので、3 つの異なる正の整数になります。',
          'いちばん多い人をできるだけ少なくするには、ほかの 2 人をできるだけ少なくします。つまり最小の異なる正の整数 1 と 2 です。',
          'このときいちばん多い人は 7 − 1 − 2 = 4 個で、分け方は 1、2、4 となり 3 つとも異なります。',
          'いちばん多い人が 3 個だとすると、残り 2 人の合計は 4 で、どちらも 3 未満かつ異なるので 1 と 2 しかありませんが、1 + 2 = 3 で 4 になりません。',
          'したがっていちばん多い人は最も少なくて 4 個です。',
        ],
      },
      value: '4', max_digits: 1,
      notes: 'Original composition in the Math Kangaroo grade 1-2 sharing style; this minimises the largest share, which needs both a construction and a proof that one less is impossible, unlike the worst-case drawing item already in this pack. Not a reproduction of any past paper.',
    ),
    mc_q(
      topic: 'logic', subtopic: 'deduction_chain',
      prompt: {
        'zh-Hant' => '媽媽說：「如果下雨，我們就不出門。」今天全家出門了。根據媽媽說的話，下面哪一件事一定正確？',
        'zh-Hans' => '妈妈说：「如果下雨，我们就不出门。」今天全家出门了。根据妈妈说的话，下面哪一件事一定正确？',
        'en' => 'Mum says: "If it rains, we do not go out." Today the family went out. Based on what Mum said, which statement must be true?',
        'ja' => 'お母さんは「雨がふったら出かけない」と言いました。今日は家族で出かけました。お母さんの言ったことから、必ず正しいといえるのはどれですか。',
      },
      answer: { 'zh-Hant' => '今天一定沒有下雨。', 'zh-Hans' => '今天一定没有下雨。',
                'en' => 'It certainly did not rain today.', 'ja' => '今日は雨がふらなかったといえます。' },
      steps: {
        'zh-Hant' => [
          '媽媽的話是說：只要下雨，就一定不會出門。',
          '今天全家出門了，也就是「不出門」這件事沒有發生。',
          '如果今天有下雨，照媽媽的話就一定不會出門，這和事實矛盾。',
          '所以今天一定沒有下雨。',
          '要注意的是，沒下雨不代表一定會出門，媽媽並沒有說「不下雨就一定出門」，所以不能反過來推論。',
        ],
        'zh-Hans' => [
          '妈妈的话是说：只要下雨，就一定不会出门。',
          '今天全家出门了，也就是「不出门」这件事没有发生。',
          '如果今天有下雨，照妈妈的话就一定不会出门，这和事实矛盾。',
          '所以今天一定没有下雨。',
          '要注意的是，没下雨不代表一定会出门，妈妈并没有说「不下雨就一定出门」，所以不能反过来推论。',
        ],
        'en' => [
          'Mum\'s statement says that whenever it rains, the family definitely does not go out.',
          'Today the family did go out, so "not going out" did not happen.',
          'If it had rained today, then by Mum\'s statement they would not have gone out, which contradicts the fact.',
          'So it certainly did not rain today.',
          'Note that no rain does not guarantee going out: Mum never said "if it does not rain we go out", so the reasoning cannot be reversed.',
        ],
        'ja' => [
          'お母さんの言葉は「雨がふれば必ず出かけない」という意味です。',
          '今日は家族で出かけたので、「出かけない」ということは起きていません。',
          'もし今日雨がふっていたら、お母さんの言葉により出かけないはずで、事実と矛盾します。',
          'したがって今日は雨がふらなかったといえます。',
          'なお、雨がふらなければ必ず出かけるとはいえません。お母さんは「雨がふらなければ出かける」とは言っていないので、逆には推論できません。',
        ],
      },
      options: {
        'A' => { 'zh-Hant' => '今天一定沒有下雨', 'zh-Hans' => '今天一定没有下雨',
                 'en' => 'It certainly did not rain today', 'ja' => '今日は雨がふらなかった' },
        'B' => { 'zh-Hant' => '今天一定有下雨', 'zh-Hans' => '今天一定有下雨',
                 'en' => 'It certainly did rain today', 'ja' => '今日は雨がふった' },
        'C' => { 'zh-Hant' => '只要不下雨，全家就一定會出門', 'zh-Hans' => '只要不下雨，全家就一定会出门',
                 'en' => 'Whenever it does not rain, the family goes out', 'ja' => '雨がふらなければ必ず出かける' },
        'D' => { 'zh-Hant' => '無法判斷今天有沒有下雨', 'zh-Hans' => '无法判断今天有没有下雨',
                 'en' => 'Whether it rained today cannot be decided', 'ja' => '今日雨がふったかどうかは決められない' },
      },
      correct: 'A',
      notes: 'Original composition in the Math Kangaroo grade 1-2 conditional style; this asks for the contrapositive, while option C is the converse, which the given statement does not support. Not a reproduction of any past paper.',
    ),
    int_q(
      topic: 'logic', subtopic: 'arrangement',
      prompt: {
        'zh-Hant' => '有 4 張顏色都不一樣的卡片，其中一張是紅色的。要把這 4 張卡片排成一列，規定紅色卡片必須排在第一張或最後一張。這樣的排法一共有幾種？',
        'zh-Hans' => '有 4 张颜色都不一样的卡片，其中一张是红色的。要把这 4 张卡片排成一列，规定红色卡片必须排在第一张或最后一张。这样的排法一共有几种？',
        'en' => 'There are 4 cards, all different colours, one of which is red. The 4 cards are arranged in a row with the red card required to be either first or last. How many such arrangements are there?',
        'ja' => '色がすべてちがう 4 枚のカードがあり、そのうち 1 枚は赤です。この 4 枚を一列に並べますが、赤いカードは 1 番目か 4 番目でなければなりません。並べ方は何通りありますか。',
      },
      answer: { 'zh-Hant' => '答案是 12 種。', 'zh-Hans' => '答案是 12 种。',
                'en' => 'The answer is 12 arrangements.', 'ja' => '答えは 12 通りです。' },
      steps: {
        'zh-Hant' => [
          '先決定紅色卡片放在哪裡，只有第一張和最後一張兩種選擇。',
          '紅色卡片的位置決定後，剩下 3 張不同顏色的卡片要排在剩下的 3 個位置。',
          '3 張不同的卡片排 3 個位置，方法有 3 × 2 × 1 = 6 種。',
          '紅卡的 2 種放法，每一種都可以搭配這 6 種排法。',
          '所以總共有 2 × 6 = 12 種排法。',
        ],
        'zh-Hans' => [
          '先决定红色卡片放在哪里，只有第一张和最后一张两种选择。',
          '红色卡片的位置决定后，剩下 3 张不同颜色的卡片要排在剩下的 3 个位置。',
          '3 张不同的卡片排 3 个位置，方法有 3 × 2 × 1 = 6 种。',
          '红卡的 2 种放法，每一种都可以搭配这 6 种排法。',
          '所以总共有 2 × 6 = 12 种排法。',
        ],
        'en' => [
          'First decide where the red card goes, and there are only two choices, first or last.',
          'Once the red card is placed, the other 3 differently coloured cards fill the remaining 3 places.',
          'Three different cards can fill three places in 3 × 2 × 1 = 6 ways.',
          'Each of the 2 placements of the red card can be combined with each of those 6 orders.',
          'So there are 2 × 6 = 12 arrangements in total.',
        ],
        'ja' => [
          'まず赤いカードの位置を決めますが、1 番目か 4 番目の 2 通りしかありません。',
          '赤いカードの位置が決まると、残り 3 枚の色のちがうカードを残りの 3 か所に並べます。',
          '異なる 3 枚を 3 か所に並べる方法は 3 × 2 × 1 = 6 通りです。',
          '赤いカードの 2 通りの置き方それぞれに、この 6 通りを組み合わせられます。',
          'したがって全部で 2 × 6 = 12 通りです。',
        ],
      },
      value: '12', max_digits: 2,
      notes: 'Original composition in the Math Kangaroo grade 1-2 arrangement style; a positional restriction is handled by fixing the restricted item first, which differs from adjacency-based items. Not a reproduction of any past paper.',
    ),
  ],
}.freeze

counts = {}
QUESTIONS.each do |topic, questions|
  path = PATHS[topic]
  pack = load_json(path)
  serial = pack['questions'].map { |q| q['id'].split('_').last.to_i }.max + 1
  ids = pack['questions'].map { |q| q['id'] }.to_set
  ordered = questions.each_with_index.map do |q, i|
    id = format('%s_%s_foundation_%03d', topic, GRADE, serial + i)
    raise "duplicate id #{id}" if ids.include?(id)

    { 'id' => id }.merge(q)
  end
  pack['questions'].concat(ordered)
  save_json(path, pack)
  counts[path] = pack['questions'].length
  puts "#{File.basename(path)} -> #{pack['questions'].length}"
end

manifest = load_json(MANIFEST_PATH)
manifest['packs'].each do |pack|
  full = File.join(ROOT, pack['path'])
  pack['questionCount'] = counts[full] if counts.key?(full)
end
save_json(MANIFEST_PATH, manifest)
