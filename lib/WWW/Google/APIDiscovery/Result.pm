package WWW::Google::APIDiscovery::Result;

use Carp;
use Data::Dumper;

use Moose;

=head1 NAME

WWW::Google::APIDiscovery::Result - Result handler for the module WWW::Google::APIDiscovery.

=head1 VERSION

Version 0.05

=cut

our $VERSION = '0.05';

=head1 DESCRIPTION

Result handler for the module L<WWW::Google::APIDiscovery> & exposes the result data to user.

=cut

has 'result'          => (is => 'rw', isa => 'HashRef', required => 1);
has 'api_resources'   => (is => 'ro', isa => 'HashRef');
has 'api_icons'       => (is => 'ro', isa => 'HashRef');
has 'api_auth'        => (is => 'ro', isa => 'HashRef');
has 'api_schemas'     => (is => 'ro', isa => 'HashRef');
has 'api_labels'      => (is => 'ro', isa => 'ArrayRef');
has 'api_features'    => (is => 'ro', isa => 'ArrayRef');
has 'api_protocol'    => (is => 'ro', isa => 'Str');
has 'api_version'     => (is => 'ro', isa => 'Str');
has 'api_name'        => (is => 'ro', isa => 'Str');
has 'api_description' => (is => 'ro', isa => 'Str');
has 'api_base_path'   => (is => 'ro', isa => 'Str');
has 'api_kind'        => (is => 'ro', isa => 'Str');
has 'api_id'          => (is => 'ro', isa => 'Str');
has 'api_title'       => (is => 'ro', isa => 'Str');
has 'api_documentation_link' => (is => 'ro', isa => 'Str');

around BUILDARGS => sub
{
    my $orig  = shift;
    my $class = shift;

    return $class->$orig(result => $_[0]);
};

sub BUILD
{
    my $self = shift;

    my $result = $self->result;
    $self->{'api_resources'} = $result->{resources}
        if defined($result->{resources});
    $self->{'api_protocol'} = $result->{protocol}
        if defined($result->{protocol});
    $self->{'api_features'} = $result->{features}
        if defined($result->{features});
    $self->{'api_version'} = $result->{version}
        if defined($result->{version});
    $self->{'api_name'} = $result->{name}
        if defined($result->{name});
    $self->{'api_icons'} = $result->{icons}
        if defined($result->{icons});
    $self->{'api_description'} = $result->{description}
        if defined($result->{description});
    $self->{'api_base_path'} = $result->{basePath}
        if defined($result->{basePath});
    $self->{'api_auth'} = $result->{auth}
        if defined($result->{auth});
    $self->{'api_kind'} = $result->{kind}
        if defined($result->{kind});
    $self->{'api_schemas'} = $result->{schemas}
        if defined($result->{schemas});
    $self->{'api_id'} = $result->{id}
        if defined($result->{id});
    $self->{'api_title'} = $result->{title}
        if defined($result->{title});
    $self->{'api_labels'} = $result->{labels}
        if defined($result->{labels});
    $self->{'api_documentation_link'} = $result->{documentationLink}
        if defined($result->{documentationLink});
}

=head1 METHODS

=head2 api_id()

Returns the API Id.

=head2 api_title()

Returns the API Title.

=head2 api_name()

Returns the API Name.

=head2 api_description()

Returns the API Description.

=head2 api_protocol()

Returns the API Protocol.

=head2 api_version()

Returns the API Version.

=head2 api_base_path()

Returns the API Base Path.

=head2 api_kind()

Returns the API Kind.

=head2 api_resources()

Returns the API Resources information as HashRef.

=head2 api_icons()

Returns the API Icons information as HashRef.

=head2 api_auth()

Returns the API Authorization information as HashRef.

=head2 api_schemas()

Returns the API Schemas information as HashRef.

=head2 api_labels()

Returns the API Labels information as ArrayRef.

=head2 api_features()

Returns the API Features information as ArrayRef.

=head2 api_documentation_link()

Returns the API Documentation Link.

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-apidiscovery at rt.cpan.org> or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-APIDiscovery>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::APIDiscovery::Result

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-APIDiscovery>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-APIDiscovery>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-APIDiscovery>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-APIDiscovery/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Moose; # Keywords are removed from the WWW::Google::APIDiscovery::Result package

1; # End of WWW::Google::APIDiscovery::Result