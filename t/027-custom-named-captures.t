use strict;
use warnings;
use Test::More;
use Path::Dispatcher;

{
    package My::Rule::NamedEnum;
    use Moo;
    extends 'Path::Dispatcher::Rule';

    has name => (
        is       => 'ro',
        required => 1,
    );

    has regex => (
        is       => 'ro',
        isa      => sub{ die "not a regex" unless 'Regexp' eq ref $_[0] },
        required => 1,
    );

    sub _match {
        my $self = shift;
        my $path = shift;

        return unless $path =~ $self->regex;

        return {
            named_captures => {
                $self->name => $&,
            },
        };
    }
}

my $dispatcher = Path::Dispatcher->new(
    rules => [
        My::Rule::NamedEnum->new(
            name  => 'hoo-ah',
            regex => qr/^\w+::/,
            block => sub { shift },
        )
    ],
);

my $match = $dispatcher->run("Foo::Bar");
is_deeply($match->positional_captures, []);
is_deeply($match->named_captures, { "hoo-ah" => "Foo::" });

done_testing;

