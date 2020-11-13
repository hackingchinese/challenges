class BaseGrid
  include Datagrid

  self.default_column_options = {
    # Uncomment to disable the default order
    # order: false,
    # Uncomment to make all columns HTML by default
    # html: true,
  }
  # Enable forbidden attributes protection
  # self.forbidden_attributes_protection = true

  def self.date_column(name, *args)
    column(name, *args) do |model|
      format(block_given? ? yield : model.send(name)) do |date|
        date&.to_date
      end
    end
  end

  def self.boolean_column(name, *args)
    column(name, *args) do |model|
      format(block_given? ? yield : model.send(name)) do |value|
        if value == true
          "Yes"
        elsif value == false
          "No"
        else
          ""
        end
      end
    end
  end
end
