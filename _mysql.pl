sub db_con{ # коннектимся к базе данных
my %attr=( 'PrintError' => $show_mysql_error, 'PrintWarn' => $show_mysql_error, 'mysql_auto_reconnect' => 1, 'mysql_enable_utf8' => 1 );
 $st=DBI->connect_cached('DBI:mysql:'.$conf{'dbname'}.':'.$conf{'dbhost'},$conf{'dbuser'},$conf{'dbpassword'},\%attr);
 if ( ! $st ) {
   return('Not connect 2 DB "'.$conf{'dbname'}.'" on host "'.$conf{'dbhost'}.'" ("'.$DBI::errstr.'")');
 }
 return('');
}

sub get_all{
 my ($ref,$query)=@_;
 ${$ref}=$st->selectall_arrayref($query);
 if ($st->err) { return($st->errstr)}
 if (!defined(${$ref})) {return ('DBI return undefined array')}
 return ('');
}

sub get_data{
my ($query)=@_;
 $tab_d=$st->prepare($query) || return($st->errstr);
 $tab_d->execute || return($tab_d->errstr);
 if ($tab_d->rows < 1) { return('No data found'); }
 return('');
}

sub get_data_z{
my ($query)=@_;
 $tab_d=$st->prepare($query) || return($st->errstr);
 $tab_d->execute || return($tab_d->errstr);
 return('');
}

sub do_db{
my ($query)=@_;
my $res=$st->do($query);
 if ($st->err) { return ($st->errstr)}
 if (!defined($res)) {return ('DBI return undefined value')}
 return('');
}

sub do_dbr{
my ($rc,$query)=@_;
my $res=$st->do($query);
 if ($st->err) { return ($st->errstr)}
 if (!defined($res)) {return ('DBI return undefined value')}
 ${$rc}=$res;
 return('');
}

sub get_id{
my ($query,$res)=@_;
my $err_msg;

 if ($err_msg=&get_data($query)) {return($err_msg);}
 (${$res})=$tab_d->fetchrow_array;
 return('');
}

