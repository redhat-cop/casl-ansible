
# Helper function to simplify the 'filter_applier_items' below
def filter_content(content_dict, outer_list, filter_list):
    # If tags don't exists at all, just remove the 'content'
    if 'tags' not in content_dict:
        outer_list.remove(content_dict)
        return

    # Find out of if any of the tags exists in the 'content' section
    intersect_list = [val for val in content_dict['tags'] if val in filter_list]

    # If none of the filter tags exists, remove it from the list
    if len(intersect_list) == 0:
        outer_list.remove(content_dict)
    

# Main 'filter_applier_items' function
def filter_applier_items(applier_list, filter_tags):
    # If no filter tags supplied - just return list as-is
    if len(filter_tags.strip()) == 0:
        return applier_list

    # Convert comma seperated list to an actual list and strip off whitespaces of each element 
    filter_list = filter_tags.split(",")
    filter_list = [i.strip() for i in filter_list]

    # Loop through the main list to check tags
    # - use a copy to allow for elements to be removed at the same time as we iterrate
    for a in applier_list[:]:
        # Handle the 'content' entries
        if 'content' in a:
            for c in a['content'][:]:
                filter_content(c, a['content'], filter_list)

            if len(a['content']) == 0:
                applier_list.remove(a)		 

        # Handle the 'content_dir' entries
        elif 'content_dir' in a:
            filter_content(a, applier_list, filter_list)

    return applier_list



class FilterModule(object):
    ''' Filters to handle openshift_cluster_content data '''
    def filters(self):
        return {
            'filter_applier_items': filter_applier_items
        }

