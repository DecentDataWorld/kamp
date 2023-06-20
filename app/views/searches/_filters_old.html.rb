

<%
   # check for existing tags in query string
  existing_tag_facets = []
  if params[:tags].present?
    existing_tag_facets = params[:tags]
  end

  @tag_facet_links_off = ''
  tag_facet_links_off_counter = 1
  @tag_facet_links_on = ''

  @tags.each do |t| 
    if !existing_tag_facets.include? t["id"].to_s
      tag_facets = existing_tag_facets + [t["id"].to_s]
      @tag_facet_links_off << "<li class='available-tags pb-1'>#{link_to t["name"], update_search_path(request.parameters.merge(:tags => tag_facets))} (#{t["tag_count"]}) </li>"
      tag_facet_links_off_counter = tag_facet_links_off_counter + 1
    else
      tag_facets = existing_tag_facets - [t["id"].to_s]
      updated_params = request.parameters.merge(:tags => tag_facets).except(:page)
      @tag_facet_links_on << "<span class='badge rounded-pill bg-secondary dark-badge-link'>#{link_to raw("<i class='fa fa-times'></i> " + t["name"]), update_search_path(updated_params)}</span> &nbsp;"
    end
  end

%>

<div class="border-bottom" id="tags" data-step="1" data-intro="Click 'More Tags' to see all available tags" data-position="top">
  <% if @tag_facet_links_off.length > 0 %>
    <div>Available Tags:</div>
  <% end %>

    <ul class="list-unstyled ps-2">
      <%= raw @tag_facet_links_off %>
    </ul>

  <% if tag_facet_links_off_counter > 8 %>
      <div class="text-center"><a class="expandTagsList"><i class="fa fa-arrow-circle-down"></i> More Tags</a></div>
  <% end %>
</div>


<div class="pt-3">
  <div>Uploaded By:</div>
  <%= render partial: 'collections/facet_org' %>
</div>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function() {
    var tagsList = document.querySelectorAll('#tags li');
    
    for (var i = 15; i < tagsList.length; i++) {
        tagsList[i].style.display = 'none';
    }
  
    
    var expandTagsButton = document.querySelector('#tags .expandTagsList');
    
    expandTagsButton.addEventListener('click', function() {
        var moreTagsIcon = '<i class="fa fa-arrow-circle-down"></i> More Tags';
        var lessTagsIcon = '<i class="fa fa-arrow-circle-up"></i> Less Tags';
        
        var hiddenTags = document.querySelectorAll('#tags li:nth-child(n+10)');
        
        if (this.innerHTML === moreTagsIcon) {
            for (var i = 0; i < hiddenTags.length; i++) {
                hiddenTags[i].style.display = 'block';
            }
            
            this.innerHTML = lessTagsIcon;
        } else {
            for (var i = 0; i < hiddenTags.length; i++) {
                hiddenTags[i].style.display = 'none';
            }
            
            this.innerHTML = moreTagsIcon;
        }
    });
});
</script>

