#show: letter.with(
$if(sender)$
  sender: [$sender$],
$endif$
$if(recipient)$
  recipient: [$recipient$],
$endif$
$if(sent)$
  date: [$sent$],
$endif$
$if(subject)$
  subject: [$subject$],
$endif$
$if(name)$
  name: [$name$],
$endif$
)
