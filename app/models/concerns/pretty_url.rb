module PrettyUrl
  extend ActiveSupport::Concern

  included do
    before_save :update_url_name
  end

  def to_param
    url_name
  end

  private
  def update_url_name
    self.url_name = name.parameterize if name_changed? and !url_name_changed?    
  end

end