sub authorize {
my $errstr='';
my $rc='';
my $mac='';
my $query='';
my $vid=0;
my $mbamode=0;

  $curtime=time();
  &log_request_attributes();

  unless(exists($RAD_REQUEST{'User-Name'})){
    $errstr='Request without "User-Name"';
    &radiusd::radlog(L_ERR, $errstr);
    return RLM_MODULE_INVALID;
  }

  unless(exists($RAD_REQUEST{'NAS-IP-Address'})){
    $errstr='Request without "NAS-IP-Address"';
    &radiusd::radlog(L_ERR, $errstr);
    return RLM_MODULE_INVALID;
  }

  unless(exists($RAD_REQUEST{'NAS-Port'})){
    $errstr='Request without "NAS-Port"';
    &radiusd::radlog(L_ERR, $errstr);
    return RLM_MODULE_INVALID;
  }

  # TODO: переробити це під окрему таблицю і під шаблон
  if ( $conf{'port_based_mba_enable'} == 1 ) {
    $query='select `vid`, `mbamode`
            from `ACCESS_PORT`
            where `port` ="'.$RAD_REQUEST{'NAS-Port'}.'"
              and `ipsw`="'.$RAD_REQUEST{'NAS-IP-Address'}.'"';
    #&radiusd::radlog(L_DBG, $query);
    if (($errstr=&get_data_z($query)) ne ''){
      &radiusd::radlog(L_ERR, $errstr);
      return RLM_MODULE_FAIL;
    }
    if ($tab_d->rows < 1){
      $errstr='MAC based access control request from the unknown device '.$RAD_REQUEST{'NAS-IP-Address'};
      &radiusd::radlog(L_ERR, $errstr);
      return RLM_MODULE_NOOP;
    }else{
      ($vid,$mbamode)=$tab_d->fetchrow_array;
      if ( $mbamode < 1 ) {
        $errstr='Port '.$RAD_REQUEST{'NAS-Port'}.' on the device '.$RAD_REQUEST{'NAS-IP-Address'}.' marked as non MAC based access control.';
        &radiusd::radlog(L_ERR, $errstr);
        return RLM_MODULE_NOOP;
      }
    }
  }

  $mac=&normalizeMAC($RAD_REQUEST{'User-Name'});

  if ( $mbamode != 2 ) {
    $query='select `vid` from `ID_USER` where `mac`="'.$mac.'" and `vid` > 0';
    #&radiusd::radlog(L_DBG, $query);
    if (($errstr=&get_data_z($query)) ne ''){
      &radiusd::radlog(L_ERR, $errstr);
      return RLM_MODULE_FAIL;
    }
    if ($tab_d->rows < 1){
      $errstr='MAC '.$mac.' is not allowed on '.$RAD_REQUEST{'NAS-Port'}.' port of switch '.$RAD_REQUEST{'NAS-IP-Address'};
      &radiusd::radlog(L_DBG, $errstr);
      return RLM_MODULE_NOOP;
    }else{
      ($vid)=$tab_d->fetchrow_array;
    }
  }

  $RAD_CHECK{'Cleartext-Password'}=$conf{'defMACpassw'};
  $RAD_REPLY{'Tunnel-Medium-Type'}='6';
  $RAD_REPLY{'Tunnel-Type'}='Vlan';
  $RAD_REPLY{'Tunnel-Private-Group-Id'}=sprintf("%s",$vid);
  &save_acct($mac,$RAD_REQUEST{'NAS-IP-Address'},$RAD_REQUEST{'NAS-Port'},$vid);
  return RLM_MODULE_OK;
}

