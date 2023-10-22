class Child < ApplicationRecord
    has_many :immunizations
    has_many :immunization_schedules
    has_many :follows
end

