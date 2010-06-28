package Quran::Image;

use strict;
use warnings;

use base qw/Quran/;

use GD;
use GD::Text;
use List::Util qw/min max/;
use File::Path qw/make_path/;

use constant FONT_DEFAULT => Quran::FONT_DIR .'/QCF_BSML.TTF';
use constant PHI => ((sqrt 5) + 1) / 2;
use constant phi => (((sqrt 5) + 1) / 2) - 1;

sub ayah {
	my $self = shift;
	if (!defined $self->{_ayah}) {
		use Quran::Image::Ayah;
		$self->{_ayah} = new Quran::Image::Ayah;
	}
	return $self->{_ayah};
}

sub page {
	my $self = shift;
	if (!defined $self->{_page}) {
		use Quran::Image::Page;
		$self->{_page} = new Quran::Image::Page;
	}
	return $self->{_page};
}

sub write {
	my ($self, $path, $file, $image) = @_;

	File::Path::make_path($path, {
		verbose => 1,
		mode => 0711
	});

	open PNG, ">$path/$file.png";
	binmode PNG;

	print PNG $image->png(0);

	return;
}

sub _is_mention_of_Allah {
	my ($self, $glyph_code, $page_number, $line_type) = @_;

	# don't highlight Allah in bismillah (for now)
	return 0 if defined $line_type and $line_type eq 'bismillah';

	my $lemma = $self->db->_get_word_val('lemma', $glyph_code, $page_number);

	return ($lemma eq '{ll~ah' or $lemma eq 'rab~')? 1 : 0;
}

1;
__END__
