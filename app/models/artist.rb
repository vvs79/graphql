# == Schema Information
#
# Table name: artists
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null

class Artist < ApplicationRecord
  has_many :items, dependent: :destroy

  def full_name
    [first_name, last_name].compact.join(' ')
  end
end
