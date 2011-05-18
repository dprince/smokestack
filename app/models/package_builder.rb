class PackageBuilder < ActiveRecord::Base

  validates_presence_of :url
  belongs_to :smoke_test, :polymorphic => true

end
