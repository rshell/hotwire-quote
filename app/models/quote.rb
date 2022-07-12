class Quote < ApplicationRecord
  validates :name, presence: true
  scope :ordered, -> { order(id: :desc) }
  belongs_to :company
  has_many :line_item_dates, dependent: :destroy

  delegate :name ,to: :company, prefix: true, allow_nil: true

  def path
    [company_name,name].join("/")
  end

  #after_create_commit -> { broadcast_prepend_later_to "quotes" }
  #after_update_commit -> { broadcast_replace_later_to "quotes" }
  #after_destroy_commit -> { broadcast_remove_to "quotes" }
  broadcasts_to ->(quote) { [quote.company, "quotes"] }, inserts_by: :prepend
end
