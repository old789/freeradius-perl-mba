use strict;
use DBI;
#use Time::Local;
#use POSIX;
use utf8;
use open qw(:std :utf8);

use vars qw(%RAD_REQUEST %RAD_REPLY %RAD_CHECK %conf);

#
# This the remapping of return values
#
use constant    RLM_MODULE_REJECT=>    0;#  /* immediately reject the request */
use constant    RLM_MODULE_FAIL=>      1;#  /* module failed, don't reply */
use constant    RLM_MODULE_OK=>        2;#  /* the module is OK, continue */
use constant    RLM_MODULE_HANDLED=>   3;#  /* the module handled the request, so stop. */
use constant    RLM_MODULE_INVALID=>   4;#  /* the module considers the request invalid. */
use constant    RLM_MODULE_USERLOCK=>  5;#  /* reject the request (user is locked out) */
use constant    RLM_MODULE_NOTFOUND=>  6;#  /* user not found */
use constant    RLM_MODULE_NOOP=>      7;#  /* module succeeded without doing anything */
use constant    RLM_MODULE_UPDATED=>   8;#  /* OK (pairs modified) */
use constant    RLM_MODULE_NUMCODES=>  9;#  /* How many return codes there are */


use constant    L_AUTH=>        2;
use constant    L_INFO=>        3;
use constant    L_ERR=>         4;
use constant    L_WARN=>        5;
use constant    L_PROXY=>       6;
use constant    L_ACCT=>        7;
use constant    L_DBG=>         16;
use constant    L_CONS=>        128;

$conf{'dbhost'}='localhost';
$conf{'dbname'}='vpn';
$conf{'dbuser'}='vpnadm';
$conf{'dbpassword'}='password';
$conf{'dbcharset'}='UTF-8';

require '/usr/local/etc/raddb/mods-config/perl-mba/perl-mba.pl';

my $st=undef;
my $tab_d;
my $show_mysql_error=0;
my $curtime=time();
my %request;

#---------------------------------------------------------------

