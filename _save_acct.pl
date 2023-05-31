sub save_acct{
my ($mac,$switch,$port,$vid)=@_;
my $errstr='';

# Вважається, що в таблиці IPSESSION тільки поточні сессії
# Коли сессія закривається, вона переноситься в таблицю IPSESSION.<MONTH>.<YEAR>
# Сессія закривається зовнішним модулєм по таймауту, або отриманню трапа

  # TODO: переробити під шаблон
  my $query='insert into `IPSESSION` ( `mac`,`switch`, `port`, `vid`, `begin`, `updbymba` )
              values ( "'.$mac.'","'.$switch.'","'.$port.'","'.$vid.'",NOW(),NOW() )
              on duplicate key update `updbymba`=now()';
  if (($errstr=&do_db($query)) ne ''){
    &radiusd::radlog(L_ERR, $errstr);
  }
  return;
}

