package Path::Dispatcher::Rule::Eq;
use Moo;

extends 'Path::Dispatcher::Rule';

has string => (
    is       => 'ro',
    isa      => sub { die "$_[0] is not a String" unless( defined $_[0] && '' eq ref $_[0] ) },
    required => 1,
);

# '' or 0 will be accepted for false, 1 for true.
has case_sensitive => (
    is      => 'ro',
    isa     => sub { die "$_[0] is not Bool" unless( ( $_[0] == !!$_[0] ) or ( 0 == $_[0] ) ) },
    default => 1,
);

sub _match {
    my $self = shift;
    my $path = shift;

    if ($self->case_sensitive) {
        return unless $path->path eq $self->string;
    }
    else {
        return unless lc($path->path) eq lc($self->string);
    }

    return {};
}

sub _prefix_match {
    my $self = shift;
    my $path = shift;

    my $truncated = substr($path->path, 0, length($self->string));

    if ($self->case_sensitive) {
        return unless $truncated eq $self->string;
    }
    else {
        return unless lc($truncated) eq lc($self->string);
    }

    return {
        leftover => substr($path->path, length($self->string)),
    };
}

sub complete {
    my $self = shift;
    my $path = shift->path;
    my $completed = $self->string;

    # by convention, complete does include the path itself if it
    # is a complete match
    return if length($path) >= length($completed);

    my $partial = substr($completed, 0, length($path));
    if ($self->case_sensitive) {
        return unless $partial eq $path;
    }
    else {
        return unless lc($partial) eq lc($path);
    }

    return $completed;
}

__PACKAGE__->meta->make_immutable;
no Moo;

1;

__END__

=head1 NAME

Path::Dispatcher::Rule::Eq - predicate is a string equality

=head1 SYNOPSIS

    my $rule = Path::Dispatcher::Rule::Eq->new(
        string => 'comment',
        block  => sub { display_comment(shift->pos(1)) },
    );

=head1 DESCRIPTION

Rules of this class simply check whether the string is equal to the path.

=head1 ATTRIBUTES

=head2 string

=cut

