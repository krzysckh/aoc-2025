# -*- mode: raku; raku-indent-offset: 2 -*-

my %m;
for ("input".IO.lines) {
  /(.*) \: ' ' (.*)/;
  %m{$0} = $1.split(' ').cache
}

sub p1 {
  my %seen;
  my $recur = sub {
    my ($it) = @_;
    return 1 if $it eq "out";
    return %seen{$it} if %seen{$it}:exists;
    %seen{$it} //= 0;
    for %m{$it}.[] {
      %seen{$it} += $recur($_);
    }
    %seen{$it}
  };
  $recur("you");
  "p1: %seen{'you'}".say
}

sub p2 {
  # hash of it -> dfstate -> n
  # where dfstate is
  # (fftp<<1)|dacp
  my %seen;

  my $recur = sub {
    my ($it, $dacp, $fftp) = @_;
    $dacp = 1 if $it eq "dac";
    $fftp = 1 if $it eq "fft";
    my $dfstate = ($fftp+<1)+|$dacp;

    if ($it eq "out") {
      return 1 if $dacp and $fftp;
      return 0
    }

    return %seen{$it}{$dfstate} if %seen{$it}:exists and %seen{$it}{$dfstate}:exists;

    %seen{$it} //= {};
    %seen{$it}{$dfstate} //= 0;
    for %m{$it}.[] {
      %seen{$it}{$dfstate} += $recur($_, $dacp, $fftp);
    }
    %seen{$it}{$dfstate}
  };
  $recur("svr", 0, 0);

  "p2: %seen{'svr'}.{0}".say
}

p1;
p2;
