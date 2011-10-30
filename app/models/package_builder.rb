class PackageBuilder < ActiveRecord::Base

  validates_presence_of :url
  belongs_to :smoke_test, :polymorphic => true

  after_initialize :handle_after_init

  def handle_after_init
    if new_record? then
      self.merge_trunk = false
    end
  end

end
