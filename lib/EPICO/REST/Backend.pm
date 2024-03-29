#!/usr/bin/perl

# EPICO REST API abstract backend
# José María Fernández (jose.m.fernandez@bsc.es)
# LGPL 2.1 or later license

use v5.12;
use strict;
use warnings 'all';

# All the backends must inherit from this class, and implement its API
package EPICO::REST::Backend;

use version;

our $VERSION = version->declare('v2.0.2');

use boolean qw();
use Carp;
use Config::IniFiles;
use Log::Log4perl;
use Scalar::Util qw();

use constant	TYPE_ID	=>	'_type';

use constant {
	SAMPLE_TRACKING_DATA_CONCEPT_DOMAIN_NAME	=>	'sdata',
	LABORATORY_EXPERIMENTS_CONCEPT_DOMAIN_NAME	=>	'lab',
	EXTERNAL_CONCEPT_DOMAIN_NAME	=>	'external',
	EXPRESSION_CONCEPT_DOMAIN_NAME	=>	'exp',
};

use constant {
	DLAT_CONCEPT_DOMAIN_NAME	=>	'dlat',
	EXPG_CONCEPT_DOMAIN_NAME	=>	EXPRESSION_CONCEPT_DOMAIN_NAME(),
	EXPT_CONCEPT_DOMAIN_NAME	=>	EXPRESSION_CONCEPT_DOMAIN_NAME(),
	RREG_CONCEPT_DOMAIN_NAME	=>	'rreg',
	PDNA_CONCEPT_DOMAIN_NAME	=>	'pdna',
};

use constant {
	DONOR_CONCEPT_NAME	=>	'donor',
	SPECIMEN_CONCEPT_NAME	=>	'specimen',
	SAMPLE_CONCEPT_NAME	=>	'sample',
	FEATURES_CONCEPT_NAME	=>	'features',
	
	METADATA_CONCEPT_NAME	=>	'm',
	
	DLAT_CONCEPT_NAME	=>	'mr',
	EXPG_CONCEPT_NAME	=>	'g',
	EXPT_CONCEPT_NAME	=>	't',
	RREG_CONCEPT_NAME	=>	'p',
	PDNA_CONCEPT_NAME	=>	'p',
};

use constant {
	DONOR_CONCEPT_TYPE	=>	SAMPLE_TRACKING_DATA_CONCEPT_DOMAIN_NAME() . '.' . DONOR_CONCEPT_NAME(),
	SPECIMEN_CONCEPT_TYPE	=>	SAMPLE_TRACKING_DATA_CONCEPT_DOMAIN_NAME() . '.' . SPECIMEN_CONCEPT_NAME(),
	SAMPLE_CONCEPT_TYPE	=>	SAMPLE_TRACKING_DATA_CONCEPT_DOMAIN_NAME() . '.' . SAMPLE_CONCEPT_NAME(),
	EXPRESSION_ANALYSIS_METADATA_CONCEPT_TYPE	=>	EXPRESSION_CONCEPT_DOMAIN_NAME() . '.' . METADATA_CONCEPT_NAME(),
	GENE_EXPRESSION_ANALYSIS_DATA_CONCEPT_TYPE	=>	EXPG_CONCEPT_DOMAIN_NAME() . '.' . EXPG_CONCEPT_NAME(),
	
	REGULATORY_REGIONS_METADATA_CONCEPT_TYPE	=>	RREG_CONCEPT_DOMAIN_NAME() . '.' . METADATA_CONCEPT_NAME(),
	REGULATORY_REGIONS_DATA_CONCEPT_TYPE	=>	RREG_CONCEPT_DOMAIN_NAME() . '.' . RREG_CONCEPT_NAME(),
};

use constant {
	DONOR_ID	=>	'donor_id',
	SPECIMEN_ID	=>	'specimen_id',
	SAMPLE_ID	=>	'sample_id',
	EXPERIMENT_ID	=>	'experiment_id',
	ANALYSIS_ID	=>	'analysis_id',
};

use constant	ANALYZED_SAMPLE_ID	=>	'analyzed_'.SAMPLE_ID();

our %Concept2id = (
	DONOR_CONCEPT_TYPE()	=>	DONOR_ID(),
	SPECIMEN_CONCEPT_TYPE()	=>	SPECIMEN_ID(),
	SAMPLE_CONCEPT_TYPE()	=>	SAMPLE_ID(),
);

our %ConceptDomain2id = (
	LABORATORY_EXPERIMENTS_CONCEPT_DOMAIN_NAME()	=>	EXPERIMENT_ID(),
);

sub new($$) {
	# Very special case for multiple inheritance handling
	# This is the seed
	my($facet)=shift;
	my($class)=ref($facet) || $facet;
	
	my $iniFile = shift;
	my $ini = shift;
	
	$ini = Config::IniFiles->new( -file => $iniFile )  unless(defined($ini));
	
	Carp::croak("Second parameter must be an instance of Config::IniFiles")  unless(Scalar::Util::blessed($ini) && $ini->isa('Config::IniFiles'));
	
	my %href = ();
	
	$href{iniFile} = $iniFile;
	$href{ini} = $ini;
	$href{LOG} = Log::Log4perl->get_logger(__PACKAGE__);
	
	return bless(\%href,$class);
}

# It returns the data model
sub getModelFromDomain() {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getAvailableCVs() {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getCV($) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getCVterms($;\@) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getFilteredCVterms(\@) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getCVsFromColumn($$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getCVtermsFromColumn($$$;\@) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getAssemblies($;$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getSampleTrackingData($;$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getDonors($;$$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getSpecimens($;$$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getSpecimenIdsFromDonorIds($$$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$specimen_id,$p_filterFunc) = @_;
	
	return $self->getSpecimens($assembly_id,$specimen_id,boolean::true,DONOR_ID(),$p_filterFunc);
}

sub getSamples($;$$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getSampleIdsFromSpecimenIds($$$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$sample_id,$p_filterFunc) = @_;
	
	return $self->getSamples($assembly_id,$sample_id,boolean::true,SPECIMEN_ID(),$p_filterFunc);
}

sub getExperiments($;$$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getExperimentIdsFromSampleIds($$$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$experiment_id,$p_filterFunc) = @_;
	
	return $self->getExperiments($assembly_id,$experiment_id,boolean::true,ANALYZED_SAMPLE_ID(),$p_filterFunc);
}

sub getAnalysisMetadata($;$$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getAnalysisIdsFromExperimentIds($$$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$analysis_id,$p_filterFunc) = @_;
	
	return $self->getAnalysisMetadata($assembly_id,$analysis_id,boolean::true,EXPERIMENT_ID(),$p_filterFunc);
}

sub getGeneExpressionFromCompoundAnalysisIds($\@;\&) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getRegulatoryRegionsFromCompoundAnalysisIds($\@;\&) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getDataFromCoords($$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getDataStreamFromCoords($$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub fetchDataStream(\%) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getGenomicLayout($$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getGenomicLayoutFromCoords($$$$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$chromosome,$chromosome_start,$chromosome_end) = @_;
	
	my $rangeData = {
		'range'	=>	[
			{
				'chr'	=>	$chromosome,
				'start'	=>	$chromosome_start,
				'end'	=>	$chromosome_end
			}
		]
	};
	
	return $self->getGenomicLayout($assembly_id,$rangeData);
}

sub getDataCountFromCoords($$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub getDataStatsFromCoords($$$$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub queryFeatures($$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}

sub suggestFeatures($$) {
	Carp::croak((caller(0))[3]. 'is an unimplemented method!');
}




sub _fromAToZ($\@\@) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$p_compound_ids,$p_input_output_methods) = @_;
	
	my $p_compound_input_ids = $p_compound_ids;
	
	foreach my $p_input_output_method (@{$p_input_output_methods}) {
		last  if(scalar(@{$p_compound_input_ids}) == 0);
		
		my($input_id_name,$output_id_name,$from_to_method_name,$p_filter_method) = @{$p_input_output_method};
		
		my @input_ids = ();
		my %input_hash = ();
		
		foreach my $p_compound_input_id (@{$p_compound_input_ids}) {
			my $input_id = $p_compound_input_id->[-1];
			
			unless(exists($input_hash{$input_id})) {
				$input_hash{$input_id} = $p_compound_input_id;
				push(@input_ids,$input_id);
			}
		}
		
		my $p_res_output_ids = $self->$from_to_method_name($assembly_id,\@input_ids,$p_filter_method);
		
		my @compound_output_ids = ();
		foreach my $p_res_output_id (@{$p_res_output_ids}) {
			if(exists($input_hash{$p_res_output_id->{$input_id_name}})) {
				my $p_compound_output_id = [ @{$input_hash{$p_res_output_id->{$input_id_name}}}, $p_res_output_id->{$output_id_name} ];
				push(@compound_output_ids,$p_compound_output_id);
			}
		}
		
		$p_compound_input_ids = \@compound_output_ids;
	}
	
	return $p_compound_input_ids;
}

sub getCompoundAnalysisIdsFromCompoundAnalysisIds($\@) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$p_compound_analysis_ids) = @_;
		
	return (ANALYSIS_ID(),$self->_fromAToZ($assembly_id,$p_compound_analysis_ids,[]));
}

sub _FilterEntryByExpressionAnalysisMetadata($) {
	my($p_entry) = @_;
	
	return exists($p_entry->{TYPE_ID()}) && $p_entry->{TYPE_ID()} eq EXPRESSION_ANALYSIS_METADATA_CONCEPT_TYPE();
}

sub _FilterEntryByGeneExpressionAnalysisData($) {
	my($p_entry) = @_;
	
	return exists($p_entry->{TYPE_ID()}) && $p_entry->{TYPE_ID()} eq GENE_EXPRESSION_ANALYSIS_DATA_CONCEPT_TYPE();
}

sub _FilterEntryByRegulatoryRegionsMetadata($) {
	my($p_entry) = @_;
	
	return exists($p_entry->{TYPE_ID()}) && $p_entry->{TYPE_ID()} eq REGULATORY_REGIONS_METADATA_CONCEPT_TYPE();
}

sub _FilterEntryByRegulatoryRegionsData($) {
	my($p_entry) = @_;
	
	return exists($p_entry->{TYPE_ID()}) && $p_entry->{TYPE_ID()} eq REGULATORY_REGIONS_DATA_CONCEPT_TYPE();
}

sub getCompoundAnalysisIdsFromCompoundExperimentIds($\@;$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$p_compound_experiment_ids,$p_filterFunc) = @_;
		
	return (EXPERIMENT_ID(),$self->_fromAToZ($assembly_id,$p_compound_experiment_ids,[
			[EXPERIMENT_ID(),ANALYSIS_ID(),'getAnalysisIdsFromExperimentIds',$p_filterFunc],
		]));
}

sub getCompoundAnalysisIdsFromCompoundSampleIds($\@;$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$p_compound_sample_ids,$p_filterFunc) = @_;
		
	return (SAMPLE_ID(),$self->_fromAToZ($assembly_id,$p_compound_sample_ids,[
			[ANALYZED_SAMPLE_ID(),EXPERIMENT_ID(),'getExperimentIdsFromSampleIds',undef],
			[EXPERIMENT_ID(),ANALYSIS_ID(),'getAnalysisIdsFromExperimentIds',$p_filterFunc],
		]));
}

sub getCompoundAnalysisIdsFromCompoundDonorIds($\@;$) {
	my $self = shift;
	
	Carp::croak((caller(0))[3].' is an instance method!')  unless(ref($self));
	
	my($assembly_id,$p_compound_donor_ids,$p_filterFunc) = @_;
		
	return (DONOR_ID(),$self->_fromAToZ($assembly_id,$p_compound_donor_ids,[
			[DONOR_ID(),SPECIMEN_ID(),'getSpecimenIdsFromDonorIds',undef],
			[SPECIMEN_ID(),SAMPLE_ID(),'getSampleIdsFromSpecimenIds',undef],
			[ANALYZED_SAMPLE_ID(),EXPERIMENT_ID(),'getExperimentIdsFromSampleIds',undef],
			[EXPERIMENT_ID(),ANALYSIS_ID(),'getAnalysisIdsFromExperimentIds',$p_filterFunc],
		]));
}

1;
__END__

=encoding utf8

=head1 NAME

EPICO::REST::Backend - Abstract backend class for EPICO REST API

=head1 SYNOPSIS

=for markdown ```perl

    package EPICO::REST::Backend::NewBackend;
    
    use base qw(EPICO::REST::Backend);

=for markdown ```
    
=head1 DESCRIPTION

EPICO::REST::Backend is the backbone of the pluggable backends on EPICO REST API.

It was initially  created under the umbrella of L<BLUEPRINT project|https://blueprint-epigenome.eu>.

=head1 RATIONALE

Instead of having a monolithic API, EPICO REST API was designed thinking
both on different instances of the same implementation, as well as pluggable
instances for other external sources.

=head1 METHODS

I<(to be documented)>

=head1 INSTALLATION

Latest release of this package is available in the L<BSC INB DarkPAN|https://gitlab.bsc.es/inb/darkpan/>. You
can install it just using C<cpanm>:

=for markdown ```bash

  cpanm --mirror-only --mirror https://gitlab.bsc.es/inb/darkpan/raw/master/ --mirror https://cpan.metacpan.org/ EPICO::REST::Backend

=for markdown ```

=head1 AUTHOR

José M. Fernández L<https://github.com/jmfernandez>

=head1 COPYRIGHT

The library was initially created several years ago for the EPICO REST
API in the L<BLUEPRINT project|http://www.blueprint-epigenome.eu/>.

Copyright 2019- José M. Fernández & Barcelona Supercomputing Center (BSC)

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the LGPL 2.1 terms.

=head1 SEE ALSO

=cut
