class Follow < ApplicationRecord
    belongs_to :child
    belongs_to :immunization_schedule
end
