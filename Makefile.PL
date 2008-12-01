use inc::Module::Install;

name 'SmellaTorrent';
all_from 'lib/SmellaTorrent.pm';

requires 'Catalyst::Runtime' => '5.7010';
requires 'Catalyst::Plugin::ConfigLoader';
requires 'Catalyst::Plugin::Static::Simple';
requires 'Catalyst::Action::RenderView';
requires 'Catalyst::Model::XMLRPC';
requires 'Catalyst::View::TT';
requires 'Catalyst::Plugin::Authentication::Credential::HTTP';
requires 'YAML'; # This should reflect the config file format you've chosen
                 # See Catalyst::Plugin::ConfigLoader for supported formats
catalyst;

install_script glob('script/*.pl');
auto_install;
WriteAll;
