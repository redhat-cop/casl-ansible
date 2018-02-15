def update_namespace(object_list, append_value):
  for i in object_list:
    for key_a in i:
      if key_a == 'content':
        for j in i[key_a]:
          if 'namespace' in j:
            j['namespace'] += append_value 

  return object_list

class FilterModule(object):
  def filters(self):
    return {
      'update_namespace': update_namespace
    }
