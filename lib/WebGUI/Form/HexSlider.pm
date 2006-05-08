package WebGUI::Form::HexSlider;

=head1 LEGAL

 -------------------------------------------------------------------
  WebGUI is Copyright 2001-2006 Plain Black Corporation.
 -------------------------------------------------------------------
  Please read the legal notices (docs/legal.txt) and the license
  (docs/license.txt) that came with this distribution before using
  this software.
 -------------------------------------------------------------------
  http://www.plainblack.com                     info@plainblack.com
 -------------------------------------------------------------------

=cut

use strict;
use base 'WebGUI::Form::Slider';
use WebGUI::International;

=head1 NAME

Package WebGUI::Form::HexSlider

=head1 DESCRIPTION

Creates a slider control that controls hex values, as in the red, gree, blue values for HTML colors.

=head1 SEE ALSO

This is a subclass of WebGUI::Form::Control.

=head1 METHODS 

The following methods are specifically available from this class. Check the superclass for additional methods.

=cut

#-------------------------------------------------------------------

=head2 definition ( [ additionalTerms ] )

See the super class for additional details.

=head3 additionalTerms

The following additional parameters have been added via this sub class.

=head4 maximum

Defaults to "ff". The maximum that the slider can go to.

=head4 minimum

Defaults to "00". The minimum value that the slider can go to.

=head4 size

The length of the input box.

=head4 padLength

Pad the value to padLength characters by adding zeros in front if necesarry.

=head4 profileEnabled

Flag that tells the User Profile system that this is a valid form element in a User Profile


=cut

sub definition {
	my $class = shift;
	my $session = shift;
	my $definition = shift || [];
	my $i18n = WebGUI::International->new($session);
	push(@{$definition}, {
		formName=>{
			defaultValue=> $i18n->get("hex slider")
			},
		maximum=>{
			defaultValue=> "ff",
			},
		minimum=>{
			defaultValue=> "00",
			},
		size=>{
			defaultValue=>11,
			},
		padLength=>{
			defaultValue=>"2",
			},
		profileEnabled=>{
			defaultValue=>1
			},
		});
        return $class->SUPER::definition($session, $definition);
}

#-------------------------------------------------------------------
=head2 getInputElement

Returns the form element used for manual input.

=cut

sub getInputElement {
	my $self = shift;

	return WebGUI::Form::hexadecimal($self->session, {
		name	=> $self->get('name'),
		value	=> $self->get('value'),
		size	=> $self->get('size'),
		id	=> 'view-'.$self->get('id'),
	});
}

#-------------------------------------------------------------------
=head2 getOnChangeInputElement

Returns the javascript code to update the slider and other form elements on a
change of the imput element.

=cut

sub getOnChangeInputElement {
	my $self = shift;
	
	my $padLength = $self->get('padLength');
	
	return 
		'while (this.value.length < '.$padLength.') { '.
			'this.value = \'0\' + this.value'.
		'};'.
		$self->getSliderVariable.'.setValue(parseInt(this.value,16));'.
		$self->getDisplayVariable.'.innerHTML = this.value';
}

#-------------------------------------------------------------------
=head2 getOnChangeSlider

Returns the javascript code to update the form on a change of slider position.

=cut

sub getOnChangeSlider {
	my $self = shift;
	
	my $padLength = $self->get('padLength');
	
	return 
		$self->getInputVariable.'.value = this.getValue().toString(16);'.
		'while ('.$self->getInputVariable.'.value.length < '.$padLength.') { '.
			$self->getInputVariable.'.value = \'0\' + '.$self->getInputVariable.'.value'.
		'};'.
		$self->getDisplayVariable.'.innerHTML = this.getValue().toString(16);';
}

#-------------------------------------------------------------------
=head2 getSliderMaximum

Returns the maximum value the slider can be set to in slider units.

=cut

sub getSliderMaximum {
	my $self = shift;

	return scalar(keys %{$self->get('options')}) - 1;
}

#-------------------------------------------------------------------
=head2 getSliderMaximum

Returns the minimum value the slider can be set to in slider units.

=cut

sub getSliderMaximum {
	my $self = shift;

	return hex($self->get('maximum'));
}

#-------------------------------------------------------------------
=head2 getSliderMaximum

Returns the minimum value the slider can be set to in slider units.

=cut

sub getSliderMinimum {
	my $self = shift;

	return hex($self->get('minimum'));
}

#-------------------------------------------------------------------
=head2 getSliderValue

Returns the initial position of the slider in slider units.

=cut

sub getSliderValue {
	my $self = shift;

	return hex($self->get('value'));
}

#-------------------------------------------------------------------
=head2 getValueFromPost ( )

Retrieves a value from a form GET or POST and returns it. If the value comes back as undef, this method will return the defaultValue instead.  Strip newlines/carriage returns from the value.

=cut

sub getValueFromPost {
	my $self = shift;

	my $properties = {
		name	=> $self->get('name'),
		value	=> $self->get('value'),
		size	=> $self->get('size'),
		id	=> 'view-'.$self->get('id'),
	};
	
	return WebGUI::Form::hexadecimal->new($self->session, $properties)->getValueFromPost;
}

1;
