class Character

  def to_s
    "A Character"
  end

  def to_xml
    "<character>#{to_s}</character>"
  end

end
# ------------------------------------------------------------------------
class PlayerCharacter < Character

  def to_s
    "A Player Character"
  end

end