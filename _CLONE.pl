sub CLONE{
my $errstr='';

 &radiusd::radlog(L_INFO, 'Running new CLONE');

 if (($errstr=&db_con()) ne ''){
   &radiusd::radlog(L_ERR, $errstr);
   return RLM_MODULE_FAIL;
 }
 return;
}

