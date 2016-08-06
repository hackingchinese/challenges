class UnitType < ApplicationRecord
  def completed_n_units(count)
    "#{verb_past} #{count} #{count == 1 ? singular : plural}"
  end

  def complete_n_units(count)
    "#{verb_present} #{count} #{count == 1 ? singular : plural}"
  end

  def complete_units
    "#{verb_present} #{plural}"
  end

  def completed_units
    "#{verb_past} #{plural}"
  end

  def units_completed
    "#{plural} #{verb_past}"
  end
end
