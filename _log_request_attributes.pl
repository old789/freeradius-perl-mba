sub log_request_attributes {
       # This shouldn't be done in production environments!
       # This is only meant for debugging!
       for (keys %RAD_REQUEST) {
               &radiusd::radlog(1, "RAD_REQUEST: $_ = $RAD_REQUEST{$_}");
       }
}

