class ApplicationDatatable
  def initialize(view)
    @view = view
  end

  def as_json(options: {})
    {
        recordsTotal: count,
        recordsFiltered: total_entries,
        data: data
    }
  end
end