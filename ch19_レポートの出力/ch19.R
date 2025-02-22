# 19章 レポートの出力---------------------------------

# 19.1 R Markdownでレポート作成しよう---------------------------------

## 19.1.1 R MarkdownからWord ファイルを生成しよう---------------------------------

## 19.1.2 Markdownとは---------------------------------

## 19.1.3 R Markdown とは---------------------------------

## 19.2 Rでグラフを書こう---------------------------------

# ベクトルから棒グラフを作成する
vec <- c(10, 20, 30, 13)

barplot(vec,
        xlab = "x軸のラベル",
        ylab = "y軸のラベル",
        main = "グラフのタイトル")

# ベクトル2つを使って散布図を作成
vec1 <- c(1, 2, 3, 2, 3, 4, 5)
vec2 <- c(4, 3, 2, 5, 1, 2, 1)

plot(vec1, vec2)

# ベクトルからヒストグラムを作成する
set.seed(12345)
vec <- rnorm(1000, 0, 1)

hist(vec)

## 19.3 kable 関数でキレイな表を出力しよう---------------------------------

# knitr::kable()でMarkdownの表を出力する
hyou <- tibble(a = 1:3, b = c("a", "b", "c"))
knitr::kable(hyou)

## 19.4 レポートを実際に出力してみる---------------------------------
