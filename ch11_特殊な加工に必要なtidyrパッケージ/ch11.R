# 11章 特殊な加工に必要なtidyrパッケージ------------------------------

## 11.1 複数の列を1つにまとめよう----------------------------

# 表を作る
dat <- tibble(
  a = c("a", "b", "c", "d"),
  b = c(1:4),
  c = c("A", "B", "C", "D")
)

# mutate()を利用して2つの列を結合して1つだけ残す
dat %>%
  mutate(z = str_c(a, b, c, sep = "_")) %>%
  select(z)

# unite()を利用すると、unite(新しい列名, 結合したい列名)で結合できる
dat %>% unite("z", a, b, c)

# sep引数で結合する文字を変更
dat %>% unite(col = "z", a, b, c, sep = "--@--")

# remove引数で結合に利用した列を残すか決定
dat %>% unite("z", a, b, c, remove = TRUE)
dat %>% unite("z", a, b, c, remove = FALSE)

# b列が2であれば欠損値へ。
dat <- dat %>% mutate(b = if_else(b == 2, NA_integer_, b))

# unite()を利用して変数`z1`と`z2`を作成
dat %>%
  unite("z1", a, b, c, na.rm = FALSE, remove = FALSE) %>%
  unite("z2", a, b, c, na.rm = TRUE, remove = FALSE)

# 氏名が分かれて保存されているデータ
dat <- tibble(si = c("山田", "西田", "鈴木"), mei = c("太郎", "典充", "花子"))

dat %>%
  unite("simei", si, mei, sep = " ", remove = FALSE)

## 11.2 複数の列に分割しよう--------------------------

### 11.2.1 列を分割しよう--------------------------

# 氏名列を含んだデータ
dat <- tibble(simei = c("山田 太郎", "西田 典充", "鈴木 花子"))

# separate()で2つに分ける
dat %>%
  separate(
    col = "simei",
    into = c("si", "mei"),
    sep = "\\s",
    remove = FALSE
  )

# 関数の動作を確認するためのデータを作成
dat <- tibble(z = c("12ab/cd@ef", "34gh@ij/kl", "56mn@op#qr"))
dat

# デフォルトでは記号で勝手にくぎってくれる
dat %>%
  separate("z", into = c("w", "x", "y"), remove = FALSE)

# sep引数でどの記号やパターンで区切るかを設定できる
dat %>%
  separate(
    col    = "z",
    into   = c("x", "y"),
    sep    = "@",
    remove = FALSE
  )

# sep引数は正規表現を利用することも可能（\\Dは数字以外を表す）
dat %>%
  separate(
    col    = "z",
    into   = c("num", "text"),
    sep    = "(?<=\\d)(?=\\D)",
    remove = FALSE
  )

#convert引数を利用すると自動的に数字型などに変換してくれる
dat %>%
  separate(
    col     = "z",
    convert = TRUE,
    into    = c("num", "text"),
    sep     = "(?<=\\d)(?=\\D)",
    remove  = FALSE
  )

# 要素数が一致しないデータを作成
dat <- tibble(z = c("1a/2b", "1c/2d/3e", "1f/2g/3h/4i"))
dat

# intoで作成する列名の長さが足りないと、警告後、
# 収まりきらない要素が除外
# （extra="warn"がデフォルト設定）
dat %>%
  separate(col = "z", into = c("c1", "c2"), remove = FALSE)

# 警告なしで除去したければ、extra引数をdropと設定
dat %>%
  separate(
    col    = "z",
    into   = c("c1", "c2"),
    remove = FALSE,
    extra  = "drop"
  )

# 除去せずに、余分なものを最後の列にくっつけて残すにはextra引数をmergeと設定
dat %>%
  separate(
    col    = "z",
    into   = c("c1", "c2"),
    remove = FALSE,
    extra  = "merge"
  )

# into引数でやや長めに分割後の列を作成
# 警告後、NAが挿入される
# （fill = "warn"がデフォルト設定）
dat %>%
  separate(
    col    = "z",
    into   = c("c1", "c2", "c3", "c4", "c5"),
    remove = FALSE
  )

# どちらにNAを「つめて」列を埋めるかはrightとleftで設定可能
intocol <- c("c1", "c2", "c3", "c4")
dat %>% separate(col = "z", into = intocol, remove = FALSE, fill = "right")
dat %>% separate(col = "z", into = intocol, remove = FALSE, fill = "left")

### 11.2.2 要素を抽出して列を作ろう--------------------

# 住所データから郵便番号を抜き出す
# 架空の表データを作成
dat <- tibble(z = c(
  "〒123-4567北海道蝦夷市大木井町11-23-450",
  "〒123-4568東京都町田市中町3-21-451",
  "〒123-4569京都府京都市中京区小町100-10-452",
  "〒123-4560沖縄県琉球市海町132-93-20"
))

# 郵便番号を取り出す
dat %>%
  extract(z, into = c("yubin", "hoka"), remove = FALSE,
          regex = "〒(\\d+-\\d+)(.+)")

## 11.3 欠損値を好きな値に変換しよう--------------------------

### 11.3.1 欠損値を埋めよう--------------------------

# 表の作成
dat <- tibble(
  c1 = c(1, 2, NA, 3, NA, 4),
  c2 = c("a", NA, "b", NA, "c", "d")
)
dat

# ベクトルに適応する書き方の場合はmutate()と一緒に利用する
dat %>%
  mutate(c1 = replace_na(c1, replace = "C1が欠損!"),
         c2 = replace_na(c2, "C2が欠損!"))

# 表に適応するときは、list()を利用してまとめて指定する
dat %>%
  replace_na(replace = list(c1 = "C1欠損", c2 = "C2欠損"))

### 11.3.2 データをリストとして保持しよう--------------------------

# リストオブジェクトを作成する
l <- list("文字", 123.4, 123L, TRUE)
l

# リストオブジェクトからオブジェクトを取り出すには[[番号]]を利用する
l[[1]]
l[[2]]

# いろいろなオブジェクトをリストに入れてみる
l2 <- list(l, c(1:5), tibble(a = 1:3, b = 1:3))
l2

# tibbleを作る要領で、名前付きリストを作成可能
l3 <- list(c1 = "値1", c2 = "値2")

# 名前付きリストは、[[]]を利用することで数字だけでなく、名前での要素の指定も可能
l3[["c2"]]

# 名前付きベクトルも作成可能
vec2 <- c(one = 1, two = 2, three = 3)

#名前付きベクトルも、名前での要素指定が可能
vec2["one"]

## 11.4 欠損値を埋めよう------------------

# 表の作成
dat <- tibble(
  company = c("32 ice cream", rep(NA, 8)),
  tenpo   = c("A", NA, NA, "B", NA, NA, "C", NA, NA),
  rank    = rep(1:3, 3),
  aji     = c("バニラ", "抹茶", "小豆", "チョコ", "いちご",
              "抹茶", "バニラ", "チョコ", "抹茶")
)
dat

# fill()で欠損値を直前の値でうめる
dat %>% fill(tenpo)

# fill()で複数列を埋めることも可能
dat %>% fill(company, tenpo)

## 11.5 欠損値を好きな文字に置き換えよう---------------------

# 意図的なNA以外での欠損の例
dat <- tibble(
  tenpo = c("A", " ", " ", "B", " ", " "),
  rank = rep(1:3, 2)
)
dat

#na_if()で空白の値をNAに置き換える。
dat %>% mutate(tenpo = na_if(tenpo, " "))