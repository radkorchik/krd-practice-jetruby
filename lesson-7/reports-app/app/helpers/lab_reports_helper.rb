# frozen_string_literal: true

module LabReportsHelper
  def ects_grade_options
    [ [ "— не выставлена —", "" ] ] + LabReport::ECTS_GRADES.map { |g| [ g, g ] }
  end
end
