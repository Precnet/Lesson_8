# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    super.send(:attr_accessor, names)
  end
end
