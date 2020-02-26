package Path::Dispatcher::Rule::Chain;
use Moo;
extends 'Path::Dispatcher::Rule::Always';

around payload => sub {
    my $orig    = shift;
    my $self    = shift;
    my $payload = $self->$orig(@_);

    if (!@_) {
        return sub {
            $payload->(@_);
            die "Path::Dispatcher next rule\n"; # FIXME From Path::Dispatcher::Declarative... maybe this should go in a common place?
        };
    }

    return $payload;
};

__PACKAGE__->meta->make_immutable;
no Moo;

1;

