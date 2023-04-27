#show: book.with(
$if(title)$
  title: "$title$",
$endif$
$if(author)$
  author: "$author$",
$endif$
$if(dedication)$
  dedication: [$dedication$],
$endif$
$if(publishing-info)$
  publishing-info: [$publishing-info$],
$endif$
)
