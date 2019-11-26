package Path::Dispatcher::Role::Rules;
use Moo::Role;
use Carp qw(confess);
use Types::Standard qw( Str Int ArrayRef HashRef );

has _rules => (
    is       => 'ro',
    isa      => ArrayRef,
    init_arg => 'rules',
    default  => sub { [] },
);

sub add_rule {
    my $self = shift;

    $_->isa('Path::Dispatcher::Rule')
        or confess "$_ is not a Path::Dispatcher::Rule"
            for @_;

    push @{ $self->{_rules} }, @_;
}

sub unshift_rule {
    my $self = shift;

    $_->isa('Path::Dispatcher::Rule')
        or confess "$_ is not a Path::Dispatcher::Rule"
            for @_;

    unshift @{ $self->{_rules} }, @_;
}

sub rules { @{ shift->{_rules} } }

no Moo::Role;

1;

__END__

=head1 NAME

Path::Dispatcher::Role::Rules - "has a list of rules"

=head1 DESCRIPTION

Classes that compose this role get the following things:

=head1 ATTRIBUTES

=head2 _rules

=head1 METHODS

=head2 rules

=head2 add_rule

=cut

