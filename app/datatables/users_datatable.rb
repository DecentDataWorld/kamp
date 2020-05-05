class UsersDatatable
  delegate :params, :h, :link_to, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: User.count,
        iTotalDisplayRecords: users.total_entries,
        aaData: data
    }
  end

  private

  def data
    users.map do |user|
      user.user_organizations.each do |user_org|
        org_string.nil? ? org_string = '<a href="/organizations/'+user_org.organization.url+'">'+user_org.organization.name+'</a> ('+user_org.role+')' : org_string = org_string + "<br><a href="/organizations/'+user_org.organization.url+'">'+user_org.organization.name+'</a> ('+user_org.role+')"
      end
      [
          '<a href="/users/'+user.id.to_s+'">'+user.name+'</a>',
          user.email,
          org_string.nil? ? '' : org_string,
          user.created_at.in_time_zone("Eastern Time (US & Canada)").strftime("%b %d %Y %I:%M:%S %p %Z"),
          user.updated_at.in_time_zone("Eastern Time (US & Canada)").strftime("%b %d %Y %I:%M:%S %p %Z"),
          !user.webhook_id.nil? ? '<a href="/webhook_event_requests/'+user.webhook_id.to_s+'.json" target="_blank">View Webhook</a>' : '',
          user.msi_project_id,
          '<a href="https://web.fulcrumapp.com/records/'+user.foreign_id+'" target="_blank">View in Fulcrum <i class="fa fa-external-link"></i></a>',
          '<a data-confirm="Are you sure?" data-placement="bottom" data-toggle="tooltip" data-title="Mark this user as fixed" href="/import_users/mark_processed/'+user.id.to_s+'" data-original-title="" title=""><i class="fa fa-check-circle"></i> Complete</a>',
          user.reason,
          '<a data-confirm="This will resync this record. Are you sure you want to continue?" data-placement="bottom" data-toggle="tooltip" data-title="Resync this record" href="/verifications/sync_record?id='+user.foreign_id.to_s+'" data-original-title="" title="">Resync</a>',
          link_to("Del", user, method: :delete, data: { confirm: 'Are you sure?' })
      ]
    end
  end

  def users
    @users ||= fetch_users
  end

  def fetch_users
    users = User.order("updated_at desc")
    users = users.page(page).per_page(per_page)
    if params[:sSearch].present?
      users = users.where("LOWER(email) like :search", search: "%#{params[:sSearch].downcase}%")
    end
    users
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 10
  end

  def sort_column
    columns = %w[email]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end