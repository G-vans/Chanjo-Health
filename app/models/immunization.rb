class Immunization < ApplicationRecord
  belongs_to :child
  belongs_to :medic
end
