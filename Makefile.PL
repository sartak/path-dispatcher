use inc::Module::Install;
use Module::Install::GithubMeta;
use Module::Install::ManifestSkip;
use Module::Install::AutoManifest;

name       'Path-Dispatcher';
all_from   'lib/Path/Dispatcher.pm';
githubmeta;

requires 'Any::Moose' => '0.12';
requires 'Try::Tiny'  => '0.02';

test_requires 'Test::More'      => '0.88';
test_requires 'Test::Exception' => '0.27';

manifest_skip;
auto_manifest;
WriteAll;

