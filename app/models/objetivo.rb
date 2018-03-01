class Objetivo < ActiveRecord::Base
  belongs_to :variable
  belongs_to :user
end
