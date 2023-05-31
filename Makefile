
Targa= perl-mba.pm 

all:
	cat perl-mba_.pm  > $(Targa)
.for i in _*.pl 
	cat $(i) >> $(Targa)
.endfor
	perl -c $(Targa)

install:
	scp $(Targa) test.ic.km.ua:/usr/local/etc/raddb/mods-config/perl-mba/

clean:
	rm $(Targa)
