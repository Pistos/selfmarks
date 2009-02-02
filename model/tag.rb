class Tag < DBI::Model( :tags )
  def to_s
    name
  end
end