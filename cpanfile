# Dependencies by EPICO REST API abstract backend
requires 'boolean';
requires 'Carp';
requires 'Config::IniFiles';
requires 'Log::Log4perl';
requires 'Scalar::Util';

# These are not needed in this project
#requires 'BP::Model', 'v1.1.1';

#requires 'BP::Loader', 'v1.0.3';

#requires 'BP::DCCLoader', 'v1.0.1';

on test => sub {
    requires 'Test::More', '0.96';
};

on develop => sub {
    requires 'Dist::Milla', '1.0.20';
    requires 'Dist::Zilla::Plugin::MakeMaker';
    requires 'Dist::Zilla::Plugin::Prereqs::FromCPANfile';
    requires 'Dist::Zilla::Plugin::Run', '0.048';
    requires 'OrePAN2';
};
