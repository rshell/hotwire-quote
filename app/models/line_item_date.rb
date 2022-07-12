class LineItemDate < ApplicationRecord
  belongs_to :quote
  validates :date, presence: true, uniqueness: { scope: :quote_id }
  has_many :line_items, dependent: :destroy

  scope :ordered, -> { order(date: :asc) }

  def previous_date
    quote.line_item_dates.ordered.where("date < ?", date).last
  end

  def total_price
    line_items.sum(&:total_price)
  end

end
