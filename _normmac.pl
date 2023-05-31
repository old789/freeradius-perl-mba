sub normalizeMAC{
my $a=shift;
my @b=();
my @c=();

  while (length($a) >= 2) {
    @b=split(//,$a,3);
    $a=(scalar(@b)==3)?pop(@b):'';
    push(@c,join('',@b));
  }

  return(lc(join(':',@c)));
}

