require 'test_helper'

class PageTest < ActiveSupport::TestCase
	def validates_reference_presence
		page = Page.sham! :build
		page.reference = nil
		refute page.valid?
		assert page.errors[:reference].include? I18n.t( 
      'activerecord.errors.models.page.attributes.reference.blank' )
	end

  def test_rejects_invalid_reference_formats
		page = Page.sham! :build
    [
      'invalid ref name', 
      'invalid()char@cter$',
      'invalid.name', 
      'invalid-na_me', 
      'invalid.na-me', 
      'Invalid', 
      'invalid_name'
    ].each do |reference|
			page.reference = reference
			refute page.valid?, 'should not accept ' + reference 
			assert page.errors[:reference].include? I18n.t( 
        'activerecord.errors.models.page.attributes.reference.invalid' )
		end
	end

  def test_accepts_valid_reference_formats
		page = Page.sham! :build
		[ 
      'validname', 
      'valid-name', 
      '5nizza-group', 
      'valid-name', 
      'valid-na-me' 
    ].each do |reference|
			page.reference = reference
			assert page.valid?, reference
		end
	end

  def test_validates_reference_uniqueness
		existing = Page.sham!
		page = Page.sham! :build
		[ existing.reference,
      existing.reference.upcase,
      existing.reference.capitalize,
      existing.reference.swapcase
    ].each do |u|
			page.reference = u
			refute page.valid?, u 
			assert page.errors[:reference].include? I18n.t( 
        'activerecord.errors.models.page.attributes.reference.taken' )
		end
	end

  def test_validates_title_presence
		page = Page.sham! :build
    [nil, '', ' '].each do |t|
      page.title = t
      refute page.valid?
      assert page.errors[:title].include? I18n.t( 
        'activerecord.errors.models.page.attributes.title.blank' )
    end
  end

  def test_validates_title_length
		page = Page.sham! :build
		page.title = 'a'*(Page::TITLE_MAX_LENGTH+1)
		refute page.valid?
		assert page.errors[:title].include? I18n.t( 
      'activerecord.errors.models.page.attributes.title.too_long' )

		page.title = 'a'*(Page::TITLE_MAX_LENGTH)
		assert page.valid?
	end
end

