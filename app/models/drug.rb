# Drug Model
class Drug < ActiveRecord::Base
  self.table_name   = 'drug'
  self.primary_key  = 'drugID'

  def self.search(term)
    where(
      'LOWER(drugID) LIKE :term',
      term: "%#{term.downcase}%"
    )
  end
end
