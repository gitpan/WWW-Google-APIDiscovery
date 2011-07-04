package WWW::Google::APIDiscovery;

use Moose;
use MooseX::Params::Validate;
use Moose::Util::TypeConstraints;
use namespace::clean;

use Carp;
use Data::Dumper;

use JSON;
use Readonly;
use HTTP::Request;
use LWP::UserAgent;

our $VERSION = '0.02';
Readonly my $API_VERSION => 'v1';
Readonly my $API =>
{
    'buzz'            => "https://www.googleapis.com/discovery/$API_VERSION/apis/buzz/v1/rest",
    'customsearch'    => "https://www.googleapis.com/discovery/$API_VERSION/apis/customsearch/v1/rest",    
    'diacritize'      => "https://www.googleapis.com/discovery/$API_VERSION/apis/diacritize/v1/rest",    
    'moderator'       => "https://www.googleapis.com/discovery/$API_VERSION/apis/moderator/v1/rest",    
    'pagespeedonline' => "https://www.googleapis.com/discovery/$API_VERSION/apis/pagespeedonline/v1/rest",
    'prediction'      => "https://www.googleapis.com/discovery/$API_VERSION/apis/prediction/v1.2/rest",
    'urlshortener'    => "https://www.googleapis.com/discovery/$API_VERSION/apis/urlshortener/v1/rest",
};

=head1 NAME

WWW::Google::APIDiscovery - Interface to Google API Discovery Service.

=head1 VERSION

Version 0.01

=cut

=head1 DESCRIPTION

The Google APIs Discovery Service allows you to interact with Google APIs by exposing machine
readable metadata about other Google APIs through a simple API. Currently supports version v1.

IMPORTANT:The version v1 of the Google APIs Discovery Service is in Labs & its features might
change unexpectedly until it graduates.

    +----------------------------------+
    | Supported APIs                   |
    +----------------------------------+
    | Google Buzz                      |
    | Google Custom Search             | 
    | Google Diacritize                | 
    | Google Page Speed Online         |
    | Google Prediction                |
    | Google URL Shortener             |
    +----------------------------------+

=head1 CONSTRUCTOR

The constructor expects the name of API, you want to know about. Below is valid list of keys.

    +-----------------+---------------------------+
    | Key             |                           |
    +-----------------+---------------------------+
    | buzz            | Google Buzz               | 
    | customsearch    | Google Custom Search      | 
    | diacritize      | Google Diacritize         | 
    | pagespeedonline | Google Page Speed Online  | 
    | prediction      | Google Prediction         |
    | urlshortener    | Google URL Shortener      | 
    +-----------------+---------------------------+

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my ($api);
    $api = WWW::Google::APIDiscovery->new('buzz');
    # or
    $api = WWW::Google::APIDiscovery->new(api => 'buzz');
    # or
    $api = WWW::Google::APIDiscovery->new({api => 'buzz'});

=cut

type 'APIFamily' => where { exists($API->{lc($_)}) };
has  'api'       => (is => 'ro', isa => 'APIFamily', default => 'buzz');
has  'browser'   => (is => 'rw', isa => 'LWP::UserAgent', default => sub { return LWP::UserAgent->new(agent => 'Mozilla/5.0'); });

around BUILDARGS => sub
{
    my $orig  = shift;
    my $class = shift;

    if (@_ == 1 && ! ref $_[0])
    {
        return $class->$orig(api => $_[0]);
    }
    else
    {
        return $class->$orig(@_);
    }
};

=head1 METHODS

=head2 discover()

Returns everything about the given API.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    my $result = $api->discover();

=cut

sub discover
{
    my $self     = shift;
    my $browser  = $self->browser;
    my $url      = $API->{$self->api};
    my $request  = HTTP::Request->new(GET => $url);
    my $response = $browser->request($request);
    croak("ERROR: Couldn't fetch url [$url][".$response->status_line."]\n")
        unless $response->is_success;
    $self->{content} = from_json($response->content);
    return $self->{content};
}

=head2 get_resources()

Returns resource details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $resources = $api->get_resources();

=cut

sub get_resources
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{resources});
    return $self->{content}->{resources};
}

=head2 get_protocol()

Returns protocol, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $protocol = $api->get_protocol();

=cut

sub get_protocol
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{protocol});
    return $self->{content}->{protocol};
}

=head2 get_features()

Returns features, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $features = $api->get_features();

=cut

sub get_features
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{features});
    return $self->{content}->{features};
}

=head2 get_version()

Returns version, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $version = $api->get_version();

=cut

sub get_version
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{version});
    return $self->{content}->{version};
}

=head2 get_name()

Returns name, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $name = $api->get_name();

=cut

sub get_name
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{name});
    return $self->{content}->{name};
}

=head2 get_icons()

Returns icons details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $icons = $api->get_icons();

=cut

sub get_icons
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{icons});
    return $self->{content}->{icons};
}

=head2 get_description()

Returns description, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $description = $api->get_description();

=cut

sub get_description
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{description});
    return $self->{content}->{description};
}

=head2 get_base_path()

Returns base path, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $base_path = $api->get_base_path();

=cut

sub get_base_path
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{basePath});
    return $self->{content}->{basePath};
}

=head2 get_auth()

Returns auth details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $auth = $api->get_auth();

=cut

sub get_auth
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{auth});
    return $self->{content}->{auth};
}

=head2 get_kind()

Returns kind details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $kind = $api->get_kind();

=cut

sub get_kind
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{kind});
    return $self->{content}->{kind};
}

=head2 get_schemas()

Returns schemas details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $schemas = $api->get_schemas();

=cut

sub get_schemas
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{schemas});
    return $self->{content}->{schemas};
}

=head2 get_id()

Returns id, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $id = $api->get_id();

=cut

sub get_id
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{id});
    return $self->{content}->{id};
}

=head2 get_title()

Returns title, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $title = $api->get_title();

=cut

sub get_title
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{title});
    return $self->{content}->{title};
}

=head2 get_labels()

Returns labels details, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $labels = $api->get_labels();

=cut

sub get_labels
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{labels});
    return $self->{content}->{labels};
}

=head2 get_documentation_link()

Returns documentation link, if found.

    use strict; use warnings;
    use WWW::Google::APIDiscovery;
    
    my $api = WWW::Google::APIDiscovery->new('buzz');
    $api->discover();
    my $link = $api->get_documentation_link();

=cut

sub get_documentation_link
{
    my $self = shift;
    return 'Not defined' unless (defined($self->{content}) && exists $self->{content}->{documentationLink});
    return $self->{content}->{documentationLink};
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-apidiscovery at rt.cpan.org> or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-APIDiscovery>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::APIDiscovery

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

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

=head1 DISCLAIMER

This  program  is  distributed in the hope that it will be useful,  but  WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

__PACKAGE__->meta->make_immutable;
no Moose; # Keywords are removed from the WWW::Google::APIDiscovery package

1; # End of WWW::Google::APIDiscovery