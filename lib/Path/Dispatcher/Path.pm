package Path::Dispatcher::Path;
use Moo;

use overload q{""} => sub { shift->path };

has path => (
    is        => 'ro',
    isa       => sub { die "$_[0] is not a String" unless( defined $_[0] && '' eq ref $_[0] ) },
    predicate => 'has_path',
);

has metadata => (
    is        => 'ro',
    isa       => sub { die "not an ArrayRef" unless 'HASH' eq ref $_[0] },
    predicate => 'has_metadata',
);

# allow Path::Dispatcher::Path->new($path)
around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    if (@_ == 1 && !ref($_[0])) {
        unshift @_, 'path';
    }

    $self->$orig(@_);
};

sub clone_path {
    my $self = shift;
    my $path = shift;

    return $self->meta->clone_object($self, path => $path, @_);
}

sub get_metadata {
    my $self = shift;
    my $name = shift;

    return $self->metadata->{$name};
}

__PACKAGE__->meta->make_immutable;
no Moo;

1;

__END__

=head1 NAME

Path::Dispatcher::Path - path and some optional metadata

=head1 SYNOPSIS

    my $path = Path::Dispatcher::Path->new(
        path     => "/REST/Ticket/1",
        metadata => {
            http_method => "DELETE",
        },
    );

    $path->path;                        # /REST/Ticket/1
    $path->get_metadata("http_method"); # DELETE

=head1 ATTRIBUTES

=head2 path

A string representing the path. C<Path::Dispatcher::Path> is basically a boxed
string. :)

=head2 metadata

A hash representing arbitrary metadata. The L<Path::Dispatcher::Rule::Metadata>
rule is designed to match against members of this hash.

=cut

