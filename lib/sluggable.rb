module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug!
    class_attribute :slug_column
  end

  def generate_slug!
    the_slug = to_slug(self.send(self.class.slug_column.to_sym))
    the_orig_slug = the_slug
    obj = self.class.find_by slug: the_slug
    count = 2
    while obj && obj != self
      the_slug = the_orig_slug + '-' + count.to_s
      obj = self.class.find_by slug: the_slug
      count += 1
    end
    self.slug = the_slug
  end

  def to_slug(name)
    str = name.strip
    str.gsub! /\s*[^a-zA-Z0-9]\s*/, '-'
    str.gsub! /-+/, '-'
    str.downcase
  end

  def to_param
    self.slug
  end

  module ClassMethods
    def sluggable_column(col_name)
      self.slug_column = col_name
    end
  end
end