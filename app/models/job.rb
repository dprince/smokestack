class Job < ActiveRecord::Base

  belongs_to :smoke_test
  validates_presence_of :script
  after_initialize :handle_after_init

  def handle_after_init
    if new_record? then
      self.status = "Pending"
    end
  end

end
