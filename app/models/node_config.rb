class NodeConfig < ActiveRecord::Base
    belongs_to :config_template
    validates_presence_of :hostname, :config_data
end
