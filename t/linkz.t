use strict;
use warnings;
use Try::Tiny qw(try catch);
use Test::More tests => 6;

BEGIN { use_ok('WWW::Shorten::Linkz') };

my $url = 'http://www.bbc.co.uk/cult/doctorwho/ebooks/lungbarrow/index.shtml';
my $re = qr{ ^ http:// lin\.kz / \? (\w+) $ }x;

{
    my $err = try { makeashorterlink(); } catch { $_ };
    ok($err, 'makeashorterlink: proper error response');
    $err = undef;

    $err = try { makealongerlink(); } catch { $_ };
    ok($err, 'makealongerlink: proper error response');
}

SKIP: {
  skip 'lin.kz seems to be having trouble at the moment', 3;

  my $shortened;
  like(($shortened = makeashorterlink($url)), $re, 'make it shorter');

  is(makealongerlink($shortened), $url, 'make it longer');

  my ($code) = $shortened =~ $re;
  is (makealongerlink($code), $url, 'make it longer by Id');
}
