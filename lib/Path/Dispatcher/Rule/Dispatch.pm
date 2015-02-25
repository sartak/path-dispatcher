package Path::Dispatcher::Rule::Dispatch;
use Moo;
extends 'Path::Dispatcher::Rule';

has dispatcher => (
    is       => 'ro',
    isa      => sub { die "$_[0] not isa Path::Dispatcher" unless $_[0]->isa('Path::Dispatcher') },
    required => 1,
    handles  => ['rules', 'complete'],
);

sub match {
    my $self = shift;
    my $path = shift;

    my $dispatch = $self->dispatcher->dispatch($path);
    return $dispatch->matches;
}

__PACKAGE__->meta->make_immutable;
no Moo;

1;

__END__

=head1 NAME

Path::Dispatcher::Rule::Dispatch - redispatch

=head1 SYNOPSIS

    my $dispatcher = Path::Dispatcher->new(
        rules => [
            Path::Dispatcher::Rule::Tokens->new(
                tokens => [ 'help' ],
                block  => sub { show_help },
            ),
            Path::Dispatcher::Rule::Tokens->new(
                tokens => [ 'quit' ],
                block  => sub { exit },
            ),
        ],
    );

    my $rule = Path::Dispatcher::Rule::Dispatch->new(
        dispatcher => $dispatcher,
    );

    $rule->run("help");

=head1 DESCRIPTION

Rules of this class use another dispatcher to match the path.

=head1 ATTRIBUTES

=head2 dispatcher

A L<Path::Dispatcher> object. Its matches will be returned by matching this
rule.

=cut

