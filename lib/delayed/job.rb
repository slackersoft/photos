class Delayed::Job < ActiveRecord::Base
  include Delayed::Backend::Base
end
